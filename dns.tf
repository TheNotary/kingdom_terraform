variable "dns_name_prefix" {
  default = ""
}


# TODO: see if I can rename this to personal.dev w/out breaking referencing it
resource "aws_route53_zone" "personal" {
  name = "personal.dev"
}

resource "aws_route53_record" "www.personal.dev" {
  zone_id = "${aws_route53_zone.personal.id}"
  name    = "${var.dns_name_prefix}www.personal.dev"
  type    = "A"

  alias {
    name    = "www.personal.dev"
    # zone_id = "${aws_elb.www.zone_id}"
    evaluate_target_health = false
  }
}
