# This resource is handled in another repository, so I can run an un-targeted destory and
# Don't incur any downtime due to nameservers needing to be changed via my domain name
# registrar for my personal site.  Note that instead of the variable "${var.route53_zone_id}"
# we would use "${aws_route53_zone.zone_id}" if we were actually tracking this resource in
# this terraform code-base
#resource "aws_route53_zone" "personal_site" {
#  provider = "aws"
#  name = "${var.personal_site_domain}"
#
#  lifecycle { prevent_destroy = true }
#}

# prd: "me.example.com"
# stg: "stg.me.example.com"
# name = "${var.environment_subdomain}"
resource "aws_route53_record" "personal_site_a_me" {
  type    = "A"
  name    = "me.${var.environment_subdomain}${var.personal_site_domain}"
  records = ["${aws_eip.personal_site.public_ip}"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "300"
}

resource "aws_route53_record" "personal_site_a_dev" {
  type    = "A"
  name    = "dev.${var.environment_subdomain}${var.personal_site_domain}"
  records = ["${aws_eip.personal_site.public_ip}"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "5"
}

resource "aws_route53_record" "personal_site_a_admin" {
  type    = "A"
  name    = "admin.${var.environment_subdomain}${var.personal_site_domain}"
  records = ["${aws_eip.personal_site.public_ip}"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "5"
}

# Dokku App
resource "aws_route53_record" "personal_site_a_eff_fab" {
  type    = "A"
  name    = "eff-fab.${var.environment_subdomain}${var.personal_site_domain}"
  records = ["${aws_eip.personal_site.public_ip}"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "5"
}

resource "aws_route53_record" "personal_site_a_coms" {
  type    = "A"
  name    = "coms.${var.environment_subdomain}${var.personal_site_domain}"
  records = ["${aws_eip.personal_site.public_ip}"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "5"
}

# You can push your app to this subdomain, and config your ssh to
# use the user 'dokku'
resource "aws_route53_record" "personal_site_a_dokku" {
  type    = "A"
  name    = "dokku.${var.environment_subdomain}${var.personal_site_domain}"
  records = ["${aws_eip.personal_site.public_ip}"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "5"
}

resource "aws_route53_record" "personal_site_a_xpd3" {
  type    = "A"
  name    = "xpd3.${var.environment_subdomain}${var.personal_site_domain}"
  records = ["${aws_eip.personal_site.public_ip}"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "5"
}


