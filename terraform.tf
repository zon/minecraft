# Set the variable value in *.tfvars file
# or using -var="digitalocean_token=..." CLI option
variable "digitalocean_token" {}

# Configure the DigitalOcean Provider
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
		inline = ["mkdir /opt/minecraft"]
	}

	provisioner "file" {
		source = "spigot.jar"
		destination = "/opt/minecraft/spigot.jar"
	}

	provisioner "file" {
		source      = "minecraft.service"
		destination = "/etc/systemd/system/minecraft.service"
	}

	provisioner "remote-exec" {
    	script = "setup.sh"
  	}

}