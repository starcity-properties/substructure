output "repository_url" {
  value = "${data.aws_ecr_repository.docker_image.repository_url}"
}

output "repository_arn" {
  value = "${data.aws_ecr_repository.docker_image.arn}"
}
