# asg-elb-service

## Notes

I added `AmazonS3FullAccess` to the `development_administrator
(arn:aws:iam::384846394179:group/development_administrator)` group.

I'm hoping this provides access to s3 buckets on the master account, because
otherwise my strategy of having the instance download its application version
from s3 would be annoying...possible? I guess I could have releases stored on
the individual accounts....
