output "alb_name" {
  description = "The ARN suffix of the ALB"
  value       = module.alb.alb_name
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = module.alb.alb_arn
}

output "alb_arn_suffix" {
  description = "The ARN suffix of the ALB"
  value       = module.alb.alb_arn_suffix
}

output "alb_dns_name" {
  description = "DNS name of ALB"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "The ID of the zone which ALB is provisioned"
  value       = module.alb.alb_zone_id
}

output "security_group_id" {
  description = "The security group ID of the ALB"
  value       = module.alb.security_group_id
}

output "default_target_group_arn" {
  description = "The default target group ARN"
  value       = module.alb.default_target_group_arn
}

output "http_listener_arn" {
  description = "The ARN of the HTTP forwarding listener"
  value       = module.alb.http_listener_arn
}

output "http_redirect_listener_arn" {
  description = "The ARN of the HTTP to HTTPS redirect listener"
  value       = module.alb.http_redirect_listener_arn
}

output "https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = module.alb.https_listener_arn
}

output "listener_arns" {
  description = "A list of all the listener ARNs"
  value       = module.alb.listener_arns
}

output "access_logs_bucket_id" {
  description = "The S3 bucket ID for access logs"
  value       = module.alb.access_logs_bucket_id
}
