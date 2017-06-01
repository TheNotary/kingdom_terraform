# This .tf is for creating the cloud resources required by the sample rails app
# we'll be pushing to our dokku service

variable "environment" { default = "dev" }
data "aws_caller_identity" "current" {}


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

resource "aws_s3_bucket" "eff_fab_emails" {
  bucket = "eff-fab-emails-${var.environment}"
  acl    = "private"

  tags {
    Name        = "eff_fab"
    Environment = "${var.environment}"
  }

  force_destroy = true # enables terraform deleting non-empty buckets
}

resource "aws_s3_bucket_policy" "eff_fab_emails_store" {
  bucket = "${aws_s3_bucket.eff_fab_emails.id}"

  policy = <<POLICY
{
	"Version": "2008-10-17",
	"Statement": [
		{
			"Sid": "GiveSESPermissionToWriteEmail",
			"Effect": "Allow",
			"Principal": {
				"Service": [
					"ses.amazonaws.com"
				]
			},
			"Action": [
				"s3:PutObject"
			],
			"Resource": "${aws_s3_bucket.eff_fab_emails.arn}/*",
			"Condition": {
				"StringEquals": {
					"aws:Referer": "${data.aws_caller_identity.current.account_id}"
				}
			}
		}
	]
}
POLICY
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
	domain = "${var.environment_subdomain}${var.personal_site_domain}"
}

resource "aws_route53_record" "mail_verification_record" {
	zone_id = "${var.route53_zone_id}"
	name    = "_amazonses.${var.environment_subdomain}${var.personal_site_domain}"
	type    = "TXT"
	ttl     = "5"
	records = ["${aws_ses_domain_identity.personal_site.verification_token}"]
}

resource "aws_route53_record" "mx" {
	zone_id = "${var.route53_zone_id}"
	name = "${var.environment_subdomain}${var.personal_site_domain}"
	type = "MX"
	ttl = "5"  # TODO: change to 300 or more someday
	records = [
    "10 inbound-smtp.us-west-2.amazonaws.com"
  ]
}


# Add a header to the email and store it in S3
resource "aws_ses_receipt_rule" "store" {
	provider = "aws.mail"
	name          = "store-${var.environment}"
	rule_set_name = "${aws_ses_active_receipt_rule_set.default_rule_set.rule_set_name}"
	recipients    = ["admin@${var.environment_subdomain}${var.personal_site_domain}"]
	enabled       = true
	scan_enabled  = true

	s3_action {
		bucket_name = "${aws_s3_bucket.eff_fab_emails.id}"
		position = 0
	}
}

resource "aws_ses_receipt_rule_set" "default_rule_set" {
  provider = "aws.mail"
  rule_set_name = "default-rule-set-${var.environment}"
}

# FIXME:  This could lead to problems with states across environments
# Are SES email rules going to be another one of those "keep it in a separate repo" issues?
resource "aws_ses_active_receipt_rule_set" "default_rule_set" {
  provider = "aws.mail"
  rule_set_name = "default-rule-set-${var.environment}"
}



