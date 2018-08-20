output "repository_url" {
  value = "${aws_ecr_repository.clj_app.repository_url}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.fargate.name}"
}

output "service_name" {
  value = "${aws_ecs_service.web_service.name}"
}

output "alb_dns_name" {
  value = "${aws_alb.alb_clj_app.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.alb_clj_app.zone_id}"
}

output "security_group_id" {
  value = "${aws_security_group.ecs_service.id}"
}
