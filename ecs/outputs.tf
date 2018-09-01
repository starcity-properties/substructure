output "cluster_name" {
  value = "${aws_ecs_cluster.fargate.name}"
}

output "service_name" {
  value = "${aws_ecs_service.service.name}"
}

output "lb_dns_name" {
  value = "${aws_lb.app.dns_name}"
}

output "lb_zone_id" {
  value = "${aws_lb.app.zone_id}"
}
