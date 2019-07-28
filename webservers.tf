resource "aws_network_interface" "web1-int" {
  subnet_id         = "${aws_subnet.trust-subnet.id}"
  security_groups   = ["${aws_security_group.allowall-security-group.id}"]
  source_dest_check = false
  private_ips       = ["${var.webserver_private_ip}"]
}

resource "aws_instance" "web1" {
  # instance_initiated_shutdown_behavior = "stop"
  ami           = "${var.UbuntuRegionMap[var.region]}"
  instance_type = "t2.micro"
  key_name      = "${var.pavm_key_name}"
  monitoring    = false

  tags = {
    Name = "WEBSERVER"
  }

  network_interface {
    device_index         = 0
    network_interface_id = "${aws_network_interface.web1-int.id}"
  }

  user_data = "${file("install_apache.sh")}"
}