module "full_access" {
  source = "../account-map/modules/roles-to-principals"

  role_map = var.read_write_account_role_map
  region   = var.region

  context = module.this.context
}

module "readonly_access" {
  source = "../account-map/modules/roles-to-principals"

  role_map = var.read_only_account_role_map
  region   = var.region

  context = module.this.context
}

locals {
  ecr_writers  = flatten([for w in var.cicd_accounts : lookup(module.eks_iam[w].outputs, "cicd_roles", [])])
  ecr_user_arn = join("", aws_iam_user.ecr.*.arn)
}

module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.2"

  protected_tags             = var.protected_tags
  enable_lifecycle_policy    = var.enable_lifecycle_policy
  image_names                = var.images
  image_tag_mutability       = var.image_tag_mutability
  max_image_count            = var.max_image_count
  principals_full_access     = compact(concat(module.full_access.principals, local.ecr_writers, [local.ecr_user_arn]))
  principals_readonly_access = module.readonly_access.principals
  scan_images_on_push        = var.scan_images_on_push
  use_fullname               = false

  context = module.this.context
}
