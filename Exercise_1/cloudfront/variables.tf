variable "s3_primary" {
  description = "S3 primary"
}

variable "price_class" {
  default     = "PriceClass_100" // Only US,Canada,Europe
  description = "CloudFront distribution price class"
}
variable "cloudfront_access_identity_path" {
  description = "CloudFront access identity path"
}
variable "domain_name" {
  description = "Domain name"
}

variable "use_default_domain" {
  description = "use Domain name"
  default = false
}