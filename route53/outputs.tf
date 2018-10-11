output "route53_public_zone_name" {
  value = "${aws_route53_zone.selected.name}"
}

output "route53_public_zone_id" {
  value = "${aws_route53_zone.selected.zone_id}"
}

# NOTE: This output goes into GoDaddy.
output "name_servers" {
  value = "${aws_route53_zone.selected.name_servers}"
}
