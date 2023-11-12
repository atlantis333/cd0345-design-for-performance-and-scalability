# Define Local Values in Terraform
locals {
  owners = var.business_divsion
  environment = var.environment
  name = "${var.business_divsion}-${var.environment}"
  bucket_name = "bucket-webapp"
  #name = "${local.owners}-${local.environment}"
#   common_tags = {
#     owners = local.owners
#     environment = local.environment
#   }
} 