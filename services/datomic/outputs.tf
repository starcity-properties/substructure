output "asg_name" {
  value = "${aws_autoscaling_group.datomic_asg.name}"
}