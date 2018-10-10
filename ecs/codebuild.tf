/* CodeBuild */


resource "aws_codebuild_project" "app" {
  name = "${var.repository_name}-app"

  build_timeout = "10"
  service_role  = "${data.terraform_remote_state.iam.codebuild_role}"

  source {
    type      = "CODEPIPELINE"
    buildspec = "${data.template_file.buildspec.rendered}"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

  artifacts {
    type = "CODEPIPELINE"
  }
}


data "template_file" "buildspec" {
  template = "${file("${path.module}/scripts/buildspec.yml")}"

  vars {
    region  = "${var.aws_region}"
    task    = "${aws_ecs_task_definition.service.family}"
    cluster = "${aws_ecs_cluster.fargate.name}"

    source_repository_url = "${var.github_repo}"
    target_repository_url = "${data.terraform_remote_state.ecr.repository_url}"
    image_tag             = "latest"

    build_args = "${join("", var.docker_build_args)}"

    subnets         = "${jsonencode(data.terraform_remote_state.vpc.private_subnet_ids)}"
    security_groups = "${jsonencode(data.terraform_remote_state.vpc.internal_inbound_id)}"
  }
}
