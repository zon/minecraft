variable "digitalocean_token" {}

variable "aws_profile" {
	description = "Name of your profile inside ~/.aws/credentials"
	default = "default"
}

variable "aws_region" {
	description = "Defines where your app should be deployed"
	default = "us-east-2"
}

variable "ssh_key_path" {
 	description = "SSH public key path"
 	default = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_name" {
	description = "Desired name of AWS key pair"
	default = "minecraft-terraform"
}

provider "aws" {
	profile = "${var.aws_profile}"
	region = "${var.aws_region}"
}

resource "aws_key_pair" "auth" {
	key_name = "${var.ssh_key_name}"
	public_key = "${file(var.ssh_key_path)}"
}