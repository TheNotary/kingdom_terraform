# Change this to your desired region
variable "region" {
  default = "us-west-1"
}

variable "pub_key_path" {}
variable "priv_key_path" {}
variable "access_key" {}
variable "secret_key" {}
variable "ubuntu_amis" {type = "map"}
variable "ami" {}
variable "personal_site_domain" {}

# Setup terraform to work with amazon aws with the appropriate user/ region combo
provider "aws" "prod" {
  #alias = "prod"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

# Setup a key that can be used to ssh into EC2 instances
resource "aws_key_pair" "personal_site" {
  key_name   = "personal-aws_rsa"
  public_key = "${file(var.pub_key_path)}"
}

# Setup a security group that is attached to an EC2 instance, allowing inboud SSH connections
resource "aws_security_group" "wide_open" {
  name = "wide_open"
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

  # mumble tcp
  ingress = {
    from_port = 64738
    to_port = 64738
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    self = false
  }

  # mumble udp
  ingress = {
    from_port = 64738
    to_port = 64738
    protocol = "udp"
    cidr_blocks = [ "0.0.0.0/0" ]
    self = false
  }


  # allow outbound to everywhere, on everything...
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}


# Spins up an actual EC2 Instance, it's terraform id is 'personal_site'
resource "aws_instance" "personal_site" {
  tags = {
    Name = "personal_site" # set's the label in aws console
    Description = "Handles the logic involved in my personal website."
  }

  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.personal_site.id}"

  security_groups = [
    "${aws_security_group.wide_open.name}"
  ]

  # This info allows terraform to connect to the server and provision it
  connection {
    user = "admin"
    private_key = "${file(var.priv_key_path)}"
  }

  provisioner "file" {
    source      = "keys/default-dokku_rsa"
    destination = "/home/admin/.ssh/default-dokku_rsa"
  }

  provisioner "file" {
    source      = "keys/default-dokku_rsa.pub"
    destination = "/home/admin/.ssh/default-dokku_rsa.pub"
  }

  # this allows terraform to run commands after the EC2 instance boots up
  provisioner "remote-exec" {
    inline = "mkdir /home/admin/scripts"
  }

  provisioner "file" {
    source = "common/change_hostname.sh"
    destination = "/home/admin/scripts/change_hostname.sh"
  }

  provisioner "file" {
    source = "personal_site/provision.sh"
    destination = "/home/admin/scripts/provision.sh"
  }

  # Here's where we have terraform actually setup the box for us
  provisioner "remote-exec" {
    inline = [
      "chmod 0600 /home/admin/.ssh/*_rsa",
      "chmod 0755 /home/admin/scripts/provision.sh",
      "chmod 0755 /home/admin/scripts/change_hostname.sh",
      "sudo bash -l /home/admin/scripts/change_hostname.sh ${var.personal_site_domain}",
      "bash -l /home/admin/scripts/provision.sh ${var.personal_site_domain}"
    ]
  }

}


resource "aws_eip" "personal_site" {
  instance = "${aws_instance.personal_site.id}"
  # This will update your /etc/hosts file so you don't have to waste cash on a static ip for no good reason
  #provisioner "local-exec" {
  #  command = "./common/update_hosts.sh personal.dev ${aws_eip.personal_site.public_ip}"
  #}
}
