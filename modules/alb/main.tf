module "alb" {
  source  = "cloudposse/alb/aws"
  version = "0.33.2"

  vpc_id          = module.remote_vpc.outputs.vpc_id
  subnet_ids      = module.remote_vpc.outputs.public_subnet_ids
  certificate_arn = module.remote_dns.outputs.certificate.arn

  internal                                = var.internal
  http_enabled                            = var.http_enabled
  https_enabled                           = var.https_enabled
  http2_enabled                           = var.http2_enabled
  http_redirect                           = var.http_redirect
  access_logs_enabled                     = var.access_logs_enabled
  alb_access_logs_s3_bucket_force_destroy = var.alb_access_logs_s3_bucket_force_destroy
  cross_zone_load_balancing_enabled       = var.cross_zone_load_balancing_enabled
  idle_timeout                            = var.idle_timeout
  ip_address_type                         = var.ip_address_type
  deletion_protection_enabled             = var.deletion_protection_enabled
  deregistration_delay                    = var.deregistration_delay
  health_check_path                       = var.health_check_path
  health_check_timeout                    = var.health_check_timeout
  health_check_healthy_threshold          = var.health_check_healthy_threshold
  health_check_unhealthy_threshold        = var.health_check_unhealthy_threshold
  health_check_interval                   = var.health_check_interval
  health_check_matcher                    = var.health_check_matcher
  target_group_port                       = var.target_group_port
  target_group_target_type                = var.target_group_target_type
  stickiness                              = var.stickiness

  context = module.this.context
}