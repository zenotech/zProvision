provider "aws" {
    region = "eu-west-1"
    alias = "eu-west-1"
}


resource "aws_vpc" "software-dev-eu-west-1" {
    provider = "aws.eu-west-1"
    cidr_block = "10.1.0.0/16"

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

resource "aws_key_pair" "epic_key" {
    provider = "aws.eu-west-1"
    key_name = "epic_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbEqJYwnNis6KNPAEF4eWw2KLTqJUuwr2s0H9VUkl7vrFQlO9mv+F5tcgRaZadkUMzQiGoLL1P/JNbfMKxk5TWf2BJmBTweK00eJB7ypTl/LuI16rKhcSRDg1lwkxTMIIN8fxar7JdY77HZtWS/h57a0cnVejIofshToVeeO0lI5UoanZuJQxzsphEavMvKKYcES3jyWTG8luf/+mUQ4zI2SgxyHxkKlriVE4u0g9dsZEcFIXPMHyVJATWoTqcOqAdpnP/iUiaGXwoct4YvwU/BmuUjx0HNdOw+gnudAba0iusXmSW2oRkh4WBzHZkB1VRuJ/3jJYB70BLa4eF5FvN jamessharpe@Jamess-MacBook.local"
}

resource "aws_subnet" "eu-west-1a" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    availability_zone = "eu-west-1a"
    cidr_block = "10.1.1.0/24"

    tags {
        Name = "Main"
    }
}

resource "aws_subnet" "eu-west-1b" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    availability_zone = "eu-west-1b"
    cidr_block = "10.1.2.0/24"

    tags {
        Name = "Main"
    }
}

resource "aws_subnet" "eu-west-1c" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    availability_zone = "eu-west-1c"
    cidr_block = "10.1.3.0/24"

    tags {
        Name = "Main"
    }
}

resource "aws_subnet" "public" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    availability_zone = "eu-west-1c"
    cidr_block = "10.1.0.0/24"

    tags {
        Name = "SoftwareDev-Public"
    }
}


resource "aws_route_table" "private" {
    provider = "aws.eu-west-1"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
    route {
        cidr_block = "10.0.0.0/16"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.softwaredevpeer.id}"
    }
}

resource "aws_vpc_peering_connection" "softwaredevpeer" {
    provider = "aws.eu-west-1"
    peer_owner_id = "017581815832"
    peer_vpc_id = "vpc-27a47342"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"
    auto_accept = true

}

resource "aws_instance" "dev-lic-server" {
    provider = "aws.eu-west-1"
    ami = "ami-e9a42e9a"
    instance_type = "t2.nano"
    subnet_id = "${aws_subnet.eu-west-1c.id}"
    tags {
        Name = "LicenseServer"
        Product = "SoftwareDev"
    }
}

resource "aws_security_group" "nat" {
    provider = "aws.eu-west-1"
    name = "SoftwareDevNat"
    description = "SoftwareDev NAT instance security group"
    vpc_id = "${aws_vpc.software-dev-eu-west-1.id}"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.1.0.0/16"]
    }
    ingress {
        from_port = 443
        to_port = 443
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
}

resource "aws_instance" "nat" {
    provider = "aws.eu-west-1"
    ami = "ami-a2971ed1"
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

#resource "aws_instance" "bastion" {
#    provider = "aws.eu-west-1"
#    ami = "ami-f95ef58a"
#    instance_type = "t2.nano"
#    subnet_id = "${aws_subnet.eu-west-1c.id}"
#    associate_public_ip_address = true
#    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
#    tags {
#        Name = "Bastion"
#        Product = "SoftwareDev"
#    }
#}

resource "aws_launch_configuration" "spot_build_node" {
    provider = "aws.eu-west-1"
    name = "build node"
    image_id = "ami-73008100"
    instance_type = "m4.4xlarge"
    spot_price = "0.40"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "build" {
    provider = "aws.eu-west-1"
    name = "build-asg"
    launch_configuration = "${aws_launch_configuration.spot_build_node.name}"

    min_size = 0
    max_size = 4
    desired_capacity = 0
    force_delete = true

    vpc_zone_identifier = ["${aws_subnet.eu-west-1c.id}"]

    tag {
        key = "Product"
        value = "SoftwareDev"
        propagate_at_launch = true
    }
}
