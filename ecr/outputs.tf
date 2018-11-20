output "repository_url" {
  value = "${aws_ecr_repository.image.repository_url}"
}

output "repository_arn" {
  value = "${aws_ecr_repository.image.arn}"
}
