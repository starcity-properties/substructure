output "ecs_service_role" {
  value = "${aws_iam_role.ecs_service.arn}"
}

output "ecs_execution_role" {
  value = "${aws_iam_role.ecs_execution.arn}"
}

output "ecs_task_role" {
  value = "${aws_iam_role.ecs_task.arn}"
}

output "ecs_autoscaling_role" {
  value = "${aws_iam_role.ecs_autoscaling.arn}"
}
