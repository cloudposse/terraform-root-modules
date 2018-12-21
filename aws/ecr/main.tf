terraform {
  required_version = ">= 0.11.2"

  backend "s3" {}
}

variable "aws_assume_role_arn" {
  type = "string"
}

variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "region" {
  type        = "string"
  description = "AWS region"
}

variable "zone_name" {
  type        = "string"
  description = "DNS zone name"
}

variable "masters_name" {
  type        = "string"
  default     = "masters"
  description = "Kops masters subdomain name in the cluster DNS zone"
}

variable "nodes_name" {
  type        = "string"
  default     = "nodes"
  description = "Kops nodes subdomain name in the cluster DNS zone"
}

provider "aws" {
  assume_role {
    role_arn = "${var.aws_assume_role_arn}"
  }
}

module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.7"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "ecr"
}

module "kops_metadata" {
  source       = "git::https://github.com/cloudposse/terraform-aws-kops-metadata.git?ref=tags/0.1.1"
  dns_zone     = "${var.region}.${var.zone_name}"
  masters_name = "${var.masters_name}"
  nodes_name   = "${var.nodes_name}"
}
