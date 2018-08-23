output "dev_administrator_policy_arn" {
  value = "${aws_iam_policy.dev_admin.arn}"
}

output "stage_administrator_policy_arn" {
  value = "${aws_iam_policy.stage_admin.arn}"
}

output "prod_administrator_policy_arn" {
  value = "${aws_iam_policy.prod_admin.arn}"
}
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> add developer policies and attach to group

output "application_iam_user_names" {
  value = ["${aws_iam_user.app.*.name}"]
}

output "developer_iam_user_names" {
  value = ["${aws_iam_user.dev.*.name}"]
}
<<<<<<< HEAD
<<<<<<< HEAD

output "developer_access_keys" {
  value = ["${aws_iam_user.dev.*.unique_id}"]
}
=======
>>>>>>> add developer policies and attach to group
=======
=======
>>>>>>> separate global-iam declarations
>>>>>>> separate global-iam declarations
=======
>>>>>>> add developer policies and attach to group
