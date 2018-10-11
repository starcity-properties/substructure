/*==== Cloudwatch Log Group ======*/


resource "aws_cloudwatch_log_group" "app" {
  name = "app_log_group"
}


/* metric used for auto scale */
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "${var.repository_name}-cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "85"

  dimensions {
    ClusterName = "${aws_ecs_cluster.fargate.name}"
    ServiceName = "${aws_ecs_service.service.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.up.arn}"]
  ok_actions    = ["${aws_appautoscaling_policy.down.arn}"]
}
