/*
/* CodeBuild
*/

resource "aws_codebuild_project" "clj_app" {
  name          = "clj-app"
  build_timeout = "10"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

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
  template = "${file("${path.module}/buildspec.yml")}"

  vars {
    region             = "${var.aws_region}"
    repository_url     = "${data.terraform_remote_state.ecs.repository_url}"
    cluster_name       = "${data.terraform_remote_state.ecs.cluster_name}"
    subnet_ids         = "subnet-b23f4acb"
    security_group_ids = "sg-dbfcceaa"
  }
}

# The security group ids attached where the single run task will be executed
# The subnet id where single run task will be executed