provider "aws" {
  region = var.region

  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}

variable "aws_assume_role_arn" {
  type        = string
  description = "ARN of the IAM role to assume to access the AWS account where the infrastructure is provisioned"
}
