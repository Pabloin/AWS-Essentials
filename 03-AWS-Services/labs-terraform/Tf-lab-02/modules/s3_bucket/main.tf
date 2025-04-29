resource "aws_s3_bucket" "example" {
  bucket = "my-terraform-bucket-${var.env_name}"
  acl    = "private"
}
