locals {
  s3_bucket_primary_name = "${local.name}-my-great-bucket-webapp"
  s3_bucket_failover_name = "${local.name}-my-great-bucket-webapp-f"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${local.s3_bucket_primary_name}.s3.amazonaws.com"
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "1"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${local.s3_bucket_primary_name}/*",
    ]

    principals {
      type = "AWS"

      identifiers = [
        aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
      ]
    }
  }
}

module "s3Primary" {
  source      = "./object"
  bucket_name = local.s3_bucket_primary_name
  source_file = "object/index.html"
  s3_bucket_policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

# module "s3Failover" {
#   source      = "./object"
#   bucket_name = "${local.name}-my-great-bucket-webapp-f"
#   source_file = "object/index_f.html"
#   s3_bucket_policy = data.aws_iam_policy_document.s3_bucket_policy.json
# }