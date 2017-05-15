variable "dns_name_prefix" {
  default = ""  # Could be "dev." or "stage." or something else
}


resource "aws_route53_zone" "personal_dev" {
  provider = "aws"
  name = "personal.dev"
}


resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.personal_dev.zone_id}"
  name    = "www.personal.dev"
  type    = "A"
  ttl     = "300"
  records = ["127.0.0.1"]
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
