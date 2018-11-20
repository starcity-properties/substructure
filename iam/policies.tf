/* ================ policies by AWS Service ================== */


/* === IAM === */

resource "aws_iam_policy" "iam_full_access" {
  name        = "iam_full_access"
  path        = "/"
  description = "Allows full access to IAM."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "IAMFullAccess",
      "Action": "iam:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


/* === DynamoDB === */

# DATOMIC PEER
resource "aws_iam_policy" "dynamo_read" {
  name        = "dynamo_read"
  path        = "/"
  description = "Allows access to read DynamoDB table."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "DynamoTableRead",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:BatchGetItem",
        "dynamodb:Scan",
        "dynamodb:Query"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:*:${var.aws_account_ids[var.environment]}:table/${var.table_name}"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

# NOTE: ONLY ENABLE THIS WHEN RESTORING DATOMIC DATABASE
resource "aws_iam_policy" "dynamo_full_access" {
  name        = "dynamo_full_access"
  path        = "/"
  description = "Allows full access to DynamoDB table."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "DynamoTableFullAccess",
      "Action": "dynamodb:*",
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:*:${var.aws_account_ids[var.environment]}:table/${var.table_name}"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


/* === CloudWatch === */

resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "cloudwatch_logs"
  path        = "/"
  description = "Allow access to CloudWatch to put log events."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "CloudWatchCreateLogs",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


/* === S3 === */

resource "aws_iam_policy" "s3_full_access" {
  name        = "s3_full_access"
  path        = "/"
  description = "Allow full access to S3."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "S3FullAccess",
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


/* === ECS === */

resource "aws_iam_policy" "ecs_service" {
  name        = "ecs_service"
  path        = "/"
  description = "Allow access to Elastic Load Balancing and EC2."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "ElasticLoadBalancingService",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_policy" "ecs_execution" {
  name        = "ecs_execution"
  path        = "/"
  description = "Allow ECS container agent and the Docker daemon to assume role."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "ECSExecution",
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_policy" "ecs_task" {
  name        = "ecs_task"
  path        = "/"
  description = "Allow ECS container task to make calls to other AWS services."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "ECSTask",
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_policy" "ecs_autoscaling" {
  name        = "ecs_autoscaling"
  path        = "/"
  description = "Allow access to ECS for autoscaling a service."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "ECSAutoscaling",
      "Effect": "Allow",
      "Action": [
        "ecs:DescribeServices",
        "ecs:UpdateService"
      ],
      "Resource": [
        "*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
EOF
}


/* === ECR === */

resource "aws_iam_policy" "ecs_container_registry_full_access" {
  name        = "ecs_container_registry_full_access"
  path        = "/"
  description = "Allow full access to ECR by ECS."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "ECRFullAccess",
      "Effect": "Allow",
      "Action": [
        "ecr:*"
      ],
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_policy" "ecs_container_registry_push_pull" {
  name        = "ecs_container_registry_push_pull"
  path        = "/"
  description = "Allow access to ECR by ECS for pushing and pulling images."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "ECRPushPull",
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": [
        "*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
EOF
}



# s3 bucket
resource "aws_s3_bucket" "source" {
  bucket = "starcity-development-codepipeline-source"
}



/* === CodePipeline === */

data "template_file" "codepipeline_policy" {
  template = "${file("${path.module}/policies/codepipeline.json")}"

  vars {
    aws_s3_bucket_arn = "${aws_s3_bucket.source.arn}"
  }
}

resource "aws_iam_role_policy" "codepipeline" {
  name   = "codepipeline"
  role   = "${aws_iam_role.codepipeline.id}"
  policy = "${data.template_file.codepipeline_policy.rendered}"
}

/* === CodeBuild === */

data "template_file" "codebuild_policy" {
  template = "${file("${path.module}/policies/codebuild.json")}"

  vars {
    aws_s3_bucket_arn = "${aws_s3_bucket.source.arn}"
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "codebuild"
  role   = "${aws_iam_role.codebuild.id}"
  policy = "${data.template_file.codebuild_policy.rendered}"
}

/* === CodeDeploy === */

data "template_file" "codedeploy_policy" {
  template = "${file("${path.module}/policies/codedeploy.json")}"

  vars {
    aws_s3_bucket_arn = "${aws_s3_bucket.source.arn}"
  }
}

resource "aws_iam_role_policy" "codedeploy" {
  name   = "codedeploy"
  role   = "${aws_iam_role.codedeploy.id}"
  policy = "${data.template_file.codedeploy_policy.rendered}"
}
