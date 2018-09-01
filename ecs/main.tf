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
  name = "${var.repository_name}-fargate"
}


/*====
ECS task definitions
======*/

data "aws_ecs_task_definition" "service" {
  depends_on = ["aws_ecs_task_definition.service"]

  task_definition = "${aws_ecs_task_definition.service.family}"
}

data "template_file" "web_task" {
  template = "${file("${path.module}/tasks/web_task_definition.json")}"

  vars {
    cpu    = "${var.cpu}"
    memory = "${var.memory}"

    container_port = "${var.container_port}"
    host_port      = "${var.host_port}"
    protocol       = "${var.protocol}"

    name       = "${var.repository_name}"
    image      = "${data.terraform_remote_state.ecr.repository_url}:latest"

    aws_region = "${var.aws_region}"
    log_group  = "${aws_cloudwatch_log_group.app.name}"
    prefix     = "${var.db_access_type}"

    tipe_org_secret = "${var.tipe_org_secret}"
    tipe_api_key = "${var.tipe_api_key}"
    slack_client_id = "${var.slack_client_id}"
    slack_client_secret = "${var.slack_client_secret}"
    slack_webhook = "${var.slack_webhook}"
    slack_token = "${var.slack_token}"
    datomic_uri = "${var.datomic_uri}"
  }
}

resource "aws_ecs_task_definition" "service" {
  family = "${var.repository_name}-family"

  container_definitions    = "${data.template_file.web_task.rendered}"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "${var.cpu}"
  memory = "${var.memory}"

  execution_role_arn = "${data.terraform_remote_state.iam.ecs_execution_role}"
  task_role_arn      = "${data.terraform_remote_state.iam.ecs_task_role}"
}


/*====
ECS services
======*/

resource "aws_ecs_service" "service" {
  name = "${var.db_access_type}-service"

  task_definition = "${aws_ecs_task_definition.service.family}:${max("${aws_ecs_task_definition.service.revision}", "${data.aws_ecs_task_definition.service.revision}")}"
  desired_count   = "${var.desired_count}"
  launch_type     = "FARGATE"
  cluster         = "${aws_ecs_cluster.fargate.id}"

  network_configuration {
    subnets          = [
      "${data.terraform_remote_state.vpc.public_subnet_ids}"
    ]

    security_groups  = [
      "${data.terraform_remote_state.vpc.web_inbound_id}",
      "${data.terraform_remote_state.vpc.internal_inbound_id}"
    ]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.app.arn}"
    container_name   = "${var.repository_name}"
    container_port   = "${var.container_port}"
  }

  depends_on = ["aws_lb_target_group.app"]
}
