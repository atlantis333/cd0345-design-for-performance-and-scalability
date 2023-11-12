module "s3Primary" {
  source      = "./object"
  bucket_name = "${local.name}-my-great-bucket-webapp"
  source_file = "object/index.html"
}

module "s3Failover" {
  source      = "./object"
  bucket_name = "${local.name}-my-great-bucket-webapp-f"
  source_file = "object/index_f.html"
}