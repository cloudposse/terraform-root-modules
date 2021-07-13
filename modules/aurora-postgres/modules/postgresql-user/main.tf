
locals {
  db_user         = length(var.db_user) > 0 ? var.db_user : var.service_name
  db_password     = length(var.db_password) > 0 ? var.db_password : join("", random_password.db_password.*.result)
  db_password_key = format("%s/%s/%s/%s", var.ssm_path_prefix, var.service_name, local.db_user, "db_password")
}

resource "random_password" "db_password" {
  count   = var.enabled && length(var.db_password) == 0 ? 1 : 0
  length  = 33
  special = false

  keepers = {
    db_user = local.db_user
  }
}

resource "postgresql_role" "default" {
  count    = var.enabled ? 1 : 0
  name     = local.db_user
  password = local.db_password
  login    = true
}

# Apply the configured grants to the user
resource "postgresql_grant" "default" {
  count       = var.enabled ? length(var.grants) : 0
  role        = join("", postgresql_role.default.*.name)
  database    = var.grants[count.index].db
  schema      = var.grants[count.index].schema
  object_type = var.grants[count.index].object_type
  privileges  = var.grants[count.index].grant
}

resource "aws_ssm_parameter" "db_password" {
  count       = var.enabled ? 1 : 0
  name        = local.db_password_key
  value       = local.db_password
  description = "PostgreSQL Password for the PostreSQL User (role) created by this module"
  type        = "SecureString"
  overwrite   = true
}
