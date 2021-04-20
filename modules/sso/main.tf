locals {
  okta_providers = toset([for k, v in var.saml_providers : k if length(regexall("(?i:okta)", v)) > 0])
}

resource "aws_iam_saml_provider" "default" {
  for_each               = var.saml_providers
  name                   = format("%s-%s", module.this.id, each.key)
  saml_metadata_document = file(each.value)
}

module "okta_api_user" {
  for_each = local.okta_providers
  source   = "./modules/okta-user"

  attributes = [each.key, "oktaapi"]

  context = module.this.context
}
