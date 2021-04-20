data "aws_secretsmanager_secret" "datadog_api_key" {
  count = var.secrets_store_type == "ASM" ? 1 : 0
  name  = var.datadog_api_secret_key
}

data "aws_secretsmanager_secret_version" "datadog_api_key" {
  count     = var.secrets_store_type == "ASM" ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.datadog_api_key[0].id
}

data "aws_secretsmanager_secret" "datadog_app_key" {
  count = var.secrets_store_type == "ASM" ? 1 : 0
  name  = var.datadog_app_secret_key
}

data "aws_secretsmanager_secret_version" "datadog_app_key" {
  count     = var.secrets_store_type == "ASM" ? 1 : 0
  secret_id = data.aws_secretsmanager_secret.datadog_app_key[0].id
}
