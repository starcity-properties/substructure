terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*====
IAM
======*/

/*==== groups =====*/

resource "aws_iam_group" "dev_administrator" {
  name = "development_administrator"
  path = "/"
}

resource "aws_iam_group" "stage_administrator" {
  name = "staging_administrator"
  path = "/"
}

resource "aws_iam_group" "prod_administrator" {
  name = "production_administrator"
  path = "/"
}

resource "aws_iam_group" "developer" {
  name = "developer"
  path = "/"
}

resource "aws_iam_group" "application" {
  name = "application"
  path = "/"
}

/*==== apps =======*/

# imported
resource "aws_iam_user" "app" {
  count = "${length(var.applications)}"
  name = "${element(var.applications, count.index)}"
  path = "/"
}

/*==== devs =======*/

# imported
resource "aws_iam_user" "dev" {
  count = "${length(var.developers)}"
  name = "${element(var.developers, count.index)}"
  path = "/"
<<<<<<< HEAD
<<<<<<< HEAD
  force_destroy = true
=======
>>>>>>> separate global-iam declarations
=======
  force_destroy = true
>>>>>>> add developer policies and attach to group
}

/*==== membership =*/

/* DEVS */
resource "aws_iam_group_membership" "developers" {
  name = "engineering-team"

  users = [
    "${aws_iam_user.dev.*.name}"
  ]

  group = "${aws_iam_group.developer.name}"
}

/* APPS */
resource "aws_iam_group_membership" "applications" {
  name = "application-services"

  users = [
    "${aws_iam_user.app.*.name}"
  ]

  group = "${aws_iam_group.application.name}"
}

/* ADMINS */
resource "aws_iam_user_group_membership" "administrator" {
  count = "${length(var.administrators)}"
  user = "${element(var.administrators, count.index)}"

  groups = [
    "${aws_iam_group.dev_administrator.name}",
    "${aws_iam_group.stage_administrator.name}",
    "${aws_iam_group.prod_administrator.name}"
  ]
}

/*==== policies ===*/

resource "aws_iam_policy" "dev_admin" {
  name        = "development_administrator_policy"
  path        = "/"
  description = "Allows assuming the development administration role on the development account."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::${var.dev_account}:role/administrator"
    }
}
EOF
}

resource "aws_iam_policy" "stage_admin" {
  name        = "staging_administrator_policy"
  path        = "/"
  description = "Allows assuming the staging administration role on the staging account."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::${var.stage_account}:role/administrator"
    }
}
EOF
}

