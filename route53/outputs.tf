output "route53_public_zone_name" {
  value = "${aws_route53_zone.selected.name}"
}

output "route53_public_zone_id" {
  value = "${aws_route53_zone.selected.zone_id}"
}

output "route53_private_zone_name" {
  value = "${aws_route53_zone.private.name}"
}

output "route53_private_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}

# NOTE: This output goes into GoDaddy.
output "public_name_servers" {
  value = "${aws_route53_zone.selected.name_servers}"
}

output "private_name_servers" {
  value = "${aws_route53_zone.private.name_servers}"
}
