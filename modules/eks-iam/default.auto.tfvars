# This file is included by default in terraform plans

enabled = true

name = "eks"

standard_service_accounts = [
  "alb-controller",
  "external-dns",
  "autoscaler"
]

optional_service_accounts = []
