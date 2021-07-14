module "aws_waf" {
  source  = "cloudposse/waf/aws"
  version = "0.0.1"

  association_resource_arns                   = var.association_resource_arns
  byte_match_statement_rules                  = var.byte_match_statement_rules
  default_action                              = var.default_action
  description                                 = var.description
  geo_match_statement_rules                   = var.geo_match_statement_rules
  ip_set_reference_statement_rules            = var.ip_set_reference_statement_rules
  log_destination_configs                     = var.log_destination_configs
  managed_rule_group_statement_rules          = var.managed_rule_group_statement_rules
  rate_based_statement_rules                  = var.rate_based_statement_rules
  redacted_fields                             = var.redacted_fields
  regex_pattern_set_reference_statement_rules = var.regex_pattern_set_reference_statement_rules
  rule_group_reference_statement_rules        = var.rule_group_reference_statement_rules
  scope                                       = var.scope
  size_constraint_statement_rules             = var.size_constraint_statement_rules
  sqli_match_statement_rules                  = var.sqli_match_statement_rules
  visibility_config                           = var.visibility_config
  xss_match_statement_rules                   = var.xss_match_statement_rules

  context = module.this.context
}

locals {
  enabled = module.this.enabled
}

resource "aws_ssm_parameter" "acl_arn" {
  count       = local.enabled ? 1 : 0
  name        = "${var.ssm_path_prefix}/${var.acl_name}/arn"
  value       = module.aws_waf.arn
  description = "ARN for WAF web ACL ${var.acl_name}"
  type        = "String"
  overwrite   = true
}
