# Set the variable value in *.tfvars file
# or using -var="digitalocean_token=..." CLI option
variable "digitalocean_token" {}

provider "digitalocean" {
	token = "${var.digitalocean_token}"
}

resource "digitalocean_ssh_key" "default" {
	name       = "Terraform"
	public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "digitalocean_droplet" "minecraft" {
	image  = "ubuntu-16-04-x64"
	name   = "minecraft"
	region = "nyc1"
	size   = "512mb"

	ssh_keys = [
		"${digitalocean_ssh_key.default.id}"
    ]

    connection {
		user = "root"
	}

	provisioner "local-exec" {
		command = "bash build.sh"
	}

	provisioner "remote-exec" {
		inline = [
			"mkdir /opt/minecraft",
			"mkdir /opt/minecraft/.aws"
		]
	}

	provisioner "file" {
		content = "[default]\nregion = ${aws_s3_bucket.backup.region}"
		destination = "/opt/minecraft/.aws/config"
	}

	provisioner "file" {
		content = "[default]\naws_access_key_id = ${aws_iam_access_key.backup.id}\naws_secret_access_key = ${aws_iam_access_key.backup.secret}"
		destination = "/opt/minecraft/.aws/credentials"
	}

	provisioner "file" {
		source = "spigot.jar"
		destination = "/opt/minecraft/spigot.jar"
	}

	provisioner "file" {
		source = "server.properties"
		destination = "/opt/minecraft/server.properties"
	}

	provisioner "file" {
		source = "backup.sh"
		destination = "/opt/minecraft/backup.sh"
	}

	provisioner "file" {
		source = "minecraft.service"
		destination = "/etc/systemd/system/minecraft.service"
	}

	provisioner "file" {
		source = "minecraft-backup.service"
		destination = "/etc/systemd/system/minecraft-backup.service"
	}

	provisioner "file" {
		source = "minecraft-backup.timer"
		destination = "/etc/systemd/system/minecraft-backup.timer"
	}

	provisioner "remote-exec" {
    	script = "setup.sh"
  	}

}

resource "digitalocean_floating_ip" "minecraft" {
	droplet_id = "${digitalocean_droplet.minecraft.id}"
	region     = "${digitalocean_droplet.minecraft.region}"
}