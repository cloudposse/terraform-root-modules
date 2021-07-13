output "broker_id" {
  value       = module.mq_broker.broker_id
  description = "AmazonMQ broker ID"
}

output "broker_arn" {
  value       = module.mq_broker.broker_arn
  description = "AmazonMQ broker ARN"
}

output "primary_console_url" {
  value       = module.mq_broker.primary_console_url
  description = "AmazonMQ active web console URL"
}

output "primary_ssl_endpoint" {
  value       = module.mq_broker.primary_ssl_endpoint
  description = "AmazonMQ primary SSL endpoint"
}

output "primary_amqp_ssl_endpoint" {
  value       = module.mq_broker.primary_amqp_ssl_endpoint
  description = "AmazonMQ primary AMQP+SSL endpoint"
}

output "primary_stomp_ssl_endpoint" {
  value       = module.mq_broker.primary_stomp_ssl_endpoint
  description = "AmazonMQ primary STOMP+SSL endpoint"
}

output "primary_mqtt_ssl_endpoint" {
  value       = module.mq_broker.primary_mqtt_ssl_endpoint
  description = "AmazonMQ primary MQTT+SSL endpoint"
}

output "primary_wss_endpoint" {
  value       = module.mq_broker.primary_wss_endpoint
  description = "AmazonMQ primary WSS endpoint"
}

output "primary_ip_address" {
  value       = module.mq_broker.primary_ip_address
  description = "AmazonMQ primary IP address"
}

output "secondary_console_url" {
  value       = module.mq_broker.secondary_console_url
  description = "AmazonMQ secondary web console URL"
}

output "secondary_ssl_endpoint" {
  value       = module.mq_broker.secondary_ssl_endpoint
  description = "AmazonMQ secondary SSL endpoint"
}

output "secondary_amqp_ssl_endpoint" {
  value       = module.mq_broker.secondary_amqp_ssl_endpoint
  description = "AmazonMQ secondary AMQP+SSL endpoint"
}

output "secondary_stomp_ssl_endpoint" {
  value       = module.mq_broker.secondary_stomp_ssl_endpoint
  description = "AmazonMQ secondary STOMP+SSL endpoint"
}

output "secondary_mqtt_ssl_endpoint" {
  value       = module.mq_broker.secondary_mqtt_ssl_endpoint
  description = "AmazonMQ secondary MQTT+SSL endpoint"
}

output "secondary_wss_endpoint" {
  value       = module.mq_broker.secondary_wss_endpoint
  description = "AmazonMQ secondary WSS endpoint"
}

output "secondary_ip_address" {
  value       = module.mq_broker.secondary_ip_address
  description = "AmazonMQ secondary IP address"
}
