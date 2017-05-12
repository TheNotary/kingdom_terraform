# Change this to your desired region
variable "region" {
  default = "us-west-1"
}

variable "access_key" {}
variable "secret_key" {}
variable "ubuntu_amis" {type = "map"}
variable "ami" {}

# Set up terraform to work with amazon aws with the appropriate user/ region combo
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}


# Spins up an actual EC2 Instance, it's terraform id is 'personal-site'
resource "aws_instance" "personal-site" {
  #ami = "${var.ami}"
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.nano"

  connection = {
    user = "admin"
    private_key = "${file(keys/personal-aws_rsa)}"
  }

  tags = {
    Name = "personal-site" # set's the label in aws console
  }

}
