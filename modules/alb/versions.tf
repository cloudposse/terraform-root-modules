terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.32"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1"
    }
  }
}
