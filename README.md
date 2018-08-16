# substructure


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
