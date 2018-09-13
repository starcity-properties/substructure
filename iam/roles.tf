/* ================ roles by AWS Service ================== */


/* codepipeline */
resource "aws_iam_role" "codepipeline" {
  name = "codepipeline"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codepipeline.amazonaws.com"
        ]
      },
      "Sid": "codepipeline"
    }
  ],
  "Version": "2012-10-17"
  }
EOF
}


/* codebuild */
resource "aws_iam_role" "codebuild" {
  name = "codebuild"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codebuild.amazonaws.com"
        ]
      },
      "Sid": "codebuild"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


/* codedeploy */
resource "aws_iam_role" "codedeploy" {
  name = "codedeploy"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.amazonaws.com"
        ]
      },
      "Sid": "codedeploy"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


resource "aws_iam_role" "cault" {
  name = "consul-vault"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "autoscaling.amazonaws.com"
        ]
      },
      "Sid": "cault"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


resource "aws_iam_role" "datomic_peer" {
  name = "datomic_peer"
  path = "/"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "autoscaling.amazonaws.com",
          "codedeploy.amazonaws.com"
        ]
      }
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


##------------------ ECS (APPLICATIONS) -------------------##

/*==== service-linked roles ===*/

resource "aws_iam_role" "ecs_service" {
  name = "ecs_service"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_execution" {
  name = "ecs_execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_task" {
  name = "ecs_task"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_autoscaling" {
  name = "ecs_autoscaling"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


##------------------ IAM (DEVELOPERS) ---------------------##

resource "aws_iam_role" "iam_dev" {
  name = "iam_developer"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "iam.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
