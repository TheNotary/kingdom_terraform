variable "region" {
  default = "us-west-1"
}
variable "access_key" {}
variable "secret_key" {}
variable "ubuntu_amis" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

resource "aws_instance" "web" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.nano"
}
