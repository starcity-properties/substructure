output "route53_public_zone_id" {
  value = "${aws_route53_zone.selected.zone_id}"
}

output "name_servers" {
  value = "${aws_route53_zone.selected.name_servers}"
}
