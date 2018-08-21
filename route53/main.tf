terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


# ZONES

resource "aws_route53_zone" "primary" {
  name = "${var.domain_name}"

  tags {
    Environment = "production"
  }
}

resource "aws_route53_zone" "stage" {
  name       = "staging.${var.domain_name}"
  vpc_region = "${var.aws_region}"
  vpc_id     = "${data.terraform_remote_state.vpc.vpc_id}"

  force_destroy = true

  tags {
    Environment = "staging"
  }
}

resource "aws_route53_zone" "dev" {
  name       = "dev.${var.domain_name}"
  vpc_region = "${var.aws_region}"
  vpc_id     = "${data.terraform_remote_state.vpc.vpc_id}"

  force_destroy = true

  tags {
    Environment = "development"
  }
}


# RECORDS

resource "aws_route53_record" "stage_ns" {
  zone_id = "${aws_route53_zone.stage.zone_id}"
  name    = "staging.${var.domain_name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.stage.name_servers.0}",
    "${aws_route53_zone.stage.name_servers.1}",
    "${aws_route53_zone.stage.name_servers.2}",
    "${aws_route53_zone.stage.name_servers.3}",
  ]
}

resource "aws_route53_record" "dev_ns" {
  zone_id = "${aws_route53_zone.dev.zone_id}"
  name    = "dev.${var.domain_name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.dev.name_servers.0}",
    "${aws_route53_zone.dev.name_servers.1}",
    "${aws_route53_zone.dev.name_servers.2}",
    "${aws_route53_zone.dev.name_servers.3}",
  ]
}

resource "aws_route53_record" "cault" {
  zone_id = "${aws_route53_zone.dev.zone_id}"
  name    = "cault.${var.domain_name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.dev.name_servers.0}",
    "${aws_route53_zone.dev.name_servers.1}",
    "${aws_route53_zone.dev.name_servers.2}",
    "${aws_route53_zone.dev.name_servers.3}",
  ]
}
