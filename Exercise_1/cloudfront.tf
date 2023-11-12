module "cloud-front" {
  source         = "./cloudfront"
  s3_primary = module.s3Primary.bucket_id
  s3_failover = module.s3Failover.bucket_id
  depends_on = [
    module.s3Primary,
    module.s3Failover
  ]
}