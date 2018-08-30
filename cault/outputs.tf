output "elb_dns" {
  value = "${aws_elb.cault.dns_name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.consul_vault_cluster.name}"
}

output "cluster_size" {
  value = "${aws_autoscaling_group.consul_vault_cluster.desired_capacity}"
}

output "launch_config_name" {
  value = "${aws_launch_configuration.consul_vault.name}"
}

output "iam_role_arn" {
  value = "${aws_iam_role.cault_service.arn}"
}

output "iam_role_id" {
  value = "${aws_iam_role.cault_service.id}"
}

output "cluster_tag_key" {
  value = "${var.cluster_tag_key}"
}

output "cluster_tag_value" {
  value = "${var.cluster_tag_value}"
}
