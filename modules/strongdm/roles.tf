locals {
  roles = toset(["db-user", "ssh-user", "kubernetes-user"])
}

resource "sdm_role" "all_access" {
  count     = local.create_roles ? 1 : 0
  name      = "all-access"
  composite = true
}

resource "sdm_role" "roles" {
  for_each = local.create_roles ? local.roles : []
  name     = each.key
}

# create composite role "all_access"
resource "sdm_role_attachment" "all_access" {
  for_each          = local.create_roles ? local.roles : []
  composite_role_id = join("", sdm_role.all_access.*.id)
  attached_role_id  = sdm_role.roles[each.key].id
}

#data "sdm_resource" "datasources" {
#  count = local.roles_enabled ? 1 : 0
#  type  = "aurora_postgres"
#}
#
#resource "sdm_role_grant" "postgres" {
#  for_each    = toset(distinct(flatten(concat(data.sdm_resource.datasources.*.ids, sdm_resource.postgres_admin.*.id))))
#  role_id     = sdm_role.roles["db-user"].id
#  resource_id = each.key
#}