resource "aws_iam_policy" "prod_admin" {
  name        = "production_administrator_policy"
  path        = "/"
  description = "Allows assuming the production administration role on the production account."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "arn:aws:iam::${var.prod_account}:role/administrator"
    }
}
EOF
}

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> add developer policies and attach to group
resource "aws_iam_policy" "password_update" {
  name        = "password_update"
  path        = "/"
  description = "Allows a user to update their password."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:ChangePassword"
      ],
      "Resource": [
        "arn:aws:iam::*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetAccountPasswordPolicy"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "view_only_full_access" {
  name        = "view_only_full_access"
  path        = "/"
  description = "Allows a user to view only across all AWS services."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "acm:ListCertificates",
                "athena:List*",
                "aws-marketplace:ViewSubscriptions",
                "autoscaling:Describe*",
                "batch:ListJobs",
                "clouddirectory:ListAppliedSchemaArns",
                "clouddirectory:ListDevelopmentSchemaArns",
                "clouddirectory:ListDirectories",
                "clouddirectory:ListPublishedSchemaArns",
                "cloudformation:List*",
                "cloudformation:DescribeStacks",
                "cloudfront:List*",
                "cloudhsm:ListAvailableZones",
                "cloudhsm:ListLunaClients",
                "cloudhsm:ListHapgs",
                "cloudhsm:ListHsms",
                "cloudsearch:List*",
                "cloudsearch:DescribeDomains",
                "cloudtrail:DescribeTrails",
                "cloudtrail:LookupEvents",
                "cloudwatch:List*",
                "cloudwatch:GetMetricData",
                "codebuild:ListBuilds*",
                "codebuild:ListProjects",
                "codecommit:List*",
                "codedeploy:List*",
                "codedeploy:Get*",
                "codepipeline:ListPipelines",
                "codestar:List*",
                "codestar:Verify*",
                "cognito-idp:List*",
                "cognito-identity:ListIdentities",
                "cognito-identity:ListIdentityPools",
                "cognito-sync:ListDatasets",
                "connect:List*",
                "config:List*",
                "config:Describe*",
                "datapipeline:ListPipelines",
                "datapipeline:DescribePipelines",
                "datapipeline:GetAccountLimits",
                "devicefarm:List*",
                "directconnect:Describe*",
                "discovery:List*",
                "dms:List*",
                "ds:DescribeDirectories",
                "dynamodb:ListTables",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeBundleTasks",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeConversionTasks",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeExportTasks",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeHost*",
                "ec2:DescribeIdentityIdFormat",
                "ec2:DescribeIdFormat",
                "ec2:DescribeImage*",
                "ec2:DescribeImport*",
                "ec2:DescribeInstance*",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeMovingAddresses",
                "ec2:DescribeNatGateways",
                "ec2:DescribeNetwork*",
                "ec2:DescribePlacementGroups",
                "ec2:DescribePrefixLists",
                "ec2:DescribeRegions",
                "ec2:DescribeReserved*",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshot*",
                "ec2:DescribeSpot*",
                "ec2:DescribeSubnets",
                "ec2:DescribeVolume*",
                "ec2:DescribeVpc*",
                "ec2:DescribeVpnGateways",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecs:List*",
                "ecs:Describe*",
                "elasticache:Describe*",
                "elasticbeanstalk:DescribeApplicationVersions",
                "elasticbeanstalk:DescribeApplications",
                "elasticbeanstalk:DescribeEnvironments",
                "elasticbeanstalk:ListAvailableSolutionStacks",
                "elasticloadbalancing:DescribeListeners",
                "elasticloadbalancing:DescribeLoadBalancers",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticfilesystem:DescribeFileSystems",
                "elasticmapreduce:List*",
                "elastictranscoder:List*",
                "es:DescribeElasticsearchDomain",
                "es:DescribeElasticsearchDomains",
                "es:ListDomainNames",
                "events:ListRuleNamesByTarget",
                "events:ListRules",
                "events:ListTargetsByRule",
                "firehose:List*",
                "firehose:DescribeDeliveryStream",
                "gamelift:List*",
                "glacier:List*",
                "iam:List*",
                "iam:GetAccountSummary",
                "iam:GetLoginProfile",
                "importexport:ListJobs",
                "inspector:List*",
                "iot:List*",
                "kinesis:ListStreams",
                "kinesisanalytics:ListApplications",
                "kms:ListKeys",
                "lambda:List*",
                "lex:GetBotAliases",
                "lex:GetBotChannelAssociations",
                "lex:GetBots",
                "lex:GetBotVersions",
                "lex:GetIntents",
                "lex:GetIntentVersions",
                "lex:GetSlotTypes",
                "lex:GetSlotTypeVersions",
                "lex:GetUtterancesView",
                "lightsail:GetBlueprints",
                "lightsail:GetBundles",
                "lightsail:GetInstances",
                "lightsail:GetInstanceSnapshots",
                "lightsail:GetKeyPair",
                "lightsail:GetRegions",
                "lightsail:GetStaticIps",
                "lightsail:IsVpcPeered",
                "logs:Describe*",
                "machinelearning:Describe*",
                "mobilehub:ListAvailableFeatures",
                "mobilehub:ListAvailableRegions",
                "mobilehub:ListProjects",
                "opsworks:Describe*",
                "opsworks-cm:Describe*",
                "organizations:List*",
                "mobiletargeting:GetApplicationSettings",
                "mobiletargeting:GetCampaigns",
                "mobiletargeting:GetImportJobs",
                "mobiletargeting:GetSegments",
                "polly:Describe*",
                "polly:List*",
                "rds:Describe*",
                "redshift:DescribeClusters",
                "redshift:DescribeEvents",
                "redshift:ViewQueriesInConsole",
                "route53:List*",
                "route53:Get*",
                "route53domains:List*",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "sagemaker:Describe*",
                "sagemaker:List*",
                "sdb:List*",
                "servicecatalog:List*",
                "ses:List*",
                "shield:List*",
                "states:ListActivities",
                "states:ListStateMachines",
                "sns:List*",
                "sqs:ListQueues",
                "ssm:ListAssociations",
                "ssm:ListDocuments",
                "storagegateway:ListGateways",
                "storagegateway:ListLocalDisks",
                "storagegateway:ListVolumeRecoveryPoints",
                "storagegateway:ListVolumes",
                "swf:List*",
                "trustedadvisor:Describe*",
                "waf:List*",
                "waf-regional:List*",
                "workdocs:DescribeAvailableDirectories",
                "workdocs:DescribeInstances",
                "workmail:Describe*",
                "workspaces:Describe*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

<<<<<<< HEAD
=======
>>>>>>> separate global-iam declarations
=======
>>>>>>> add developer policies and attach to group

/*==== policy attachments =====*/

# SAMPLE:
# resource "aws_iam_policy_attachment" "sample" {
#   name       = "sample_name"
#   users      = ["${aws_iam_user.user.name}"]
#   roles      = ["${aws_iam_role.role.name}"]
#   groups     = ["${aws_iam_group.group.name}"]
#   policy_arn = "${aws_iam_policy.policy.arn}"
# }

resource "aws_iam_policy_attachment" "dev_admin" {
  name       = "dev_admin_group_policy"
  groups     = ["${aws_iam_group.dev_administrator.name}"]
  policy_arn = "${aws_iam_policy.dev_admin.arn}"
}

resource "aws_iam_policy_attachment" "stage_admin" {
  name       = "stage_admin_group_policy"
  groups     = ["${aws_iam_group.stage_administrator.name}"]
  policy_arn = "${aws_iam_policy.stage_admin.arn}"
}

resource "aws_iam_policy_attachment" "prod_admin" {
  name       = "prod_admin_group_policy"
  groups     = ["${aws_iam_group.prod_administrator.name}"]
  policy_arn = "${aws_iam_policy.prod_admin.arn}"
}

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> add developer policies and attach to group
resource "aws_iam_policy_attachment" "developers_iam" {
  name       = "developers_iam_policy"
  groups     = ["${aws_iam_group.developer.name}"]
  policy_arn = "${aws_iam_policy.password_update.arn}"
<<<<<<< HEAD
}

resource "aws_iam_policy_attachment" "developers_view_only" {
  name       = "developers_view_only_policy"
  groups     = ["${aws_iam_group.developer.name}"]
  policy_arn = "${aws_iam_policy.view_only_full_access.arn}"
}

/*==== roles ======*/
=======

/*==== roles ======*/




/*==== account management ====*/

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
}


/*==== access keys + ssh =====*/

resource "aws_iam_access_key" "lb" {
  user    = "${aws_iam_user.lb.name}"
  pgp_key = "keybase:some_person_that_exists"
}

output "secret" {
  value = "${aws_iam_access_key.lb.encrypted_secret}"
=======
>>>>>>> add developer policies and attach to group
}

resource "aws_iam_policy_attachment" "developers_view_only" {
  name       = "developers_view_only_policy"
  groups     = ["${aws_iam_group.developer.name}"]
  policy_arn = "${aws_iam_policy.view_only_full_access.arn}"
}

<<<<<<< HEAD
output "password" {
  value = "${aws_iam_user_login_profile.u.encrypted_password}"
}

resource "aws_iam_user_ssh_key" "user" {
  username   = "${aws_iam_user.user.name}"
  encoding   = "SSH"
  public_key = ""
}
>>>>>>> separate global-iam declarations
=======
/*==== roles ======*/
>>>>>>> add developer policies and attach to group
