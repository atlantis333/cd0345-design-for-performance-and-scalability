data "aws_s3_bucket" "selectedPrimary" {
  bucket = "${var.s3_primary}"
}

# data "aws_s3_bucket" "selectedFailover" {
#   bucket = "${var.s3_failover}"
# }

# resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
#   name                              = "CloudFront S3 OAC"
#   description                       = "Cloud Front S3 OAC"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }

### ROUTE53 ###

# resource "aws_route53_record" "route53_record" {
#   count      = var.use_default_domain ? 0 : 1
#   depends_on = [
#     aws_cloudfront_distribution.s3_distribution
#   ]

#   zone_id = data.aws_route53_zone.domain_name[0].zone_id
#   name    = var.bucket_name
#   type    = "A"

#   alias {
#     name    = aws_cloudfront_distribution.s3_distribution.domain_name
#     zone_id = "Z2FDTNDATAQYW2"

#     //HardCoded value for CloudFront
#     evaluate_target_health = false
#   }
# }

resource "aws_cloudfront_distribution" "my_distrib" {
  # origin_group {
  #   origin_id = "distribution"
  #   failover_criteria {
  #     status_codes = [403, 404, 500, 502, 503, 504]
  #   }
  #   member {
  #     origin_id = "s3Primary"
  #   }
  #   member {
  #     origin_id = "s3Failover"
  #   }
  # }
  origin {
    domain_name = var.domain_name
    origin_id   = "s3Primary"
    #origin_path = "/index.html"
    # origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
    s3_origin_config {
      origin_access_identity = var.cloudfront_access_identity_path
    }
    
  }
  # origin {
  #   domain_name = data.aws_s3_bucket.selectedFailover.bucket_regional_domain_name
  #   origin_id   = "s3Failover"
  #   #origin_path = "/index.html"
  #   # origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
  #   s3_origin_config {
  #     origin_access_identity = var.cloudfront_access_identity_path
  #   }
  # }
  
  enabled = true
  is_ipv6_enabled     = true
  comment             = "Cloudfront Distribution for S3 bucket"
  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3Primary"
    

    forwarded_values {
      query_string = false

      cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    price_class = var.price_class

    viewer_certificate {
        cloudfront_default_certificate = true
    }
    restrictions {
        geo_restriction {
          restriction_type = "none"
          locations        = []
        }
    }

}