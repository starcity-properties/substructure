output "dev_administrator_policy_arn" {
  value = "${aws_iam_policy.dev_admin.arn}"
}

output "stage_administrator_policy_arn" {
  value = "${aws_iam_policy.stage_admin.arn}"
}

output "prod_administrator_policy_arn" {
  value = "${aws_iam_policy.prod_admin.arn}"
}
