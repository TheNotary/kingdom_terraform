variable "personal_site_domain" {}
variable "route53_zone_id" {}

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

resource "aws_route53_record" "personal_site_a_me" {
  type    = "A"
  name    = "me.${var.personal_site_domain}"
  records = ["127.0.0.1"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "300"
}

resource "aws_route53_record" "personal_site_cname_dev" {
  type    = "CNAME"
  name    = "dev"
  records = ["initialfantasy.herokuapp.com"]
  zone_id = "${var.route53_zone_id}"
  ttl     = "5"
}

