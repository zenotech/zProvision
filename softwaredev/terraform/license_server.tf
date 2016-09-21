resource "aws_security_group" "license_server_access" {
    provider = "aws.eu-west-1"
    name = "SoftwareLicenseAccess"
    description = "SoftwareDev License server access security group"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    egress {
        from_port = 28000
        to_port = 28001
        protocol = "tcp"
        cidr_blocks = [
           "10.2.3.4/32"
        ]
    }
}

resource "aws_security_group" "lic" {
    provider = "aws.eu-west-1"
    name = "SoftwareDevLic"
    description = "SoftwareDev Lic instance security group"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"

    ingress {
        from_port = 28000
        to_port = 28001
        protocol = "tcp"
        security_groups = [
            "${aws_security_group.license_server_access.id}"
        ]
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
    key_name = "admin"
    instance_type = "t2.nano"
    private_ip = "10.2.3.4"
    subnet_id = "${aws_subnet.eu-west-1c.id}"
    vpc_security_group_ids = ["${aws_security_group.internalssh.id}", "${aws_security_group.lic.id}"]
    tags {
        Name = "LicenseServer"
        Product = "SoftwareDev"
    }
}

resource "aws_subnet" "dev-lic" {
    provider = "aws.eu-west-1"
    availability_zone = "${aws_instance.dev-lic-server.availability_zone}"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    cidr_block = "10.2.255.0/28"
    tags {
        Name = "Licensing"
    }
}

resource "aws_network_interface" "dev-lic-interface" {
    provider = "aws.eu-west-1"

    subnet_id = "${aws_subnet.dev-lic.id}"
    attachment {
       instance = "${aws_instance.dev-lic-server.id}"
       device_index = 1
    }
    lifecycle {
        prevent_destroy = true
    }
}
