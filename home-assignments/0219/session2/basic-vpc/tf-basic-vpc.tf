provider "aws" {
    shared_credentials_file = "/home/hbeyhan/.aws/credentials"
    region = "us-east-1"
}

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_subnet" "public1" {
    vpc_id = "${aws_vpc.my-vpc.id}"
    availability_zone = "us-east-1a"
    cidr_block = "10.0.0.0/24"
}


resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.my-vpc.id}"
}


resource "aws_route_table" "public-route-tbl" {
    vpc_id = "${aws_vpc.my-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}


resource "aws_route_table_association" "public1-assoc" {
    subnet_id = "${aws_subnet.public1.id}"
    route_table_id = "${aws_route_table.public-route-tbl.id}"
}


resource "aws_security_group" "sg-public" {
  name        = "sgpublic"
  description = "Rules for public net"
  vpc_id      = "${aws_vpc.my-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "public1" {
    ami = "ami-0ac019f4fcb7cb7e6"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.public1.id}"
    associate_public_ip_address = true
    security_groups = ["${aws_security_group.sg-public.id}"]
    key_name = "my-rsakey"
}


output "public1_ip" {
    value = "${aws_instance.public1.public_ip}"
}





