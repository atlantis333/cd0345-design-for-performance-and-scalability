module "cloud-front" {
  source         = "./cloudfront"
  s3_primary = module.s3Primary.bucket_id
  # s3_failover = module.s3Failover.bucket_id
  depends_on = [
    module.s3Primary
  ]
  domain_name = module.s3Primary.bucket_regional_domain_name
  price_class = var.price_class
  cloudfront_access_identity_path = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
}