# datomic transactor

## Variables

```shell
export TF_VAR_aws_account_id=xxx
export TF_VAR_datomic_license=xxx
```

See the [official terraform
docs](https://www.terraform.io/intro/getting-started/variables.html) for more
details.


## Common Issues

### Could not satisfy plugin requirements

This is an issue with the terragrunt cache not initializing plugins properly due
to its caching mechanism. Solve by running `rm -rf ~/.terragrunt` to clear out
the cache.


## TODO

- Gain a better understanding of [VPCs and cidr blocks](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html)
- Create a local secrets file to load tf vars with
