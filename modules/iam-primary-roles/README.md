# Component: `iam-primary-roles`

This component is responsible for provisioning all primary user and system roles into the centralized identity account. This is expected to be use alongside [the `iam-delegated-roles` component](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/iam-delegated-roles) to provide fine grained role delegation across the account hierarchy.

## Usage

**Stack Level**: Global

Here's an example snippet for how to use this component. The component should only be applied once, which is typically done via the identity stack (e.g. `gbl-identity.yaml`).

```yaml
components:
  terraform:
    iam-primary-roles:
      vars:
        # When assume_role_restricted is true, assuming other roles in the identity
        # account is restricted based on the role configuration, but that can only
        # be set up after the roles are created. When the roles do not yet exist,
        # such as during cold start, set assume_role_restricted false, and all
        # roles will be able to assume other roles.
        assume_role_restricted: true

        # AWS SSO assigns users to unpredictable roles, so we cannot whitelist them
        # and must by default allow other roles in the identity account to assume
        # the identity roles, relying on their own IAM restrictions to limit them.
        default_assume_role_enabled: true

        primary_account_id: "xxxxxxxxxxxx" # `identity` account

        # The maximum session duration (in seconds) that you want to set for the IAM roles.
        # If you do not specify a value for this setting, the default maximum of one hour is applied.
        # This setting can have a value from 3600 (1 hour) to 43200 (12 hours)
        iam_role_max_session_duration: 43200

        # delegated_ roles_config is not just the set of roles for the identity account, it is
        # also the template for roles in all other "delegated" accounts.
        #
        # The role_policy_arn defines the policy for that role in the identity account,
        # which is why, for example, poweruser has ViewOnlyAccess. The policy for the
        # role in the delegated accounts is set in the iam-delegated-roles project.
        #
        # The trusted_primary_roles list indicates which roles in identity are allowed
        # to access those roles. So "ops" can access "poweruser", for example.
        delegated_roles_config:
          admin:
            role_policy_arns: ["arn:aws:iam::aws:policy/AdministratorAccess"]
            role_description: "Role with AdministratorAccess permissions"
            sso_login_enabled: true
            # list of roles in primary that can assume into this role in delegated accounts
            # primary admin can assume delegated admin
            trusted_primary_roles: ["admin"]

          ops:
            role_policy_arns: ["arn:aws:iam::aws:policy/PowerUserAccess"]
            role_description: "Role for OPS personnel"
            sso_login_enabled: true
            trusted_primary_roles: ["admin", "ops"]

          poweruser:
            role_policy_arns:
              - "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
              - "delegated_assume_role"
            role_description: "Role for Power Users (read/write)"
            sso_login_enabled: true
            trusted_primary_roles: ["admin", "ops", "poweruser"]

          observer:
            role_policy_arns:
              - "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
              - "delegated_assume_role"
            role_description: "Observer (read-only) role"
            sso_login_enabled: true
            trusted_primary_roles: ["admin", "ops", "observer"]

          terraform:
            role_policy_arns:
              - "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
              - "delegated_assume_role"
            role_description: "Role with permissions for terraform automation"
            sso_login_enabled: false
            # Terraform is too powerful a role to allow powerusers to access it
            trusted_primary_roles: ["admin", "ops", "cicd", "terraform"]

          helm:
            role_policy_arns:
              - "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
              - "delegated_assume_role"
            role_description: "Role with permissions for helm automation"
            sso_login_enabled: false
            # Helm is too powerful a role to allow powerusers to access it
            trusted_primary_roles: ["admin", "ops", "cicd", "helm"]

        # primary_roles_config is for roles that only appear in the identity account.
        # Users or services log in with one of these roles and assume
        # delegated roles in other accounts.
        primary_roles_config:
          cicd:
            role_policy_arns: ["cicd"]
            role_description: "Role for our privileged CI/CD Runner"
            sso_login_enabled: false
            trusted_primary_roles: ["admin", "ops"]
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
| <a name="module_sso"></a> [sso](#module\_sso) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.cicd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.delegated_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.aggregated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.cicd](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.delegated_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.empty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.primary_roles_assume_blacklist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.primary_roles_assume_whitelist](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.saml_provider_assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [terraform_remote_state.account_map](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.sso](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_map_environment_name"></a> [account\_map\_environment\_name](#input\_account\_map\_environment\_name) | The name of the environment where `account_map` is provisioned | `string` | `"gbl"` | no |
| <a name="input_account_map_stage_name"></a> [account\_map\_stage\_name](#input\_account\_map\_stage\_name) | The name of the stage where `account_map` is provisioned | `string` | `"root"` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_assume_role_restricted"></a> [assume\_role\_restricted](#input\_assume\_role\_restricted) | Set true to restrict (via trust policy) who can assume into a role | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_audit_account_stage_name"></a> [audit\_account\_stage\_name](#input\_audit\_account\_stage\_name) | The name of the stage for the audit account | `string` | `"audit"` | no |
| <a name="input_cicd_sa_roles"></a> [cicd\_sa\_roles](#input\_cicd\_sa\_roles) | A list of Role ARNs that cicd runners may start with. Will be allowed to assume xxx-gbl-identity-cicd | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_default_assume_role_enabled"></a> [default\_assume\_role\_enabled](#input\_default\_assume\_role\_enabled) | Set true to allow unknown roles to assume this role (e.g. for AWS SSO) | `bool` | `false` | no |
| <a name="input_delegated_roles_config"></a> [delegated\_roles\_config](#input\_delegated\_roles\_config) | A roles map to configure the accounts. | <pre>map(object({<br>    role_policy_arns      = list(string)<br>    role_description      = string<br>    sso_login_enabled     = bool<br>    trusted_primary_roles = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_iam_role_max_session_duration"></a> [iam\_role\_max\_session\_duration](#input\_iam\_role\_max\_session\_duration) | The maximum session duration (in seconds) that you want to set for the IAM roles.<br>This setting can have a value from 3600 (1 hour) to 43200 (12 hours). | `number` | `43200` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_identity_account_stage_name"></a> [identity\_account\_stage\_name](#input\_identity\_account\_stage\_name) | The name of the stage for the identity account | `string` | `"identity"` | no |
| <a name="input_import_role_arn"></a> [import\_role\_arn](#input\_import\_role\_arn) | IAM Role ARN to use when importing a resource | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_primary_account_id"></a> [primary\_account\_id](#input\_primary\_account\_id) | Primary authentication account id used as the source for assume role | `string` | n/a | yes |
| <a name="input_primary_roles_config"></a> [primary\_roles\_config](#input\_primary\_roles\_config) | A roles map to configure the accounts. | <pre>map(object({<br>    role_policy_arns      = list(string)<br>    role_description      = string<br>    sso_login_enabled     = bool<br>    trusted_primary_roles = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_root_account_stage_name"></a> [root\_account\_stage\_name](#input\_root\_account\_stage\_name) | The name of the stage for the root account | `string` | `"root"` | no |
| <a name="input_spacelift_roles"></a> [spacelift\_roles](#input\_spacelift\_roles) | A list of Spacelift role ARNs. Will be allowed to assume ENV-gbl-identity-ops | `list(string)` | `[]` | no |
| <a name="input_sso_environment_name"></a> [sso\_environment\_name](#input\_sso\_environment\_name) | The name of the environment where SSO is provisioned | `string` | `"gbl"` | no |
| <a name="input_sso_stage_name"></a> [sso\_stage\_name](#input\_sso\_stage\_name) | The name of the stage where SSO is provisioned | `string` | `"identity"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_tfstate_account_id"></a> [tfstate\_account\_id](#input\_tfstate\_account\_id) | The ID of the account where the Terraform remote state backend is provisioned | `string` | `""` | no |
| <a name="input_tfstate_assume_role"></a> [tfstate\_assume\_role](#input\_tfstate\_assume\_role) | Set to false to use the caller's role to access the Terraform remote state | `bool` | `true` | no |
| <a name="input_tfstate_bucket_environment_name"></a> [tfstate\_bucket\_environment\_name](#input\_tfstate\_bucket\_environment\_name) | The name of the environment for Terraform state bucket | `string` | `""` | no |
| <a name="input_tfstate_bucket_stage_name"></a> [tfstate\_bucket\_stage\_name](#input\_tfstate\_bucket\_stage\_name) | The name of the stage for Terraform state bucket | `string` | `"root"` | no |
| <a name="input_tfstate_existing_role_arn"></a> [tfstate\_existing\_role\_arn](#input\_tfstate\_existing\_role\_arn) | The ARN of the existing IAM Role to access the Terraform remote state. If not provided and `remote_state_assume_role` is `true`, a role will be constructed from `remote_state_role_arn_template` | `string` | `""` | no |
| <a name="input_tfstate_role_arn_template"></a> [tfstate\_role\_arn\_template](#input\_tfstate\_role\_arn\_template) | IAM Role ARN template for accessing the Terraform remote state | `string` | `"arn:aws:iam::%s:role/%s-%s-%s-%s"` | no |
| <a name="input_tfstate_role_environment_name"></a> [tfstate\_role\_environment\_name](#input\_tfstate\_role\_environment\_name) | The name of the environment for Terraform state IAM role | `string` | `"gbl"` | no |
| <a name="input_tfstate_role_name"></a> [tfstate\_role\_name](#input\_tfstate\_role\_name) | IAM Role name for accessing the Terraform remote state | `string` | `"terraform"` | no |
| <a name="input_tfstate_role_stage_name"></a> [tfstate\_role\_stage\_name](#input\_tfstate\_role\_stage\_name) | The name of the stage for Terraform state IAM role | `string` | `"root"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_delegated_role_arns"></a> [delegated\_role\_arns](#output\_delegated\_role\_arns) | List of delegated role ARNs |
| <a name="output_delegated_role_name_role_arn_map"></a> [delegated\_role\_name\_role\_arn\_map](#output\_delegated\_role\_name\_role\_arn\_map) | Map of delegated role names to role ARNs |
| <a name="output_delegated_role_names"></a> [delegated\_role\_names](#output\_delegated\_role\_names) | List of delegated role names |
| <a name="output_delegated_roles_config"></a> [delegated\_roles\_config](#output\_delegated\_roles\_config) | Map of delegated role config with name, target arn, and description |
| <a name="output_primary_roles_config"></a> [primary\_roles\_config](#output\_primary\_roles\_config) | Map of role config with name, target arn, and description |
| <a name="output_role_arns"></a> [role\_arns](#output\_role\_arns) | List of role ARNs |
| <a name="output_role_name_role_arn_map"></a> [role\_name\_role\_arn\_map](#output\_role\_name\_role\_arn\_map) | Map of role names to role ARNs |
| <a name="output_role_names"></a> [role\_names](#output\_role\_names) | List of role names |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## References

- [cloudposse/terraform-aws-components](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/iam-primary-roles) - Cloud Posse's upstream component

[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/component)
