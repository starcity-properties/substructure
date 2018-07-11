terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.aws_region}"
}


/*====
ECS cluster
======*/

resource "aws_ecs_cluster" "fargate" {
  name = "fargate"
}


/*====
ECS task definitions
======*/


data "aws_ecs_task_definition" "web_service" {
  depends_on = ["aws_ecs_task_definition.web_service"]

  task_definition = "${aws_ecs_task_definition.web_service.family}"
}


resource "aws_ecs_task_definition" "web_service" {
  family                   = "web"
  container_definitions    = "${data.template_file.web_task.rendered}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "${aws_iam_role.ecs_execution_role.arn}"
  task_role_arn            = "${aws_iam_role.ecs_execution_role.arn}"
}


data "template_file" "web_task" {
  template = "${file("${path.module}/tasks/web_task_definition.json")}"

  vars {
    image      = "starcity/cornerstone"
    # image           = "${aws_ecr_repository.clj_app.repository_url}"
    aws_region = "${var.aws_region}"
    log_group  = "${aws_cloudwatch_log_group.clj_app.name}"
  }
}


resource "aws_ecs_service" "web_service" {
  name            = "web"
  task_definition = "${aws_ecs_task_definition.web_service.family}:${max("${aws_ecs_task_definition.web_service.revision}", "${data.aws_ecs_task_definition.web_service.revision}")}"
  desired_count   = 2
  launch_type     = "FARGATE"
  cluster         = "${aws_ecs_cluster.fargate.id}"
  depends_on      = ["aws_iam_role_policy.ecs_service_role_policy"]

  network_configuration {
    subnets          = ["${data.terraform_remote_state.vpc.public_subnets}"]
    security_groups  = [
      "${data.terraform_remote_state.vpc.default_group_id}",
      "${aws_security_group.ecs_service.id}"
    ]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    container_name   = "web"
    container_port   = "8080"
  }

  depends_on = ["aws_alb_target_group.alb_target_group"]
}
