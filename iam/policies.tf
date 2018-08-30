/*================ policies by AWS Service ==================*/


/*===
IAM
===*/

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


/*===
DynamoDB
===*/

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
      "Resource": "arn:aws:dynamodb:*:${var.aws_account_id}:table/${var.table_name}"
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
      "Resource": "arn:aws:dynamodb:*:${var.aws_account_id}:table/${var.table_name}"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}



/*===
CloudWatch
===*/
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



/*===
S3
===*/
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



/*===
CodeDeploy
===*/
resource "aws_iam_policy" "codedeploy" {
  name        = "codedeploy"
  path        = "/"
  description = "Allow access to EC2 and autoscaling for CodeDeploy."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "CodeDeploy",
      "Action": [
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:DeleteLifecycleHook",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeLifecycleHooks",
        "autoscaling:PutLifecycleHook",
        "autoscaling:RecordLifecycleActionHeartbeat",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeTags",
        "tag:GetTags",
        "tag:GetResources"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ],
  "Version": "2012-10-17"
}
EOF
}



/*===
ECS
===*/
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
  description = "Allow access to ECR and CloudWatch for ECS task execution."

  policy = <<EOF
{
  "Statement": [
    {
      "Sid": "ECSTaskExecution",
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
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


/*===
ECR
===*/
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
