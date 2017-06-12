variable "region" { default = "us-west-1" }
variable "personal_site_domain" { }
variable "access_key" {}
variable "secret_key" {}
variable "environment" {}
variable "user" {}


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

resource "aws_iam_user" "personal_site" {
  name = "personal_site_${var.environment}"
  path = "/system/"
}

resource "aws_iam_user_policy" "personal_site_bucket_admin" {
  name = "personal_site_bucket_admin_${var.environment}"
  user = "${aws_iam_user.personal_site.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.personal_site_data.arn}",
        "${aws_s3_bucket.personal_site_data.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "personal_site" {
  user = "${aws_iam_user.personal_site.name}"
}


resource "aws_s3_bucket" "personal_site_data" {
  bucket = "personal-site-data-${var.user}-${var.environment}"
  acl    = "private"

  tags {
    Name        = "personal_site"
    Environment = "${var.environment}"
    key = "personal-site-data-${var.environment}"
  }
  lifecycle { prevent_destroy = true }
}
