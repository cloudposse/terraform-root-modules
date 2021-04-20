output "saml_provider_arns" {
  value = {
    for key, value in var.saml_providers : key => aws_iam_saml_provider.default[key].arn
  }
  description = "Map of SAML provider names to provider ARNs"
}

output "okta_api_users" {
  value = module.okta_api_user[*]
}
