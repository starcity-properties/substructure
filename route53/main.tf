terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


# ZONES

resource "aws_route53_zone" "selected" {
  name = "${var.domain_name}"

  force_destroy = true

  tags {
    Environment = "${var.environment}"
  }
}


# RECORDS

resource "aws_route53_record" "ns" {
  name    = "${aws_route53_zone.selected.name}"
  zone_id = "${aws_route53_zone.selected.zone_id}"
  type    = "NS"
  ttl     = "300"

  records = [
    "${aws_route53_zone.selected.name_servers.0}",
    "${aws_route53_zone.selected.name_servers.1}",
    "${aws_route53_zone.selected.name_servers.2}",
    "${aws_route53_zone.selected.name_servers.3}",
  ]

  alias {
    name                   = "${aws_elb.main.dns_name}"
    zone_id                = "${aws_elb.main.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  name    = "www.${aws_route53_zone.selected.name}"
  zone_id = "${aws_route53_zone.selected.zone_id}"
  type    = "A"
  ttl     = "300"

  records = [
    "54.69.58.12",
    "54.149.238.10"
  ]
}