variable "region" {
  type        = string
  description = "AWS region"
}

variable "instance_type" {
  type        = string
  description = "The type of the instance"
}

variable "elasticsearch_version" {
  type        = string
  description = "Version of Elasticsearch to deploy (_e.g._ `7.1`, `6.8`, `6.7`, `6.5`, `6.4`, `6.3`, `6.2`, `6.0`, `5.6`, `5.5`, `5.3`, `5.1`, `2.3`, `1.5`"
}

variable "encrypt_at_rest_enabled" {
  type        = bool
  description = "Whether to enable encryption at rest"
}

variable "dedicated_master_enabled" {
  type        = bool
  description = "Indicates whether dedicated master nodes are enabled for the cluster"
}

variable "elasticsearch_subdomain_name" {
  type        = string
  description = "The name of the subdomain for Elasticsearch in the DNS zone (_e.g._ `elasticsearch`, `ui`, `ui-es`, `search-ui`)"
}

variable "kibana_subdomain_name" {
  type        = string
  description = "The name of the subdomain for Kibana in the DNS zone (_e.g._ `kibana`, `ui`, `ui-es`, `search-ui`, `kibana.elasticsearch`)"
}

variable "create_iam_service_linked_role" {
  type        = bool
  description = "Whether to create `AWSServiceRoleForAmazonElasticsearchService` service-linked role. Set it to `false` if you already have an ElasticSearch cluster created in the AWS account and AWSServiceRoleForAmazonElasticsearchService already exists. See https://github.com/terraform-providers/terraform-provider-aws/issues/5218 for more info"
}

variable "ebs_volume_size" {
  type        = number
  description = "EBS volumes for data storage in GB"
}

variable "domain_hostname_enabled" {
  type        = bool
  description = "Explicit flag to enable creating a DNS hostname for ES. If `true`, then `var.dns_zone_id` is required."
}

variable "kibana_hostname_enabled" {
  type        = bool
  description = "Explicit flag to enable creating a DNS hostname for Kibana. If `true`, then `var.dns_zone_id` is required."
}

# https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-ac.html
variable "elasticsearch_iam_actions" {
  type        = list(string)
  default     = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost", "es:ESHttpHead", "es:Describe*", "es:List*"]
  description = "List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost`"
}

variable "elasticsearch_iam_role_arns" {
  type        = list(string)
  default     = []
  description = "List of additional IAM role ARNs to permit access to the Elasticsearch domain"
}
