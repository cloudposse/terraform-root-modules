provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = var.firewall_manager_administrator_arn
  }
}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = local.assumed_arn
  }
  alias = "dynamic_provider"
}

