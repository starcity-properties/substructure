resource "aws_iam_instance_profile" "cault_service" {
  name = "Consul-Vault-Service-Profile"
  role = "${aws_iam_role.cault_service.name}"
}

resource "aws_iam_role" "cault_service" {
  name = "Consul-Vault-Service-Role"

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
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy" "s3_all_access" {
  name = "s3_all_access"
  role = "${aws_iam_role.cault_service.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
