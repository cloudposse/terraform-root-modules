resource "helm_release" "gateway" {
  count = local.enabled ? 2 : 0

  name            = "${module.this.name}-gateway-${count.index + 1}"
  chart           = "./charts/strongdm"
  version         = "0.1.0"
  namespace       = var.kubernetes_namespace
  wait            = true
  atomic          = false
  cleanup_on_fail = false

  set {
    name  = "dnsname"
    value = "${module.this.name}-${count.index + 1}.${local.dns_suffix}"
  }

  set_sensitive {
    name  = "relayToken"
    value = sdm_node.gateway[count.index].gateway[count.index].token
  }
}

resource "helm_release" "relay" {
  count = local.enabled ? 2 : 0

  name            = "${module.this.name}-relay-${count.index + 1}"
  chart           = "./charts/strongdm"
  version         = "0.1.0"
  namespace       = var.kubernetes_namespace
  wait            = true
  atomic          = false
  cleanup_on_fail = false

  set_sensitive {
    name  = "relayToken"
    value = sdm_node.relay[count.index].relay[count.index].token
  }
}

resource "helm_release" "node" {
  count = local.enabled ? 1 : 0

  name            = "${module.this.name}-node"
  chart           = "./charts/strongdm"
  version         = "0.1.0"
  namespace       = var.kubernetes_namespace
  wait            = true
  atomic          = false
  cleanup_on_fail = false

  set {
    name  = "install_timeout_seconds"
    value = 30
  }

  set {
    name  = "install_healthcheck_period_seconds"
    value = 600
  }

  set_sensitive {
    name  = "nodeToken"
    value = local.enabled ? data.aws_ssm_parameter.ssh_admin_token[0].value : null
  }
}

resource "helm_release" "cleanup" {
  count = local.enabled ? 1 : 0

  name            = "${module.this.name}-cleanup"
  chart           = "raw"
  repository      = "https://charts.helm.sh/incubator"
  version         = "0.2.5"
  namespace       = var.kubernetes_namespace
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  values = [
    templatefile("${path.module}/templates/strongdm-cleanup.values.yaml.tpl", {
      server_name            = "${module.this.name}-cleanup"
      cleanup_period_seconds = 900
      max_unhealthy_per_run  = 100
      # See https://github.com/hashicorp/terraform/issues/16775#issuecomment-349170517
      sdm_cleanup = jsonencode(file("${path.module}/templates/sdm-cleanup.sh"))
    })
  ]
}
