terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 1.3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.3"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.3.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.11.2"
    }
  }
}
