provider "aws" {
  # The AWS provider to use to make changes in the DNS primary account
  alias  = "primary"
  region = var.region

  assume_role {
    # `terraform import` will not use data from a data source,
    # so on import we have to explicitly specify the role
    role_arn = coalesce(var.import_role_arn, module.iam_roles.dns_terraform_role_arn)
  }
}

provider "aws" {
  # The AWS provider to use to make changes in the target (delegated) account
  alias  = "delegated"
  region = var.region

  assume_role {
    # `terraform import` will not use data from a data source,
    # so on import we have to explicitly specify the role
    role_arn = coalesce(var.import_role_arn, module.iam_roles.terraform_role_arn)
  }
}

module "iam_roles" {
  source  = "../account-map/modules/iam-roles"
  context = module.this.context
}

variable "import_role_arn" {
  type        = string
  default     = null
  description = "IAM Role ARN to use when importing a resource"
}
