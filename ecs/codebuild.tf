/* CodeBuild */

resource "aws_codebuild_project" "app" {
  name          = "app"
  build_timeout = "10"
  service_role  = "${data.terraform_remote_state.iam.codebuild_role}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:1.12.1"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "${data.template_file.buildspec.rendered}"
  }
}


data "template_file" "buildspec" {
  template = "${file("${path.module}/scripts/buildspec.yml")}"

  vars {
    region         = "${var.aws_region}"
    repository_url = "${data.terraform_remote_state.ecr.repository_url}"
    cluster_name   = "${aws_ecs_cluster.fargate.name}"

    subnets         = "${jsonencode(data.terraform_remote_state.vpc.private_subnet_ids)}"
    security_groups = "${jsonencode(data.terraform_remote_state.vpc.internal_inbound_id)}"
  }
}
