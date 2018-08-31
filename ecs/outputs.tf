output "cluster_name" {
  value = "${aws_ecs_cluster.fargate.name}"
}

output "service_name" {
  value = "${aws_ecs_service.web_service.name}"
}

output "security_group_id" {
  value = "${aws_security_group.ecs_service.id}"
}

output "lb_dns_name" {
  value = "${aws_lb.app.dns_name}"
}

output "lb_zone_id" {
  value = "${aws_lb.app.zone_id}"
}
