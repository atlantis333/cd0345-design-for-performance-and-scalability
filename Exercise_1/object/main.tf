resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "object" {
  bucket       = "${var.bucket_name}"
  key          = "index.html"
  source       = var.source_file #"object/index.html"
  content_type = "text/html"

  etag = filemd5(var.source_file)
  #acl  = "public-read"
  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}