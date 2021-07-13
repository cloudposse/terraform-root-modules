
locals {
  assumed_arn = var.is_destroy ? var.firewall_manager_administrator_arn : var.organization_management_arn
}

module "components_firewall_manager" {
  providers = {
    aws.dynamic_provider = aws.dynamic_provider
    aws = aws
  }
//  source  = "cloudposse/components/aws//modules/firewall_manager"
//  version = "0.149.0"
  source = "../../../../../cloudposse/terraform-aws-firewall-manager/"
  context = module.this.context

  admin_account_id = var.admin_account_id

  security_groups_common_policies           = var.security_groups_common_policies
  security_groups_content_audit_policies    = var.security_groups_content_audit_policies
  security_groups_usage_audit_policies      = var.security_groups_usage_audit_policies
  shiled_advanced_policies                  = var.shiled_advanced_policies
  waf_policies                              = var.waf_policies
  waf_v2_policies                           = var.waf_v2_policies
  dns_firewall_policies                     = var.dns_firewall_policies
  network_firewall_policies                 = var.network_firewall_policies

}
