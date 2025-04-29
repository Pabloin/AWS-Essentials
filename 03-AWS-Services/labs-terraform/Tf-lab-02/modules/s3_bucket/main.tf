resource "aws_s3_bucket" "glaciar" {
  bucket = "io-glaciar-tf-${var.env_name}"
}

resource "aws_s3_bucket_acl" "glaciar" {
  bucket = aws_s3_bucket.glaciar.id
  acl    = "private"
}
