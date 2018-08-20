/*====
App Load Balancer
======*/


resource "aws_alb" "alb_clj_app" {
  name            = "alb-clj-app"
  subnets         = ["${data.terraform_remote_state.vpc.public_subnets}"]

  security_groups = [
    "${data.terraform_remote_state.vpc.default_group_id}",
    "${aws_security_group.web_inbound_sg.id}"
  ]
}


/* helper */
resource "random_id" "target_group_suffix" {
  byte_length = 2
}


resource "aws_alb_target_group" "alb_target_group" {
  name        = "vpc-alb-target-group-${random_id.target_group_suffix.hex}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_alb_listener" "listener" {
  load_balancer_arn = "${aws_alb.alb_clj_app.arn}"
  port              = 80
  protocol          = "HTTP"
  depends_on        = ["aws_alb_target_group.alb_target_group"]

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }
}
