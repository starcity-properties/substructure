output "aws_user_count" {
  value = "${local.count}"
}

output "map_aws_user_names_to_access_keys" {
  value = "${zipmap("${local.user_names}", "${local.access_keys}")}"
}

output "map_aws_user_names_to_passwords" {
  value = "${zipmap("${local.user_names}", "${aws_iam_user_login_profile.developer.*.encrypted_password}")}"
}

output "map_aws_user_names_to_secret_keys" {
  value = "${zipmap("${local.user_names}", "${aws_iam_access_key.developer.*.encrypted_secret}")}"
}
