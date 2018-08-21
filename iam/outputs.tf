output "autoscaling_role" {
  value = "${aws_iam_role.ecs_autoscaling.arn}"
}

