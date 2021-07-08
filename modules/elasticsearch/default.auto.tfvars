enabled = false

name = "es"

instance_type = "t3.medium.elasticsearch"

elasticsearch_version = "7.9"

# calculated: length(local.vpc_private_subnet_ids)
# instance_count = 2

# calculated: length(local.vpc_private_subnet_ids) > 1 ? true : false
# zone_awareness_enabled = true

encrypt_at_rest_enabled = false

dedicated_master_enabled = false

elasticsearch_subdomain_name = "es"

kibana_subdomain_name = "kibana"

ebs_volume_size = 40

create_iam_service_linked_role = true

kibana_hostname_enabled = true

domain_hostname_enabled = true

# Allow anonymous access without request signing, relying on network access controls
# https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/es-ac.html#es-ac-types-ip
# https://aws.amazon.com/premiumsupport/knowledge-center/anonymous-not-authorized-elasticsearch/
elasticsearch_iam_role_arns = [
  "*",
]
elasticsearch_iam_actions = [
  "es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost", "es:ESHttpHead", "es:Describe*", "es:List*",
  // delete and patch are destructive and could be left out
  "es:ESHttpDelete", "es:ESHttpPatch"
]
