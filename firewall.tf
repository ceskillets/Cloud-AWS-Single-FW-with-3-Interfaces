resource "random_id" "bucket_prefix" {
  byte_length = 4
}

resource "aws_s3_bucket" "bootstrap_bucket" {
  #bucket_prefix = "${var.bucket_prefix}"
  bucket        = "single-pafw-skillet-vpc-${lower(random_id.bucket_prefix.hex)}"
  acl           = "private"
  force_destroy = true

  tags = {
    Name = "bootstrap_bucket"
  }
}

resource "aws_s3_bucket_object" "bootstrap_xml" {
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  bucket     = "single-pafw-skillet-vpc-${lower(random_id.bucket_prefix.hex)}"
  acl        = "private"
  key        = "config/bootstrap.xml"
  source     = "bootstrap/bootstrap.xml"
}

resource "aws_s3_bucket_object" "init-cft_txt" {
  bucket     = "single-pafw-skillet-vpc-${lower(random_id.bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "config/init-cfg.txt"
  source     = "bootstrap/init-cfg.txt"
}

resource "aws_s3_bucket_object" "software" {
  bucket     = "single-pafw-skillet-vpc-${lower(random_id.bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "software/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "license" {
  bucket     = "single-pafw-skillet-vpc-${lower(random_id.bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "license/"
  source     = "/dev/null"
}

resource "aws_s3_bucket_object" "content" {
  bucket     = "single-pafw-skillet-vpc-${lower(random_id.bucket_prefix.hex)}"
  depends_on = ["aws_s3_bucket.bootstrap_bucket"]
  acl        = "private"
  key        = "content/"
  source     = "/dev/null"
}


resource "random_id" "bootstraprole" {
  byte_length = 3
}

resource "random_id" "bootstrappolicy" {
  byte_length = 3
}

resource "random_id" "bootstrapinstanceprofile" {
  byte_length = 3
}

resource "aws_iam_role" "bootstraprole" {
  name = "bootstraprole-${random_id.bootstraprole.hex}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "bootstrappolicy" {
  name = "bootstrappolicy${random_id.bootstrappolicy.hex}"
  role = "${aws_iam_role.bootstraprole.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.bootstrap_bucket.bucket}"
    },
    {
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${aws_s3_bucket.bootstrap_bucket.bucket}/*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bootstrapinstanceprofile" {
  name = "bootstrapinstanceprofile${random_id.bootstrapinstanceprofile.hex}"
  role = "${aws_iam_role.bootstraprole.name}"
  path = "/"
}

resource "aws_network_interface" "FW1-MGT" {
  subnet_id         = "${aws_subnet.mgmt-subnet.id}"
  security_groups   = ["${aws_security_group.allow-mgmt-security-group.id}"]
  source_dest_check = false
  private_ips       = ["${var.pavm_mgmt_private_ip}"]
}

resource "aws_network_interface" "FW1-UNTRUST" {
  subnet_id         = "${aws_subnet.untrust-subnet.id}"
  security_groups   = ["${aws_security_group.allowall-security-group.id}"]
  source_dest_check = false
  private_ips       = ["${var.pavm_untrust_private_ip}"]
}

resource "aws_eip_association" "FW1-UNTRUST-Association" {
  network_interface_id = "${aws_network_interface.FW1-UNTRUST.id}"
  allocation_id        = "${aws_eip.FW1-PUB.id}"
}

resource "aws_network_interface" "FW1-TRUST" {
  subnet_id         = "${aws_subnet.trust-subnet.id}"
  security_groups   = ["${aws_security_group.allowall-security-group.id}"]
  source_dest_check = false
  private_ips       = ["${var.pavm_trust_private_ip}"]
}

resource "aws_eip_association" "FW1-MGT-Association" {
  network_interface_id = "${aws_network_interface.FW1-MGT.id}"
  allocation_id        = "${aws_eip.FW1-MGT.id}"
}

#Deploys the firewalls

resource "aws_instance" "PA-VM1" {
  tags = {
    Name = "NGFW"
  }

  disable_api_termination = false

  iam_instance_profile = "${aws_iam_instance_profile.bootstrapinstanceprofile.name}"
  ebs_optimized        = true
  ami                  = "${lookup(var.PANFWRegionMap_payg_bun2_ami_id, var.region)}"
  instance_type        = "${var.pavm_instance_type}"

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_type           = "gp2"
    delete_on_termination = true
    volume_size           = 60
  }

  key_name   = "${var.pavm_key_name}"
  monitoring = false

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.FW1-MGT.id}"
  }

  network_interface {
    device_index         = 1
    network_interface_id = "${aws_network_interface.FW1-UNTRUST.id}"
  }

  network_interface {
    device_index         = 2
    network_interface_id = "${aws_network_interface.FW1-TRUST.id}"
  }

  user_data = "${base64encode(join("", list("vmseries-bootstrap-aws-s3bucket=", "${aws_s3_bucket.bootstrap_bucket.bucket}")))}"
}