# substructure


## Notes

Inside each directory here are Terraform modules to create specific (sets of) AWS resources.



## Bastion Host

The Bastion Host has a public IP address in our VPC, only accessible via SSH with `authorized_keys`. This is the entry point to the rest of the system designed to comprise only private IP addresses.

Upon deploying the Bastion Host, there is one manual step to deliver `authorized_keys` to each private server.



## Casbah Host

The Casbah Host enables nREPL connection to running Clojure applications.



## IAM module


How this works:
+ ECS `launch_configuration` will specify `instance_profile` for a web app or backend service
+ IAM `instance_profile` assumes role(s)
+ IAM `policy_attachment` joins role(s) with policy: for example, "complete access to xyz service"
+ When deploying ECS, can loop through a list of policies to attach to a set of users/roles/groups


/*==== SAMPLE: policy attachment =====*/

```shell
resource "aws_iam_policy_attachment" "sample" {
name       = "sample_name"
users      = ["${aws_iam_user.user.name}"]
roles      = ["${aws_iam_role.role.name}"]
groups     = ["${aws_iam_group.group.name}"]
policy_arn = "${aws_iam_policy.policy.arn}"
}
```