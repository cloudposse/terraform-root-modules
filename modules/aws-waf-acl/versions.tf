terraform {
  required_version = "~> 0.14.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
    utils = {
      source  = "cloudposse/utils"
      version = "~> 0.3"
    }
  }
}
