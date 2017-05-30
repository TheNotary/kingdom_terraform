# This .tf is for creating the cloud resources required by the sample rails app
# we'll be pushing to our dokku service

variable "environment" { default = "dev" }


############
# iam User #
############

resource "aws_iam_user" "eff_fab" {
  name = "eff_fab_${var.environment}"
  path = "/apps/"
}

resource "aws_iam_access_key" "eff_fab" {
  user = "${aws_iam_user.eff_fab.name}"
}

resource "aws_iam_user_policy" "eff_fab_email" {
  name = "eff_fab_email"
  user = "${aws_iam_user.eff_fab.name}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": ["ses:SendRawEmail"],
      "Effect": "Allow",
      "Resource": [ "*" ]
    }
  ]
}
EOF
}


#############
# S3 Bucket #
#############

resource "aws_iam_user_policy" "eff_fab_bucket_admin" {
  name = "eff_fab_bucket_admin"
  user = "${aws_iam_user.eff_fab.name}"

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
        "${aws_s3_bucket.eff_fab.arn}",
        "${aws_s3_bucket.eff_fab.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_bucket" "eff_fab" {
  bucket = "eff-fab-${var.environment}"
  acl    = "private"

  tags {
    Name        = "eff_fab"
    Environment = "${var.environment}"
  }

  force_destroy = true # enables terraform deleting non-empty buckets
}


#############
# SES Stuff #
#############

provider "aws" {
  alias  = "mail"
  region = "us-west-2"
}


resource "aws_ses_domain_identity" "personal_site" {
  provider = "aws.mail"
  domain = "${var.personal_site_domain}"
}

resource "aws_route53_record" "mail_verification_record" {
  zone_id = "${var.route53_zone_id}"
  name    = "_amazonses.${var.personal_site_domain}"
  type    = "TXT"
  ttl     = "5"
  records = ["${aws_ses_domain_identity.personal_site.verification_token}"]
}
