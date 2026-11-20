resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "site" {
  bucket        = "${var.project_name}-${random_id.suffix.hex}"
  force_destroy = true
  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket                  = aws_s3_bucket.site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
    }]
  })

  depends_on = [aws_s3_bucket_public_access_block.site]
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/index.html")
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.site.id
  key          = "error.html"
  source       = "${path.module}/error.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/error.html")
}
