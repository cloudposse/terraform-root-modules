locals {
  domains_set    = toset(var.domain_names)
  zone_recs_map  = { for zone in var.record_config : "${zone.name}${zone.root_zone}.${zone.type}" => zone }
  zone_alias_map = { for zone in var.alias_record_config : "${zone.name}${zone.root_zone}.${zone.type}" => zone }
}

resource "aws_route53_zone" "root" {
  for_each = local.domains_set

  name    = each.value
  comment = "DNS zone for the ${each.value} root domain"
  tags    = module.this.tags
}

resource "aws_route53_record" "soa" {
  for_each = aws_route53_zone.root

  allow_overwrite = true
  zone_id         = aws_route53_zone.root[each.key].zone_id
  name            = aws_route53_zone.root[each.key].name
  type            = "SOA"
  ttl             = "60"

  records = [
    "${aws_route53_zone.root[each.key].name_servers[0]}. ${var.dns_soa_config}"
  ]
}

resource "aws_route53_record" "dnsrec" {
  for_each = local.zone_recs_map

  name    = format("%s%s", each.value.name, each.value.root_zone)
  type    = each.value.type
  zone_id = aws_route53_zone.root[each.value.root_zone].zone_id
  ttl     = each.value.ttl

  records = each.value.records
}

resource "aws_route53_record" "aliasrec" {
  for_each = local.zone_alias_map

  name    = format("%s%s", each.value.name, each.value.root_zone)
  type    = each.value.type
  zone_id = aws_route53_zone.root[each.value.root_zone].zone_id


  alias {
    name                   = each.value.record
    zone_id                = each.value.zone_id
    evaluate_target_health = each.value.target_health
  }
}
