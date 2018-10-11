# AMI

AMIs to be built using `packer`.

## Notes



Make sure that both of the following criteria are met:

1. **AWS credentials are not in the environment**: Either use the `global` Vagrant environment (see `superstructure-env`)

Or...

Ensure that `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are both unset.

2. **AWS profile is passed to Packer via command-line**: `packer build -var 'aws_profile=star-development' <TEMPLATE>.json`


# TODO: Parameterize, parameterize, parameterize! Once we know what we want our repertoire of AMIs to be...
