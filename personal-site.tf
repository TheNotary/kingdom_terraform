# Change this to your desired region
variable "region" {
  default = "us-west-1"
}

variable "key_path" {}
variable "access_key" {}
variable "secret_key" {}
variable "ubuntu_amis" {type = "map"}
variable "ami" {}

# Setup terraform to work with amazon aws with the appropriate user/ region combo
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

# Setup a key that can be used to ssh into EC2 instances
resource "aws_key_pair" "personal-aws" {
  key_name   = "personal-aws_rsa"
  public_key = "${file(var.key_path)}"
}

# Setup a security group that is attached to an EC2 instance, allowing inboud SSH connections
resource "aws_security_group" "wide-open" {
  name = "wide-open"
  description = "Allows SSH connections in from any IP address"

  # SSH
  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    self = false
  }

  # web
  ingress = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    self = false
  }

  # web
  ingress = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    self = false
  }

  # allow outbound to everywhere, on everything...
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    # prefix_list_ids = ["pl-12c4e678"]
  }

}


# Spins up an actual EC2 Instance, it's terraform id is 'personal-site'
resource "aws_instance" "personal-site" {
  tags = {
    Name = "personal-site" # set's the label in aws console
    Description = "Handles the logic involved in my personal website."
  }

  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.nano"
  key_name = "${aws_key_pair.personal-aws.id}"

  security_groups = ["${aws_security_group.wide-open.name}"]
  connection {
    user = "admin"
  }
}
