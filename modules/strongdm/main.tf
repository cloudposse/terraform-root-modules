locals {
  enabled         = module.this.enabled
  create_roles    = local.enabled && var.create_roles
  install_gateway = local.enabled && var.install_gateway
  install_relay   = local.enabled && var.install_relay
  register_nodes  = local.enabled && var.register_nodes
  dns_suffix      = "${var.stage}.${var.environment}.${var.dns_zone}"
}

data "aws_ssm_parameter" "api_access_key" {
  count    = local.enabled ? 1 : 0
  name     = "/vpn/sdm/api_access_key"
  provider = aws.api_keys
}

data "aws_ssm_parameter" "api_secret_key" {
  count    = local.enabled ? 1 : 0
  name     = "/vpn/sdm/api_secret_key"
  provider = aws.api_keys
}

data "aws_ssm_parameter" "ssh_admin_token" {
  count    = local.enabled ? 1 : 0
  name     = "/vpn/sdm/ssh-admin-token"
  provider = aws.api_keys
}

# Create a gateway
resource "sdm_node" "gateway" {
  count = local.install_gateway ? 2 : 0
  gateway {
    # The 6 dashes tells StrongDM to ignore what follows and
    # consider what comes before it to be the logical name of the
    # gateway, so that both gateways will share things like connection
    # status and resource discovery
    name           = "${module.this.id}-gateway------${count.index + 1}"
    listen_address = "sdm-${count.index + 1}.${local.dns_suffix}:5000"
    bind_address   = "0.0.0.0:5000"
  }
}

# Create a relay
resource "sdm_node" "relay" {
  count = local.install_relay ? 2 : 0
  relay {
    name = "${module.this.id}-relay------${count.index + 1}"
  }
}

resource "aws_ssm_parameter" "gateway_tokens" {
  count       = local.install_gateway ? 2 : 0
  name        = "/vpn/sdm/gateway/${count.index + 1}/token"
  value       = sdm_node.gateway[count.index].gateway[0].token
  description = "Gateway authentication token"
  type        = "SecureString"
  overwrite   = "true"
  key_id      = var.kms_alias_name
}


resource "aws_ssm_parameter" "relay_tokens" {
  count       = local.install_relay ? 2 : 0
  name        = "/vpn/sdm/relay/${count.index + 1}/token"
  value       = sdm_node.relay[count.index].relay[0].token
  description = "Relay authentication token"
  type        = "SecureString"
  overwrite   = "true"
  key_id      = var.kms_alias_name
}

resource "aws_ssm_parameter" "ssh_admin_token" {
  count       = local.register_nodes ? 1 : 0
  name        = "/vpn/sdm/ssh-admin-token"
  value       = data.aws_ssm_parameter.ssh_admin_token[0].value
  description = "Admin token for registering SSH nodes"
  type        = "SecureString"
  overwrite   = "true"
  key_id      = var.kms_alias_name
}
