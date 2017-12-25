data "aws_ami" "ubuntu" {
	most_recent = true

	filter {
		name = "name"
		values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
	}

	filter {
		name = "virtualization-type"
		values = ["hvm"]
	}

	owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "minecraft" {
	name = "minecraft"

	ingress {
		from_port = 25565
		to_port = 25565
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}


# resource "aws_ebs_volume" "world" {
# 	availability_zone = "${var.aws_region}"
# 	type = "gp2"
# 	size = 5

# 	tags {
# 		Name = "minecraft-world"
# 	}
# }

resource "aws_instance" "server" {
	ami           = "${data.aws_ami.ubuntu.id}"
	instance_type = "t2.micro"
	security_groups = ["${aws_security_group.minecraft.name}"]

	key_name = "${aws_key_pair.auth.id}"
	connection {
		user = "ubuntu"
	}

	provisioner "local-exec" {
		command = "bash build.sh"
	}

	provisioner "file" {
		source = "build"
		destination = "/home/ubuntu"
	}

	provisioner "remote-exec" {
		script = "setup.sh"
	}

	tags {
		Name = "minecraft"
	}
}

data "aws_route53_zone" "main" {
	name = "${var.domain}."
}

resource "aws_route53_record" "a" {
	zone_id = "${data.aws_route53_zone.main.zone_id}"
	name = "${data.aws_route53_zone.main.name}"
	type = "A"
	ttl = "30"
	records = ["${aws_instance.server.public_ip}"]
}

resource "aws_route53_record" "minecraft_a" {
	zone_id = "${data.aws_route53_zone.main.zone_id}"
	name = "minecraft.${data.aws_route53_zone.main.name}"
	type = "A"
	ttl = "30"
	records = ["${aws_instance.server.public_ip}"]
}