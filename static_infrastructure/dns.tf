variable "region" { default = "us-west-1" }
variable "personal_site_domain" { }
variable "access_key" {}
variable "secret_key" {}

# Setup terraform to work with amazon aws with the appropriate user/ region combo
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_route53_zone" "personal_site" {
  name     = "${var.personal_site_domain}"
  lifecycle { prevent_destroy = true }
}

