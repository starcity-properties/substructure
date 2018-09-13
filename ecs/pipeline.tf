# s3 bucket
resource "aws_s3_bucket" "source" {
  bucket = "starcity-development-codepipeline-source"
}




/* CodePipeline */

resource "aws_codepipeline" "clj_app" {
  name     = "clj-app"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.source.bucket}"
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
        Owner      = "tdiede"
        Repo       = "cornerstone"
        Branch     = "master"
        OAuthToken = "3ce8fb881ffbac80cc73800c158eb9e542838320"
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
        ProjectName = "clj-app"
      }
    }
  }

  stage {
    name = "Production"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration {
        ClusterName = "${data.terraform_remote_state.ecs.cluster_name}"
        ServiceName = "${data.terraform_remote_state.ecs.service_name}"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
