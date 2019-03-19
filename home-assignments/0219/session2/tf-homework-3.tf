provider "aws" {
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
    cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private1" {
    vpc_id = "${aws_vpc.my-vpc.id}"
    availability_zone = "us-east-1a"
    cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "public2" {
    vpc_id = "${aws_vpc.my-vpc.id}"
    availability_zone = "us-east-1b"
    cidr_block = "10.0.3.0/24"
}

resource "aws_subnet" "private2" {
    vpc_id = "${aws_vpc.my-vpc.id}"
    availability_zone = "us-east-1b"
    cidr_block = "10.0.4.0/24"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.my-vpc.id}"
}

resource "aws_eip" "ngw-eip" {}

resource "aws_nat_gateway" "ngw" {
    subnet_id = "${aws_subnet.public1.id}"
    allocation_id = "${aws_eip.ngw-eip.id}"
}

resource "aws_route_table" "public-route-tbl" {
    vpc_id = "${aws_vpc.my-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

resource "aws_route_table" "private-route-tbl" {
    vpc_id = "${aws_vpc.my-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.ngw.id}"
    }
}

resource "aws_route_table_association" "public1-assoc" {
    subnet_id = "${aws_subnet.public1.id}"
    route_table_id = "${aws_route_table.public-route-tbl.id}"
}

resource "aws_route_table_association" "private1-assoc" {
    subnet_id = "${aws_subnet.private1.id}"
    route_table_id = "${aws_route_table.private-route-tbl.id}"
}

resource "aws_route_table_association" "public2-assoc" {
    subnet_id = "${aws_subnet.public2.id}"
    route_table_id = "${aws_route_table.public-route-tbl.id}"
}

resource "aws_route_table_association" "private2-assoc" {
    subnet_id = "${aws_subnet.private2.id}"
    route_table_id = "${aws_route_table.private-route-tbl.id}"
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
resource "aws_security_group" "sg-private" {
  name        = "sgprivate"
  description = "Rules for private net"
  vpc_id      = "${aws_vpc.my-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
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
    key_name = "id_rsa"
}

resource "aws_instance" "private1" {
    ami = "ami-0ac019f4fcb7cb7e6"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.private1.id}"
    security_groups = ["${aws_security_group.sg-private.id}"]
}

resource "aws_instance" "public2" {
    ami = "ami-0ac019f4fcb7cb7e6"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.public2.id}"
    associate_public_ip_address = true
    security_groups = ["${aws_security_group.sg-public.id}"]
    key_name = "id_rsa"
}

resource "aws_instance" "private2" {
    ami = "ami-0ac019f4fcb7cb7e6"
    instance_type = "t2.micro"
    subnet_id = "${aws_subnet.private2.id}"
    security_groups = ["${aws_security_group.sg-private.id}"]
}

output "public1_ip" {
    value = "${aws_instance.public1.public_ip}"
}

output "private1_ip" {
    value = "${aws_instance.private1.private_ip}"
}

output "public2_ip" {
    value = "${aws_instance.public2.public_ip}"
}

output "private2_ip" {
    value = "${aws_instance.private2.private_ip}"
}






