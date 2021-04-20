provider "datadog" {
  api_key = local.datadog_api_key
  app_key = local.datadog_app_key
}

provider "aws" {
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
