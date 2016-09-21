provider "aws" {
    region = "eu-west-1"
    alias = "eu-west-1"
}

resource "aws_key_pair" "admin" {
    provider = "aws.eu-west-1"
    key_name = "admin"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyWloRBekWajRqnVzAvWSkkypWxmTijBsbHO85CpGnH0pfLRymHzBIEad1aQOdq4nh3D6XLYb+3m3NyexV8f3ygIcVgA44ktRSWeNFDnMIPpDMXD/Q2mveRSuyOLXZk0Btnhp8ucmyxkHrLnoPAH3B8HhLzTG37P76IqXwvXFpXlImoikVYHpqivlvSJ7IYIsiGmF6zr+SJdHqXiba6+a57r+McsDLMO5J4nxRNYkTGNSqFHKRuX0P9dFrTB4i7JJ/cB2I0yQgfUVJs/LU6zQiGmjYptLGNhqgAqTGFXFdXRbTd27+n1DiwXWfKyQLr+9lRdzmVRfC6udPkIU/kQnn"
}

resource "aws_vpc" "software-dev-eu-west-1" {
    provider = "aws.eu-west-1"
    cidr_block = "10.2.0.0/16"
    enable_dns_hostnames = true

    tags {
        Name = "SoftwareDev"
        Product = "SoftwareDev"
    }
}

resource "aws_internet_gateway" "gw" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"

    tags {
        Name = "SoftwareDev"
    }
}

resource "aws_subnet" "eu-west-1a" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    availability_zone = "eu-west-1a"
    cidr_block = "10.2.1.0/24"

    tags {
        Name = "SoftwareDev-Private-1a"
    }
}

resource "aws_subnet" "eu-west-1b" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    availability_zone = "eu-west-1b"
    cidr_block = "10.2.2.0/24"

    tags {
        Name = "SoftwareDev-Private-1b"
    }
}

resource "aws_subnet" "eu-west-1c" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    availability_zone = "eu-west-1c"
    cidr_block = "10.2.3.0/24"

    tags {
        Name = "SoftwareDev-Private-1c"
    }
}

resource "aws_subnet" "public" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    availability_zone = "eu-west-1c"
    cidr_block = "10.2.0.0/24"
    tags {
        Name = "SoftwareDev-Public"
    }
}

resource "aws_route_table" "public" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"

    route {
        cidr_block = "10.1.0.0/16"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.directory.id}"
    }

    route {
         cidr_block = "0.0.0.0/0"
         gateway_id = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_route_table_association" "public" {
    provider = "aws.eu-west-1"
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}


