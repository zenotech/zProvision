resource "aws_security_group" "nat" {
    provider = "aws.eu-west-1"
    name = "SoftwareDevNat"
    description = "SoftwareDev NAT instance security group"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.2.0.0/16"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["10.2.0.0/16"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.2.0.0/16"]
    }
    ingress {
        from_port = 9418
        to_port = 9418
        protocol = "tcp"
        cidr_blocks = ["10.2.0.0/16"]
    }



    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 9418
        to_port = 9418
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "nat" {
    provider = "aws.eu-west-1"
    ami = "ami-a2971ed1"
    key_name = "admin"
    instance_type = "t2.nano"
    source_dest_check = false
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    tags {
        Name = "Nat"
        Product = "SoftwareDev"
    }
}

resource "aws_route_table" "private" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"

    route {
        cidr_block = "10.1.0.0/16"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.directory.id}"
    }

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
}

resource "aws_route_table_association" "private-1a" {
    provider = "aws.eu-west-1"
    subnet_id = "${aws_subnet.eu-west-1a.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private-1b" {
    provider = "aws.eu-west-1"
    subnet_id = "${aws_subnet.eu-west-1b.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private-1c" {
    provider = "aws.eu-west-1"
    subnet_id = "${aws_subnet.eu-west-1c.id}"
    route_table_id = "${aws_route_table.private.id}"
}


