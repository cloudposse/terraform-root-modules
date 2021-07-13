variable "request_acm_certificate" {
  type    = bool
  default = true
}

locals {
  certificate_enabled = module.this.enabled && var.request_acm_certificate
  alternative_names   = [for zone in var.zone_config : format("*.%s.%s", zone.subdomain, zone.zone_name)]
  domain_name         = format("%s.%s", var.zone_config[0].subdomain, var.zone_config[0].zone_name)
}

module "acm" {
  enabled = local.certificate_enabled
  source  = "cloudposse/acm-request-certificate/aws"
  version = "0.13.1"
  providers = {
    aws = aws.delegated
  }

  domain_name                       = local.domain_name
  process_domain_validation_options = true
  ttl                               = 300
  subject_alternative_names         = local.alternative_names

  context    = module.this.context
  depends_on = [aws_route53_record.root_ns]
}

resource "aws_ssm_parameter" "acm_arn" {
  provider = aws.delegated

  name        = "/acm/${local.domain_name}"
  value       = module.acm.arn
  description = "ACM certificate id"
  type        = "String"
  key_id      = var.kms_alias_name
  overwrite   = true
}

output "certificate" {
  value = local.certificate_enabled ? {
    arn : module.acm.arn
    domain_name : local.domain_name
    subject_alternative_names : local.alternative_names
    domain_validation_options : module.acm.domain_validation_options
  } : null
}

output "acm_ssm_parameter" {
  value       = aws_ssm_parameter.acm_arn
  description = "The SSM parameter for the ACM cert."
  sensitive   = true # Necessary to allow plan / apply in 0.15+
}
