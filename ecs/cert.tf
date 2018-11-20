/* recommended strategy: manually produce a certificate in the console using Amazon Certificate Manager, and select DNS validation, then add the CNAME to the Route53 configuration. alternatively select email validation, which will generate an email, must be manually validated at developers@starcity.com */


data "aws_acm_certificate" "domain" {
  domain   = "gostarcity.com"
  types = ["AMAZON_ISSUED"]
  most_recent = true
}
