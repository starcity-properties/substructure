variable "aws_region" {
  description = "The AWS region to create the S3 bucket in."
}

variable "name_prefix" {
  description = "Prefix for the bucket name. Note that the same bucket is used for all codedeploy deployment groups"
}
