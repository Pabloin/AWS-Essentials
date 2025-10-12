terraform {
  backend "s3" {
    bucket = "moreno-stack-tf-state"
    key    = "moreno-stack/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
