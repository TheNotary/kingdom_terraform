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
