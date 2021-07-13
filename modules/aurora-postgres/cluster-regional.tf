# A child module automatically inherits default (un-aliased) provider configurations from its parent.
# This means that explicit provider blocks appear only in the root module, and downstream modules can simply
# declare resources for that provider and have them automatically associated with the root provider configurations

# https://www.terraform.io/docs/providers/aws/r/rds_cluster.html
module "aurora_postgres_cluster" {
  source  = "cloudposse/rds-cluster/aws"
  version = "0.44.1"

  cluster_type   = "regional"
  engine         = var.engine
  engine_version = var.engine_version
  engine_mode    = var.engine_mode
  cluster_family = var.cluster_family
  instance_type  = var.instance_type
  cluster_size   = var.cluster_size
  admin_user     = local.admin_user
  admin_password = local.admin_password

  db_name                             = local.database_name
  publicly_accessible                 = var.publicly_accessible
  db_port                             = var.database_port
  vpc_id                              = local.vpc_id
  subnets                             = local.private_subnet_ids
  zone_id                             = local.zone_id
  cluster_dns_name                    = local.cluster_dns_name
  reader_dns_name                     = local.reader_dns_name
  security_groups                     = local.allowed_security_groups
  allowed_cidr_blocks                 = var.allowed_cidr_blocks
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  storage_encrypted                   = var.storage_encrypted
  kms_key_arn                         = var.storage_encrypted ? module.kms_key_rds.key_arn : null
  performance_insights_kms_key_id     = var.performance_insights_enabled ? module.kms_key_rds.key_arn : null
  maintenance_window                  = var.maintenance_window
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  enhanced_monitoring_role_enabled    = var.enhanced_monitoring_role_enabled
  performance_insights_enabled        = var.performance_insights_enabled
  rds_monitoring_interval             = var.rds_monitoring_interval
  autoscaling_enabled                 = var.autoscaling_enabled
  autoscaling_policy_type             = var.autoscaling_policy_type
  autoscaling_target_metrics          = var.autoscaling_target_metrics
  autoscaling_target_value            = var.autoscaling_target_value
  autoscaling_scale_in_cooldown       = var.autoscaling_scale_in_cooldown
  autoscaling_scale_out_cooldown      = var.autoscaling_scale_out_cooldown
  autoscaling_min_capacity            = var.autoscaling_min_capacity
  autoscaling_max_capacity            = var.autoscaling_max_capacity
  skip_final_snapshot                 = var.skip_final_snapshot
  deletion_protection                 = var.deletion_protection
  snapshot_identifier                 = var.snapshot_identifier

  context = module.cluster.context
}

resource "postgresql_database" "additional" {
  for_each   = module.this.enabled ? var.additional_databases : []
  name       = each.key
  depends_on = [module.aurora_postgres_cluster.cluster_identifier]
}

module "additional_users" {
  for_each = local.additional_users
  source   = "./modules/postgresql-user"

  service_name    = each.key
  db_user         = each.value.db_user
  db_password     = each.value.db_password
  grants          = each.value.grants
  ssm_path_prefix = local.ssm_path_prefix

  depends_on = [module.aurora_postgres_cluster.cluster_identifier]
}

locals {
  additional_users           = local.enabled ? var.additional_users : {}
  sanitized_additional_users = { for k, v in module.additional_users : k => { for kk, vv in v : kk => vv if kk != "db_user_password" } }
}

resource "aws_ssm_parameter" "admin_username" {
  count = local.enabled ? 1 : 0

  name        = format("%s/%s", local.ssm_cluster_key_prefix, "admin/db_username")
  value       = module.aurora_postgres_cluster.master_username
  description = "Aurora Postgres Username for the admin DB user"
  type        = "String"
  overwrite   = true
}

resource "aws_ssm_parameter" "admin_password" {
  count = local.enabled ? 1 : 0

  name        = format("%s/%s", local.ssm_cluster_key_prefix, "admin/db_password")
  value       = local.admin_password
  description = "Aurora Postgres Password for the admin DB user"
  type        = "SecureString"
  key_id      = var.kms_alias_name_ssm
  overwrite   = true
}

resource "aws_ssm_parameter" "master_hostname" {
  count = local.enabled ? 1 : 0

  name        = format("%s/%s", local.ssm_cluster_key_prefix, "master_hostname")
  value       = module.aurora_postgres_cluster.master_host
  description = "Aurora Postgres DB Master hostname"
  type        = "String"
  overwrite   = true
}

resource "aws_ssm_parameter" "replicas_hostname" {
  count = local.enabled ? 1 : 0

  name        = format("%s/%s", local.ssm_cluster_key_prefix, "replicas_hostname")
  value       = module.aurora_postgres_cluster.replicas_host
  description = "Aurora Postgres DB Replicas hostname"
  type        = "String"
  overwrite   = true
}

resource "aws_ssm_parameter" "cluster_identifier" {
  count = local.enabled ? 1 : 0

  name        = format("%s/%s", local.ssm_cluster_key_prefix, "cluster_id")
  value       = module.aurora_postgres_cluster.cluster_identifier
  description = "Aurora Postgres DB Cluster Identifier"
  type        = "String"
  overwrite   = true
}

resource "aws_ssm_parameter" "master_port" {
  count = local.enabled ? 1 : 0

  name        = format("%s/%s", local.ssm_cluster_key_prefix, "db_port")
  value       = var.database_port
  description = "Aurora Postgres DB Master port"
  type        = "String"
  overwrite   = true
}
