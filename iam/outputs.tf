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

output "datomic_peer_role" {
  value = "${aws_iam_role.datomic_peer.name}"
}

output "consul_vault_profile" {
  value = "${aws_iam_instance_profile.cault.name}"
}

output "consul_vault_role" {
  value = "${aws_iam_role.cault.name}"
}

output "codepipeline_artifacts_bucket" {
  value = "${aws_s3_bucket.artifacts.bucket}"
}

output "codepipeline_role" {
  value = "${aws_iam_role.codepipeline.arn}"
}

output "codebuild_role" {
  value = "${aws_iam_role.codebuild.arn}"
}

output "codedeploy_role" {
  value = "${aws_iam_role.codedeploy.arn}"
}
