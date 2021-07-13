terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    sdm = {
      source  = "strongdm/sdm"
      version = ">= 1.0.19"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.2.0"
    }
  }
}
