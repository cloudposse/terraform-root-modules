output "database_name" {
  value       = local.database_name
  description = "Postgres database name"
}

output "database_name_info" {
  value       = "Postgres database name is stored in SSM under ${join("", aws_ssm_parameter.aurora_postgres_database_name.*.name)}"
  description = "Location of Postgres database name"
}

output "admin_username" {
  value       = module.aurora_postgres_cluster.master_username
  description = "Postgres admin username"
}

output "admin_username_info" {
  value       = "Postgres admin username is stored in SSM under ${join("", aws_ssm_parameter.aurora_postgres_admin_username.*.name)}"
  description = "Location of Postgres admin username"
}

output "admin_password_info" {
  value       = "Postgres admin password is stored in SSM under ${join("", aws_ssm_parameter.aurora_postgres_admin_password.*.name)}"
  description = "Location of Postgres admin password"
}

output "master_hostname" {
  value       = module.aurora_postgres_cluster.master_host
  description = "Postgres master hostname"
}

output "master_hostname_info" {
  value       = "Postgres master hostname is stored in SSM under ${join("", aws_ssm_parameter.master_hostname.*.name)}"
  description = "Location of Postgres master hostname"
}

output "replicas_hostname" {
  value       = module.aurora_postgres_cluster.replicas_host
  description = "Postgres replicas hostname"
}

output "replicas_hostname_info" {
  value       = "Postgres replicas hostname is stored in SSM under ${join("", aws_ssm_parameter.replicas_hostname.*.name)}"
  description = "Location of Postgres replicas hostname"
}

output "cluster_identifier" {
  value       = module.aurora_postgres_cluster.cluster_identifier
  description = "Postgres cluster identifier"
}

output "cluster_identifier_info" {
  value       = "Postgres cluster identifier is stored in SSM under ${join("", aws_ssm_parameter.cluster_identifier.*.name)}"
  description = "Location of Postgres cluster identifier"
}

output "ssm_key_prefix" {
  value       = local.ssm_cluster_key_prefix
  description = "SSM key prefix of all parameters stored for this cluster"
}

output "config_map" {
  value = {
    cluster          = module.aurora_postgres_cluster.cluster_identifier
    database         = local.database_name
    hostname         = module.aurora_postgres_cluster.master_host
    port             = var.database_port
    username         = module.aurora_postgres_cluster.master_username
    password_ssm_key = format("%s/%s", local.ssm_cluster_key_prefix, "admin_password")
  }
}

output "additional_users" {
  value       = local.sanitized_additional_users
  description = "Information about additional DB users created by request"
}
