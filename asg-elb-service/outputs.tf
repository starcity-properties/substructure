output "public_ip" {
  value = "${aws_elb.web_service.dns_name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.web_service.name}"
}

output "elb_dns_name" {
  value = "${aws_elb.web_service.dns_name}"
}

output "elb_security_group_id" {
  value = "${aws_security_group.elb.id}"
}

output "codedeploy_app_name" {
  value = "${aws_codedeploy_app.codedeploy_app.name}"
}
