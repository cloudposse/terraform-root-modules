# Component: `aurora-postgres`

This component is responsible for provisioning Aurora Postgres RDS clusters.
It seeds relevant database information (hostnames, username, password, etc.) into AWS SSM Parameter Store.

**NOTE**: Creating additional users (including read-only users) and databases
requires Spacelift.

## Usage

**Stack Level**: Regional

Here's an example for how to use this component.

`stacks/rds/aurora-postgres-defaults.yaml` file (base component for all Aurora Postgres clusters with default settings):

```yaml
components:
  terraform:
    aurora-postgres:
      vars:
        instance_type: db.r5.large
        cluster_size: 1
        engine: aurora-postgresql
        cluster_family: aurora-postgresql12
        engine_version: 12.4
        engine_mode: provisioned
        iam_database_authentication_enabled: false
        deletion_protection: true
        storage_encrypted: true
        database_name: ""
        admin_user: ""
        admin_password: ""
        read_only_users_enabled: false
```
Example (not actual)
`stacks/ue1-dev.yaml` file (override the default settings for the cluster in `dev` account, create an additional database and user):

```yaml
import:
  - rds/aurora-postgres-defaults

components:
  terraform:
    aurora-postgres:
      vars:
        instance_type: db.r5.large
        cluster_size: 1
        cluster_name: main
        database_name: main
        additional_databases:
        - example_db
        additional_users:
          example_service:
            db_user: example_user
            db_password: ""
            grants:
            - grant: [ "ALL" ]
              db: example_db
              object_type: database
              schema: null
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.3 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | >= 1.11.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.3 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | >= 1.11.2 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_additional_users"></a> [additional\_users](#module\_additional\_users) | ./modules/postgresql-user |  |
| <a name="module_aurora_postgres_cluster"></a> [aurora\_postgres\_cluster](#module\_aurora\_postgres\_cluster) | cloudposse/rds-cluster/aws | 0.44.1 |
| <a name="module_cluster"></a> [cluster](#module\_cluster) | cloudposse/label/null | 0.24.1 |
| <a name="module_dns_gbl_delegated"></a> [dns\_gbl\_delegated](#module\_dns\_gbl\_delegated) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_eks"></a> [eks](#module\_eks) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../account-map/modules/iam-roles |  |
| <a name="module_kms_key_rds"></a> [kms\_key\_rds](#module\_kms\_key\_rds) | cloudposse/kms-key/aws | 0.9.0 |
| <a name="module_read_only_cluster_user"></a> [read\_only\_cluster\_user](#module\_read\_only\_cluster\_user) | ./modules/postgresql-user |  |
| <a name="module_read_only_db_users"></a> [read\_only\_db\_users](#module\_read\_only\_db\_users) | ./modules/postgresql-user |  |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.admin_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.admin_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.aurora_postgres_admin_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.aurora_postgres_admin_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.aurora_postgres_database_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.aurora_postgres_database_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.cluster_identifier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.master_hostname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.master_port](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.replicas_hostname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [postgresql_database.additional](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/database) | resource |
| [postgresql_default_privileges.read_only_tables_cluster](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [postgresql_default_privileges.read_only_tables_users](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/default_privileges) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_pet.admin_user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_pet.database_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_key_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_databases"></a> [additional\_databases](#input\_additional\_databases) | n/a | `set(string)` | `[]` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_additional_users"></a> [additional\_users](#input\_additional\_users) | n/a | <pre>map(object({<br>    db_user : string<br>    db_password : string<br>    grants : list(object({<br>      grant : list(string)<br>      db : string<br>      schema : string<br>      object_type : string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Postgres password for the admin user | `string` | `""` | no |
| <a name="input_admin_user"></a> [admin\_user](#input\_admin\_user) | Postgres admin user name | `string` | `""` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDRs allowed to access the database (in addition to security groups and subnets) | `list(string)` | `[]` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Whether to enable cluster autoscaling | `bool` | `false` | no |
| <a name="input_autoscaling_max_capacity"></a> [autoscaling\_max\_capacity](#input\_autoscaling\_max\_capacity) | Maximum number of instances to be maintained by the autoscaler | `number` | `5` | no |
| <a name="input_autoscaling_min_capacity"></a> [autoscaling\_min\_capacity](#input\_autoscaling\_min\_capacity) | Minimum number of instances to be maintained by the autoscaler | `number` | `1` | no |
| <a name="input_autoscaling_policy_type"></a> [autoscaling\_policy\_type](#input\_autoscaling\_policy\_type) | Autoscaling policy type. `TargetTrackingScaling` and `StepScaling` are supported | `string` | `"TargetTrackingScaling"` | no |
| <a name="input_autoscaling_scale_in_cooldown"></a> [autoscaling\_scale\_in\_cooldown](#input\_autoscaling\_scale\_in\_cooldown) | The amount of time, in seconds, after a scaling activity completes and before the next scaling down activity can start. Default is 300s | `number` | `300` | no |
| <a name="input_autoscaling_scale_out_cooldown"></a> [autoscaling\_scale\_out\_cooldown](#input\_autoscaling\_scale\_out\_cooldown) | The amount of time, in seconds, after a scaling activity completes and before the next scaling up activity can start. Default is 300s | `number` | `300` | no |
| <a name="input_autoscaling_target_metrics"></a> [autoscaling\_target\_metrics](#input\_autoscaling\_target\_metrics) | The metrics type to use. If this value isn't provided the default is CPU utilization | `string` | `"RDSReaderAverageCPUUtilization"` | no |
| <a name="input_autoscaling_target_value"></a> [autoscaling\_target\_value](#input\_autoscaling\_target\_value) | The target value to scale with respect to target metrics | `number` | `75` | no |
| <a name="input_cluster_dns_name_part"></a> [cluster\_dns\_name\_part](#input\_cluster\_dns\_name\_part) | Part of DNS name added to module and cluster name for DNS for cluster endpoint | `string` | `"writer"` | no |
| <a name="input_cluster_family"></a> [cluster\_family](#input\_cluster\_family) | Family of the DB parameter group. Valid values for Aurora PostgreSQL: `aurora-postgresql9.6`, `aurora-postgresql10`, `aurora-postgresql11`, `aurora-postgresql12` | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Short name for this cluster | `string` | n/a | yes |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Postgres cluster size | `number` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_database"></a> [database](#input\_database) | Database for the Postgres provider to connect to. The default is `postgres` | `string` | `"postgres"` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name for an automatically created database on cluster creation | `string` | n/a | yes |
| <a name="input_database_port"></a> [database\_port](#input\_database\_port) | Database port | `number` | `5432` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Specifies whether the Cluster should have deletion protection enabled. The database can't be deleted when this value is set to `true` | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_dns_gbl_delegated_environment_name"></a> [dns\_gbl\_delegated\_environment\_name](#input\_dns\_gbl\_delegated\_environment\_name) | The name of the environment where global `dns_delegated` is provisioned | `string` | `"gbl"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery | `list(string)` | `[]` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Name of the database engine to be used for the DB cluster | `string` | n/a | yes |
| <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode) | The database engine mode. Valid values: `global`, `multimaster`, `parallelquery`, `provisioned`, `serverless` | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Engine version of the Aurora global database | `string` | n/a | yes |
| <a name="input_enhanced_monitoring_role_enabled"></a> [enhanced\_monitoring\_role\_enabled](#input\_enhanced\_monitoring\_role\_enabled) | A boolean flag to enable/disable the creation of the enhanced monitoring IAM role. If set to `false`, the module will not create a new role and will use `rds_monitoring_role_arn` for enhanced monitoring | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `bool` | n/a | yes |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_profile_name"></a> [import\_profile\_name](#input\_import\_profile\_name) | AWS Profile name to use when importing a resource | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type for Postgres cluster | `string` | n/a | yes |
| <a name="input_kms_alias_name_ssm"></a> [kms\_alias\_name\_ssm](#input\_kms\_alias\_name\_ssm) | KMS alias name for SSM | `string` | `"alias/aws/ssm"` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range during which system maintenance can occur, in UTC | `string` | `"wed:03:00-wed:04:00"` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Whether to enable Performance Insights | `bool` | `false` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Set true to make this database accessible from the public internet | `bool` | `false` | no |
| <a name="input_rds_monitoring_interval"></a> [rds\_monitoring\_interval](#input\_rds\_monitoring\_interval) | The interval, in seconds, between points when enhanced monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60 | `number` | `0` | no |
| <a name="input_read_only_users_enabled"></a> [read\_only\_users\_enabled](#input\_read\_only\_users\_enabled) | Set `true` to automatically create read-only users for every database | `bool` | `false` | no |
| <a name="input_reader_dns_name_part"></a> [reader\_dns\_name\_part](#input\_reader\_dns\_name\_part) | Part of DNS name added to module and cluster name for DNS for cluster reader | `string` | `"reader"` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Normally AWS makes a snapshot of the database before deleting it. Set this to `true` in order to skip this.<br>NOTE: The final snapshot has a name derived from the cluster name. If you delete a cluster, get a final snapshot,<br>then create a cluster of the same name, its final snapshot will fail with a name collision unless you delete<br>the previous final snapshot first. | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this cluster from a snapshot | `string` | `null` | no |
| <a name="input_ssm_path_prefix"></a> [ssm\_path\_prefix](#input\_ssm\_path\_prefix) | Top level SSM path prefix (without leading or trailing slash) | `string` | `"aurora-postgres"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_users"></a> [additional\_users](#output\_additional\_users) | Information about additional DB users created by request |
| <a name="output_admin_password_info"></a> [admin\_password\_info](#output\_admin\_password\_info) | Location of Postgres admin password |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | Postgres admin username |
| <a name="output_admin_username_info"></a> [admin\_username\_info](#output\_admin\_username\_info) | Location of Postgres admin username |
| <a name="output_cluster_identifier"></a> [cluster\_identifier](#output\_cluster\_identifier) | Postgres cluster identifier |
| <a name="output_cluster_identifier_info"></a> [cluster\_identifier\_info](#output\_cluster\_identifier\_info) | Location of Postgres cluster identifier |
| <a name="output_config_map"></a> [config\_map](#output\_config\_map) | n/a |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | Postgres database name |
| <a name="output_database_name_info"></a> [database\_name\_info](#output\_database\_name\_info) | Location of Postgres database name |
| <a name="output_master_hostname"></a> [master\_hostname](#output\_master\_hostname) | Postgres master hostname |
| <a name="output_master_hostname_info"></a> [master\_hostname\_info](#output\_master\_hostname\_info) | Location of Postgres master hostname |
| <a name="output_read_only_users"></a> [read\_only\_users](#output\_read\_only\_users) | n/a |
| <a name="output_replicas_hostname"></a> [replicas\_hostname](#output\_replicas\_hostname) | Postgres replicas hostname |
| <a name="output_replicas_hostname_info"></a> [replicas\_hostname\_info](#output\_replicas\_hostname\_info) | Location of Postgres replicas hostname |
| <a name="output_ssm_key_prefix"></a> [ssm\_key\_prefix](#output\_ssm\_key\_prefix) | SSM key prefix of all parameters stored for this cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## References
* [cloudposse/terraform-aws-components](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/TODO) - Cloud Posse's upstream component


[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/component)
