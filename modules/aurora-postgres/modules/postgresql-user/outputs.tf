output "notice" {
  value       = "Password for user ${local.db_user} is stored in SSM under ${local.db_password_key}"
  description = "Note to user"
}

output "db_user" {
  value       = local.db_user
  description = "DB user name"
}

output "db_user_password_ssm_key" {
  value       = local.db_password_key
  description = "SSM key under which user password is stored"
}

output "service_name" {
  value       = var.service_name
  description = "Service for which this user was created"
}
