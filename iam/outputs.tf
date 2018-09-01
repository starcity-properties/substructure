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

output "ecs_execution_role_id" {
  value = "${aws_iam_role.ecs_execution.unique_id}"
}

output "ecs_task_policy" {
  value = "${aws_iam_policy.ecs_task.arn}"
}
