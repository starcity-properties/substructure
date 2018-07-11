# transactor role. ec2 instances can assume the role of a transactor
resource "aws_iam_role" "transactor" {
  name = "${var.transactor_name}-transactor"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

# policy with write access to cloudwatch
resource "aws_iam_role_policy" "transactor_cloudwatch" {
  name = "cloudwatch_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:PutMetricDataBatch"
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "true"
        }
      },
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# policy with write access to the transactor logs
resource "aws_iam_role_policy" "transactor_logs" {
  name = "s3_logs_access"
  role = "${aws_iam_role.transactor.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}",
        "arn:aws:s3:::${aws_s3_bucket.transactor_logs.id}/*"
      ]
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

# policy with complete access to the dynamodb table
resource "aws_iam_role_policy" "transactor" {
  name  = "dynamo_access"
  role  = "${aws_iam_role.transactor.id}"
  count = "${var.protocol == "ddb" ? 1 : 0}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table}"
    }
  ]
}
EOF
}

# instance profile which assumes the transactor role
resource "aws_iam_instance_profile" "transactor" {
  name = "${var.transactor_name}-datomic-transactor"
  role = "${aws_iam_role.transactor.name}"
}
