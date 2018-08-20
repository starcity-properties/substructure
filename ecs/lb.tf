/*====
App Load Balancer
======*/

resource "aws_lb" "app" {
  name = "${var.repository_name}-app"

  internal           = false
  load_balancer_type = "application"

  subnets         = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]
  security_groups = [
    "${data.terraform_remote_state.vpc.web_inbound_id}",
    "${data.terraform_remote_state.vpc.internal_inbound_id}"
  ]

  tags {
    Environment = "${var.environment}"
  }
}

/* helper */
resource "random_id" "target_group_suffix" {
  byte_length = 2
}

resource "aws_lb_target_group" "app" {
  name        = "${var.repository_name}-${random_id.target_group_suffix.hex}"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  target_type = "ip"

  depends_on = ["aws_lb.app"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = "${aws_lb.app.arn}"
  port              = 80
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2015-05"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  depends_on = ["aws_lb_target_group.app"]

  default_action {
    target_group_arn = "${aws_lb_target_group.app.arn}"
    type             = "forward"
  }
}