data "aws_s3_bucket" "selectedPrimary" {
  bucket = "${var.s3_primary}"
}

resource "aws_cloudfront_distribution" "my_distrib" {
  origin {
    domain_name = var.domain_name
    origin_id   = "s3Primary"
    #origin_path = "/index.html"
    # origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
    s3_origin_config {
      origin_access_identity = var.cloudfront_access_identity_path
    }
    
  }
  
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