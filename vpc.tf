# AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

# Create VPC
resource "aws_vpc" "single-pafw-skillet-vpc" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_support = true
    enable_dns_hostnames = false
    instance_tenancy = "${var.vpc_instance_tenancy}"
    
    tags = {
        Name = "${var.vpc_name}"
    }
}

# Create Subnets
resource "aws_subnet" "mgmt-subnet" {
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    cidr_block = "${var.mgmt_subnet_cidr_block}"
    availability_zone = "${var.availability_zone}"
    map_public_ip_on_launch = false

    tags = {
        Name = "mgmt-subnet"
    }
}

resource "aws_subnet" "trust-subnet" {
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    cidr_block = "${var.trust_subnet_cidr_block}"
    availability_zone = "${var.availability_zone}"
    map_public_ip_on_launch = false
    
    tags = {
        Name = "trust-subnet"
    }
}

resource "aws_subnet" "untrust-subnet" {
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    cidr_block = "${var.untrust_subnet_cidr_block}"
    availability_zone = "${var.availability_zone}"
    map_public_ip_on_launch = true

    tags = {
        Name = "untrust-subnet"
    }
}
# AWS IGW
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    tags = {
        Name = "Internet Gateway"
    }
}

# Route Tables

##MGMT
resource "aws_route_table" "mgmt-routetable" {
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    tags = {
        Name = "mgmt-routetable"
    }
}

resource "aws_route" "mgmt-default-route" {
    route_table_id = "${aws_route_table.mgmt-routetable.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
    depends_on = [
        "aws_route_table.mgmt-routetable",
        "aws_internet_gateway.igw"
    ]
}

##UNTRUST
resource "aws_route_table" "untrust-routetable" {
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    tags = {
        Name = "untrust-routetable"
    }
}

resource "aws_route" "untrust-default-route" {
    route_table_id = "${aws_route_table.untrust-routetable.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
    depends_on = [
        "aws_route_table.untrust-routetable",
        "aws_internet_gateway.igw"
    ]
}

##TRUST
resource "aws_route_table" "trust-routetable" {
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    tags = {
        Name = "trust-routetable"
    }
}

resource "aws_route" "trust-default-route" {
    route_table_id = "${aws_route_table.trust-routetable.id}"
    destination_cidr_block = "0.0.0.0/0"
    network_interface_id = "${aws_network_interface.FW1-TRUST.id}"
    depends_on = [
        "aws_route_table.trust-routetable",
        "aws_instance.PA-VM1"
    ]
}

# Associations

resource "aws_route_table_association" "mgmt-routetable-association" {
    subnet_id = "${aws_subnet.mgmt-subnet.id}"
    route_table_id = "${aws_route_table.mgmt-routetable.id}"
}

resource "aws_route_table_association" "untrust-routetable-association" {
    subnet_id = "${aws_subnet.untrust-subnet.id}"
    route_table_id = "${aws_route_table.untrust-routetable.id}"
}

resource "aws_route_table_association" "trust-routetable-association" {
    subnet_id = "${aws_subnet.trust-subnet.id}"
    route_table_id = "${aws_route_table.trust-routetable.id}"
}

#Network ACL's
resource "aws_network_acl" "allowall-network-acl" {
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    egress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    subnet_ids = [
        "${aws_subnet.mgmt-subnet.id}",
        "${aws_subnet.untrust-subnet.id}",
        "${aws_subnet.trust-subnet.id}"
    ]
    tags = {
        Name = "acl-allow-all"
    }
}

#Security Groups
resource "aws_security_group" "allowall-security-group" {
    name = "secggroup-allow-all"
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    description = "Allow all inbound traffic"
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg-allow-all"
    }
}

resource "aws_security_group" "allow-mgmt-security-group" {
    name = "secggroup-mgmt-allow"
    vpc_id = "${aws_vpc.single-pafw-skillet-vpc.id}"
    description = "Allow all HTTPS/SSH inbound traffic"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg-mgmt-allow"
    }
}