/* CodePipeline */


resource "aws_codepipeline" "app" {
  name     = "${var.repository_name}-app"
  role_arn = "${data.terraform_remote_state.iam.codepipeline_role}"

  artifact_store {
    location = "${data.terraform_remote_state.iam.codepipeline_artifacts_bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration {
        Repo       = "${var.github_repo}"
        Branch     = "${var.github_branch}"
        Owner      = "${var.github_owner}"
        OAuthToken = "${var.github_oauth_token}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["imagedefinitions"]

      configuration {
        ProjectName = "${var.repository_name}-app"
      }
    }
  }

  # stage {
  #   name = "Test"

  #   action {
  #     name             = "Test"
  #     category         = "Test"
  #     owner            = "AWS"
  #     provider         = "CodeBuild"
  #     version          = "1"
  #     input_artifacts  = ["source"]
  #     output_artifacts = ["imagedefinitions"]

  #     configuration {
  #       ProjectName = "${var.repository_name}-app"
  #     }
  #   }
  # }

  stage {
    name = "${title(var.environment)}-deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["imagedefinitions"]

      configuration {
        ClusterName = "${aws_ecs_cluster.fargate.name}"
        ServiceName = "${aws_ecs_service.service.name}"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
