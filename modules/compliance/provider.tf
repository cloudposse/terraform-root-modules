provider "aws" {
  region = var.region

  profile = coalesce(var.import_profile_name, module.iam_roles.terraform_profile_name)
}
