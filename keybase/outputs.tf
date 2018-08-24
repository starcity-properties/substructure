output "aws_user_count" {
  value = "${local.count}"
}

<<<<<<< HEAD
=======
output "aws_user_names" {
  value = "${local.user_names}"
}

output "aws_access_keys" {
  value = "${local.access_keys}"
}

>>>>>>> create keybase module for secrets and passwords; update iam-global module accordingly
output "map_aws_user_names_to_access_keys" {
  value = "${zipmap("${local.user_names}", "${local.access_keys}")}"
}

output "map_aws_user_names_to_passwords" {
  value = "${zipmap("${local.user_names}", "${aws_iam_user_login_profile.developer.*.encrypted_password}")}"
}

output "map_aws_user_names_to_secret_keys" {
  value = "${zipmap("${local.user_names}", "${aws_iam_access_key.developer.*.encrypted_secret}")}"
}
