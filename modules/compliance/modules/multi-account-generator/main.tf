module "utils" {
  source  = "cloudposse/utils/aws"
  version = "0.5.0"
  context = module.this.context
}

locals {
  regions = toset(module.utils.enabled_regions)
}

resource "local_file" "providers" {
  for_each = local.regions
  content = templatefile(format("%s/region.tf.tpl", path.module), {
    region = each.value
    short  = module.utils.region_az_alt_code_maps.to_fixed[each.value]
  })
  filename = "../../auto-generated-${module.utils.region_az_alt_code_maps.to_fixed[each.value]}.tf"
}
