terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

resource "local_file" "hello_world" {
  filename = "${path.module}/output/hello.txt"
  content  = "Hello, Glaciar App!"
}

