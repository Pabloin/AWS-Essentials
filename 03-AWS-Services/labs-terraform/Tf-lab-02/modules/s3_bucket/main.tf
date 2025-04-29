resource "aws_s3_bucket" "glaciar" {
  bucket = "io-glaciar-tf-acg-${var.env_name}"
  force_destroy  = true
}

resource "aws_s3_bucket_public_access_block" "glaciar" {
  bucket = aws_s3_bucket.glaciar.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

