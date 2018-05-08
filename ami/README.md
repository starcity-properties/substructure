# AMI

AMIs to be built using `packer`.

## Notes

Make sure that both of the following criteria are met:

1. **No AWS Environment Variables are set**: Ensure that `AWS_ACCESS_KEY_ID` and
   `AWS_SECRET_ACCESS_KEY` are both unset.
2. **The profile is passed to packer**: `packer build -var 'aws_profile=star-development' <TEMPLATE>.json`
