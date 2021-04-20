# Component: `iam-delegated-roles`

This component is responsible for provisioning all delegated user and system IAM roles. It sets them up to be assumed from the primary, identity account roles. This is expected to be used alongside and applied after [the `iam-primary-roles` component](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/iam-primary-roles) is applied to the identity account.

## Usage

**Stack Level**: Global

Here's an example snippet for how to use this component. This specific usage is for an audit stack (e.g. `gbl-audit.yaml`) where limiting the default permissions of the roles is desired.

```yaml
components:
  terraform:
    iam-delegated-roles:
      vars:
        exclude_roles: ["helm"]
        account_role_policy_arns:
          # IAM Policy ARNs to attach to each role, overriding the defaults
          admin: ["arn:aws:iam::aws:policy/PowerUserAccess"]
          ops: ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
          poweruser: ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
          observer: ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
          # Use default for terraform

        trusted_primary_role_overrides:
          # Terraform in audit can wipe out logs, so access to it needs to be restricted
          terraform: ["admin"]
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.32 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | ~> 0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.32 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account_map"></a> [account\_map](#module\_account\_map) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../account-map/modules/iam-roles |  |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_primary_roles"></a> [primary\_roles](#module\_primary\_roles) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_tfstate"></a> [tfstate](#module\_tfstate) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tfstate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [terraform_remote_state.primary_roles](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.tfstate](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_map_environment_name"></a> [account\_map\_environment\_name](#input\_account\_map\_environment\_name) | The name of the environment where `account_map` is provisioned | `string` | `"gbl"` | no |
| <a name="input_account_map_stage_name"></a> [account\_map\_stage\_name](#input\_account\_map\_stage\_name) | The name of the stage where `account_map` is provisioned | `string` | `"root"` | no |
| <a name="input_account_role_policy_arns"></a> [account\_role\_policy\_arns](#input\_account\_role\_policy\_arns) | Custom IAM policy ARNs to override defaults | `map(list(string))` | `{}` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_allow_same_account_assume_role"></a> [allow\_same\_account\_assume\_role](#input\_allow\_same\_account\_assume\_role) | Set true to allow roles to assume other roles in the same account | `bool` | `false` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_default_account_role_policy_arns"></a> [default\_account\_role\_policy\_arns](#input\_default\_account\_role\_policy\_arns) | Custom IAM policy ARNs to override defaults | `map(list(string))` | n/a | yes |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_exclude_roles"></a> [exclude\_roles](#input\_exclude\_roles) | Roles in roles\_config that should NOT be created | `list(string)` | `[]` | no |
| <a name="input_iam_primary_roles_stage_name"></a> [iam\_primary\_roles\_stage\_name](#input\_iam\_primary\_roles\_stage\_name) | The name of the stage where the IAM primary roles are provisioned | `string` | `"identity"` | no |
| <a name="input_iam_role_max_session_duration"></a> [iam\_role\_max\_session\_duration](#input\_iam\_role\_max\_session\_duration) | The maximum session duration (in seconds) that you want to set for the IAM roles. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours | `number` | `43200` | no |
| <a name="input_iam_roles_environment_name"></a> [iam\_roles\_environment\_name](#input\_iam\_roles\_environment\_name) | The name of the environment where the IAM roles are provisioned | `string` | `"gbl"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_role_arn"></a> [import\_role\_arn](#input\_import\_role\_arn) | IAM Role ARN to use when importing a resource | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_primary_account_id"></a> [primary\_account\_id](#input\_primary\_account\_id) | Primary authentication account id used as the source for assume role | `string` | n/a | yes |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_tfstate_account_id"></a> [tfstate\_account\_id](#input\_tfstate\_account\_id) | The ID of the account where the Terraform remote state backend is provisioned | `string` | `""` | no |
| <a name="input_tfstate_assume_role"></a> [tfstate\_assume\_role](#input\_tfstate\_assume\_role) | Set to false to use the caller's role to access the Terraform remote state | `bool` | `true` | no |
| <a name="input_tfstate_backend_environment_name"></a> [tfstate\_backend\_environment\_name](#input\_tfstate\_backend\_environment\_name) | The name of the stage where the Terraform state backend is provisioned | `string` | `"gbl"` | no |
| <a name="input_tfstate_backend_stage_name"></a> [tfstate\_backend\_stage\_name](#input\_tfstate\_backend\_stage\_name) | The name of the stage where the Terraform state backend is provisioned | `string` | `"root"` | no |
| <a name="input_tfstate_bucket_environment_name"></a> [tfstate\_bucket\_environment\_name](#input\_tfstate\_bucket\_environment\_name) | The name of the environment for Terraform state bucket | `string` | `""` | no |
| <a name="input_tfstate_bucket_stage_name"></a> [tfstate\_bucket\_stage\_name](#input\_tfstate\_bucket\_stage\_name) | The name of the stage for Terraform state bucket | `string` | `"root"` | no |
| <a name="input_tfstate_existing_role_arn"></a> [tfstate\_existing\_role\_arn](#input\_tfstate\_existing\_role\_arn) | The ARN of the existing IAM Role to access the Terraform remote state. If not provided and `remote_state_assume_role` is `true`, a role will be constructed from `remote_state_role_arn_template` | `string` | `""` | no |
| <a name="input_tfstate_role_arn_template"></a> [tfstate\_role\_arn\_template](#input\_tfstate\_role\_arn\_template) | IAM Role ARN template for accessing the Terraform remote state | `string` | `"arn:aws:iam::%s:role/%s-%s-%s-%s"` | no |
| <a name="input_tfstate_role_environment_name"></a> [tfstate\_role\_environment\_name](#input\_tfstate\_role\_environment\_name) | The name of the environment for Terraform state IAM role | `string` | `"gbl"` | no |
| <a name="input_tfstate_role_name"></a> [tfstate\_role\_name](#input\_tfstate\_role\_name) | IAM Role name for accessing the Terraform remote state | `string` | `"terraform"` | no |
| <a name="input_tfstate_role_stage_name"></a> [tfstate\_role\_stage\_name](#input\_tfstate\_role\_stage\_name) | The name of the stage for Terraform state IAM role | `string` | `"root"` | no |
| <a name="input_trusted_primary_role_overrides"></a> [trusted\_primary\_role\_overrides](#input\_trusted\_primary\_role\_overrides) | Override default list of primary roles that can assume this one | `map(list(string))` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_long_name_policy_arn_map"></a> [role\_long\_name\_policy\_arn\_map](#output\_role\_long\_name\_policy\_arn\_map) | Map of role long names to attached IAM Policy ARNs |
| <a name="output_role_name_role_arn_map"></a> [role\_name\_role\_arn\_map](#output\_role\_name\_role\_arn\_map) | Map of role names to role ARNs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## References

- [cloudposse/terraform-aws-components](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/iam-delegated-roles) - Cloud Posse's upstream component

[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/component)
