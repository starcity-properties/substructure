/*====
Cloudwatch Log Group
======*/


resource "aws_cloudwatch_log_group" "clj_app" {
  name = "clj_app"

  tags {
    Environment = "${var.environment}"
    Application = "clj_app"
  }
}


/* metric used for auto scale */

resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.environment}_clj_app_web_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "85"

  dimensions {
    ClusterName = "${aws_ecs_cluster.fargate.name}"
    ServiceName = "${aws_ecs_service.web_service.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.up.arn}"]
  ok_actions    = ["${aws_appautoscaling_policy.down.arn}"]
}
