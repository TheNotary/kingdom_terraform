variable "personal_site_domain" {}
variable "dns_name_prefix" {
  default = ""  # Could be "dev." or "stage." or something else
}


resource "aws_route53_zone" "personal_site" {
  provider = "aws"
  name = "${var.personal_site_domain}"           # personal.dev
}


# 'A' record
resource "aws_route53_record" "personal_site_www" {
  zone_id = "${aws_route53_zone.personal_site.zone_id}"
  name    = "www.${var.personal_site_domain}"
  type    = "A"
  ttl     = "300"
  records = ["127.0.0.1"]
}


# 'CNAME' record
# For some reason, this must be manually deleted...
resource "aws_route53_record" "personal_site_cname" {
  zone_id = "${aws_route53_zone.personal_site.zone_id}"
  name    = "@"
  type    = "CNAME"
  ttl     = "5"
  records = ["initialfantasy.herokuapp.com"]
}


# www.personal.dev
#resource "aws_route53_record" "www_personal_dev" {
#  zone_id = "${aws_route53_zone.personal_dev.zone_id}"
#  name    = "personal.dev"
#  type    = "A"
#
#  alias {
#    name    = "www.personal.dev"  # this is the domain the user will key in
#    zone_id = "${aws_route53_zone.personal_dev.zone_id}"
#    evaluate_target_health = false
#  }
#}

## personal.dev
#resource "aws_route53_record" "www_personal_dev" {
#  zone_id = "${aws_route53_zone.personal_dev.zone_id}"
#  name    = "personal.dev"
#  type    = "A"
#
#  alias {
#    name    = "personal.dev"
#    zone_id = "${aws_route53_zone.personal_dev.zone_id}"
#    evaluate_target_health = false
#  }
#}
