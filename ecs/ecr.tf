/*====
ECR repository to store our Docker images
======*/

resource "aws_ecr_repository" "clj_app" {
  name = "${var.repository_name}"
}
