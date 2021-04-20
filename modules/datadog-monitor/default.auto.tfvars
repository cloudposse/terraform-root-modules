# This file is included by default in terraform plans

enabled = true

datadog_monitors_config_paths = [
  "https://raw.githubusercontent.com/cloudposse/terraform-datadog-monitor/0.9.0/catalog/ec2.yaml",
  "https://raw.githubusercontent.com/cloudposse/terraform-datadog-monitor/0.9.0/catalog/k8s.yaml"
]
