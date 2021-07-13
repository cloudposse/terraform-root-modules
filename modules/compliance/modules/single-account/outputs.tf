output "config_iam_role_arn" {
  description = "The ARN of the AWS Config IAM Role"
  value       = module.aws_config.iam_role
}
