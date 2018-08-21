output "route53_zone_id_stage" {
  value = "${aws_route53_zone.stage.id}"
}

output "route53_zone_id_dev" {
  value = "${aws_route53_zone.dev.id}"
}
