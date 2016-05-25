resource "aws_security_group" "lic" {
    provider = "aws.eu-west-1"
    name = "SoftwareDevLic"
    description = "SoftwareDev Lic instance security group"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.1.0.0/16"]
    }
    ingress {
        from_port = 28000
        to_port = 28001
        protocol = "tcp"
        cidr_blocks = ["10.1.0.0/16"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.1.0.0/16"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_instance" "dev-lic-server" {
    provider = "aws.eu-west-1"
    ami = "ami-e9a42e9a"
    instance_type = "t2.nano"
    subnet_id = "${aws_subnet.eu-west-1c.id}"
    vpc_security_group_ids = ["${aws_security_group.lic.id}"]
    tags {
        Name = "LicenseServer"
        Product = "SoftwareDev"
    }
}

