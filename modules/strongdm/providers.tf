provider "aws" {
  region = var.region

  profile = coalesce(var.import_profile_name, module.iam_roles.terraform_profile_name)
}

module "iam_roles" {
  source  = "../account-map/modules/iam-roles"
  context = module.this.context
}

variable "import_profile_name" {
  type        = string
  default     = null
  description = "AWS Profile name to use when importing a resource"
}

provider "aws" {
  alias  = "api_keys"
  region = var.ssm_region

  profile = coalesce(var.import_profile_name, module.iam_roles_network.terraform_profile_name)
}

module "iam_roles_network" {
  source  = "../account-map/modules/iam-roles"
  stage   = var.ssm_account
  context = module.this.context
}

provider "sdm" {
  api_access_key = local.enabled ? data.aws_ssm_parameter.api_access_key[0].value : null
  api_secret_key = local.enabled ? data.aws_ssm_parameter.api_secret_key[0].value : null
}
