/*====
IAM service
======*/


/* roles */

resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_role.json}"
}

resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = "${file("${path.module}/policies/ecs-task-execution-role.json")}"
}

resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "ecs_autoscale_role"
  assume_role_policy = "${file("${path.module}/policies/ecs-autoscale-role.json")}"
}


/* IAM policy documents */

data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress"
    ]
  }
}


resource "aws_iam_user" "user" {
    name = "test-user"
}

resource "aws_iam_policy" "ecr_policy" {
    name        = "AmazonEC2ContainerRegistryFullAccess"
    description = "ECR managed policy"
    policy      = "${file("${path.module}/policies/AmazonEC2ContainerRegistryFullAccess.json")}"
}

resource "aws_iam_user_policy_attachment" "ecr_policy_attach" {
    user       = "${aws_iam_user.user.name}"
    policy_arn = "${aws_iam_policy.ecr_policy.arn}"
}





/* IAM role policies */

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
  role   = "${aws_iam_role.ecs_role.id}"
}

resource "aws_iam_role_policy" "ecr_pushpull_role_policy" {
  name   = "ecr_pushpull_role_policy"
  policy = "${file("${path.module}/policies/ecr-pushpull-policy.json")}"
  role   = "${aws_iam_role.ecs_role.id}"
}

resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "ecs_execution_role_policy"
  policy = "${file("${path.module}/policies/ecs-execution-role-policy.json")}"
  role   = "${aws_iam_role.ecs_execution_role.id}"
}

resource "aws_iam_role_policy" "ecs_autoscale_role_policy" {
  name   = "ecs_autoscale_role_policy"
  policy = "${file("${path.module}/policies/ecs-autoscale-role-policy.json")}"
  role   = "${aws_iam_role.ecs_autoscale_role.id}"
}


/*====
Auto Scaling for ECS
======*/

resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.fargate.name}/${aws_ecs_service.web_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "${aws_iam_role.ecs_autoscale_role.arn}"
  min_capacity       = 2
  max_capacity       = 4
}

resource "aws_appautoscaling_policy" "up" {
  name                    = "scale_up"
  service_namespace       = "ecs"
  resource_id             = "service/${aws_ecs_cluster.fargate.name}/${aws_ecs_service.web_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"


  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.target"]
}

resource "aws_appautoscaling_policy" "down" {
  name                    = "scale_down"
  service_namespace       = "ecs"
  resource_id             = "service/${aws_ecs_cluster.fargate.name}/${aws_ecs_service.web_service.name}"
  scalable_dimension      = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.target"]
}
