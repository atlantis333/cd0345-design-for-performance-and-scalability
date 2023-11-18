

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = var.s3_bucket_policy

}

resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
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