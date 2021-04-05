# Component: `eks`

This component is responsible for provisioning an end-to-end EKS Cluster, including managed node groups and [spotinst ocean](https://spot.io/products/ocean/) node pools.

## Usage

**Stack Level**: Regional

Here's an example snippet for how to use this component.

```yaml
components:
  terraform:
    eks:
      vars:
        cluster_kubernetes_version: "1.19"
        region_availability_zones: ["us-east-1b", "us-east-1c", "us-east-1d"]
        spotinst_instance_profile: example-gbl-dev-spotinst-worker
        map_additional_worker_roles: ["arn:aws:iam::xxxxxxxxxx:role/example-ue1-dev-spotinst-worker"]
        public_access_cidrs: ["72.107.0.0/24"]
        spotinst_oceans:
          main: &standard_node_group
            desired_group_size: 1
            max_group_size: 10
            min_group_size: 1

            # Can only set one of ami_release_version or kubernetes_version
            # Leave both null to use latest AMI for Cluster Kubernetes version
            kubernetes_version: null   # use cluster Kubernetes version
            ami_release_version: null  # use latest AMI for Kubernetes version

            attributes: null
            disk_size: 100
            instance_types: null
            ami_type: null # use "AL2_x86_64" for standard instances, "AL2_x86_64_GPU" for GPU instances
            tags: null
```

### Instance types
When provisioning a pool of instances, usually it is not especially important exactly which kind you get. When paying spot prices, you can save a lot of money by being flexible about which ones you use, so if for some reason r5a.large is cheaper than r5.large you can get the r5a.large. To help you select which instances to use, Geodesic includes the [`ec2-instance-selector` tool](https://github.com/aws/amazon-ec2-instance-selector). See the documentation for details, but for example:
```text
 ⧉  Geodesic
 √ . [example-gbl-identity] components ⨠ ec2-instance-selector --gpus 0 --vcpus-min 2 --vcpus-max 4 -a amd64 --flexible --memory-min 16 -u spot
m4.xlarge
m5.xlarge
m5a.xlarge
r3.xlarge
r4.xlarge
r5.large
r5.xlarge
r5a.large
r5a.xlarge
t2.xlarge
t3.xlarge

```

You can plug that list into `instance_types` in the stack configuration. Keep in mind that the list may vary slightly from region to region, so be sure to run the command in the region the EKS cluster will be running.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.3 |
| <a name="requirement_spotinst"></a> [spotinst](#requirement\_spotinst) | >= 1.30 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |
| <a name="provider_aws.spotinst_secrets"></a> [aws.spotinst\_secrets](#provider\_aws.spotinst\_secrets) | >= 3.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_delegated_roles"></a> [delegated\_roles](#module\_delegated\_roles) | cloudposse/stack-config/yaml//modules/remote-state | 0.10.0 |
| <a name="module_eks"></a> [eks](#module\_eks) | cloudposse/stack-config/yaml//modules/remote-state | 0.10.0 |
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | cloudposse/eks-cluster/aws | 0.34.1 |
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../account-map/modules/iam-roles |  |
| <a name="module_primary_roles"></a> [primary\_roles](#module\_primary\_roles) | cloudposse/stack-config/yaml//modules/remote-state | 0.10.0 |
| <a name="module_region_node_group"></a> [region\_node\_group](#module\_region\_node\_group) | ./modules/node_group_by_region |  |
| <a name="module_spotinst_oceans"></a> [spotinst\_oceans](#module\_spotinst\_oceans) | cloudposse/eks-spotinst-ocean-nodepool/aws | 0.1.1 |
| <a name="module_spotinst_role"></a> [spotinst\_role](#module\_spotinst\_role) | cloudposse/stack-config/yaml//modules/remote-state | 0.10.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | cloudposse/stack-config/yaml//modules/remote-state | 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_arn.roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_iam_instance_profile.spotinst_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_ssm_parameter.spotinst_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.spotinst_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [terraform_remote_state.delegated_roles](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.eks](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.primary_roles](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks to be allowed to connect to the EKS cluster | `list(string)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | List of Security Group IDs to be allowed to connect to the EKS cluster | `list(string)` | `[]` | no |
| <a name="input_apply_config_map_aws_auth"></a> [apply\_config\_map\_aws\_auth](#input\_apply\_config\_map\_aws\_auth) | Whether to execute `kubectl apply` to apply the ConfigMap to allow worker nodes to join the EKS cluster | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_aws_ssm_enabled"></a> [aws\_ssm\_enabled](#input\_aws\_ssm\_enabled) | Set true to install the AWS SSM agent on each EC2 instance | `bool` | `false` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is `false` | `bool` | `false` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is `true` | `bool` | `true` | no |
| <a name="input_cluster_kubernetes_version"></a> [cluster\_kubernetes\_version](#input\_cluster\_kubernetes\_version) | Desired Kubernetes master version. If you do not specify a value, the latest available version is used | `string` | `null` | no |
| <a name="input_cluster_log_retention_period"></a> [cluster\_log\_retention\_period](#input\_cluster\_log\_retention\_period) | Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. | `number` | `0` | no |
| <a name="input_color"></a> [color](#input\_color) | The cluster stage represented by a color; e.g. blue, green | `string` | `""` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delegated_iam_roles"></a> [delegated\_iam\_roles](#input\_delegated\_iam\_roles) | Delegated IAM roles to add to `aws-auth` ConfigMap | <pre>list(object({<br>    role   = string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enable_vpn_access"></a> [enable\_vpn\_access](#input\_enable\_vpn\_access) | Enable VPN access via the HAL VPN; see vpn project | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`] | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_iam_primary_roles_stage_name"></a> [iam\_primary\_roles\_stage\_name](#input\_iam\_primary\_roles\_stage\_name) | The name of the stage where the IAM primary roles are provisioned | `string` | `"identity"` | no |
| <a name="input_iam_roles_environment_name"></a> [iam\_roles\_environment\_name](#input\_iam\_roles\_environment\_name) | The name of the environment where the IAM roles are provisioned | `string` | `"gbl"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_role_arn"></a> [import\_role\_arn](#input\_import\_role\_arn) | IAM Role ARN to use when importing a resource | `string` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_map_additional_aws_accounts"></a> [map\_additional\_aws\_accounts](#input\_map\_additional\_aws\_accounts) | Additional AWS account numbers to add to `aws-auth` ConfigMap | `list(string)` | `[]` | no |
| <a name="input_map_additional_iam_users"></a> [map\_additional\_iam\_users](#input\_map\_additional\_iam\_users) | Additional IAM users to add to `aws-auth` ConfigMap | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_additional_worker_roles"></a> [map\_additional\_worker\_roles](#input\_map\_additional\_worker\_roles) | AWS IAM Role ARNs of worker nodes to add to `aws-auth` ConfigMap | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_node_group_defaults"></a> [node\_group\_defaults](#input\_node\_group\_defaults) | Defaults for node groups in the cluster | <pre>object({<br>    availability_zones         = list(string) # set to null to use var.region_availability_zones<br>    attributes                 = list(string)<br>    create_before_destroy      = bool<br>    desired_group_size         = number<br>    disk_size                  = number<br>    cluster_autoscaler_enabled = bool<br>    instance_types             = list(string)<br>    ami_type                   = string<br>    ami_release_version        = string<br>    kubernetes_version         = string # set to null to use cluster_kubernetes_version<br>    kubernetes_labels          = map(string)<br>    kubernetes_taints          = map(string)<br>    max_group_size             = number<br>    min_group_size             = number<br>    resources_to_tag           = list(string)<br>    tags                       = map(string)<br>  })</pre> | <pre>{<br>  "ami_release_version": null,<br>  "ami_type": null,<br>  "attributes": null,<br>  "availability_zones": null,<br>  "cluster_autoscaler_enabled": true,<br>  "create_before_destroy": true,<br>  "desired_group_size": 1,<br>  "disk_size": 20,<br>  "instance_types": [<br>    "t3.medium"<br>  ],<br>  "kubernetes_labels": null,<br>  "kubernetes_taints": null,<br>  "kubernetes_version": null,<br>  "max_group_size": 100,<br>  "min_group_size": null,<br>  "resources_to_tag": null,<br>  "tags": null<br>}</pre> | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | List of objects defining a node group for the cluster | <pre>map(object({<br>    # will create 1 auto scaling group in each specified availability zone<br>    availability_zones = list(string)<br>    # Additional attributes (e.g. `1`) for the node group<br>    attributes = list(string)<br>    # True to create new node_groups before deleting old ones, avoiding a temporary outage<br>    create_before_destroy = bool<br>    # Desired number of worker nodes when initially provisioned<br>    desired_group_size = number<br>    # Disk size in GiB for worker nodes. Terraform will only perform drift detection if a configuration value is provided.<br>    disk_size = number<br>    # Whether to enable Node Group to scale its AutoScaling Group<br>    cluster_autoscaler_enabled = bool<br>    # Set of instance types associated with the EKS Node Group. Terraform will only perform drift detection if a configuration value is provided.<br>    instance_types = list(string)<br>    # Type of Amazon Machine Image (AMI) associated with the EKS Node Group<br>    ami_type = string<br>    # EKS AMI version to use, e.g. "1.16.13-20200821" (no "v").<br>    ami_release_version = string<br>    # Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed<br>    kubernetes_labels = map(string)<br>    # Key-value mapping of Kubernetes taints.<br>    kubernetes_taints = map(string)<br>    # Desired Kubernetes master version. If you do not specify a value, the latest available version is used<br>    kubernetes_version = string<br>    # The maximum size of the AutoScaling Group<br>    max_group_size = number<br>    # The minimum size of the AutoScaling Group<br>    min_group_size = number<br>    # List of auto-launched resource types to tag<br>    resources_to_tag = list(string)<br>    tags             = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_oidc_provider_enabled"></a> [oidc\_provider\_enabled](#input\_oidc\_provider\_enabled) | Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html | `bool` | n/a | yes |
| <a name="input_primary_iam_roles"></a> [primary\_iam\_roles](#input\_primary\_iam\_roles) | Primary IAM roles to add to `aws-auth` ConfigMap | <pre>list(object({<br>    role   = string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_region_availability_zones"></a> [region\_availability\_zones](#input\_region\_availability\_zones) | AWS Availability Zones in which to deploy multi-AZ resources | `list(string)` | n/a | yes |
| <a name="input_spotinst_account_ssm_key"></a> [spotinst\_account\_ssm\_key](#input\_spotinst\_account\_ssm\_key) | SSM key for Spot account ID | `string` | `"/spotinst/spotinst_account"` | no |
| <a name="input_spotinst_instance_profile_pattern"></a> [spotinst\_instance\_profile\_pattern](#input\_spotinst\_instance\_profile\_pattern) | Pattern for the name of the AWS Instance Profile to use for Spotinst Worker instances:<br>`format(spotinst_instance_profile_pattern, var.namespace, var.environment, var.stage)`<br>If empty or null, a new instance profile will be created. | `string` | `"%v-gbl-%[3]v-spotinst-worker"` | no |
| <a name="input_spotinst_ocean_defaults"></a> [spotinst\_ocean\_defaults](#input\_spotinst\_ocean\_defaults) | Defaults for node groups in the cluster | <pre>object({<br>    attributes          = list(string)<br>    desired_group_size  = number<br>    disk_size           = number<br>    instance_types      = list(string)<br>    ami_type            = string<br>    ami_release_version = string<br>    kubernetes_version  = string # set to null to use cluster_kubernetes_version<br>    max_group_size      = number<br>    min_group_size      = number<br>    tags                = map(string)<br>  })</pre> | <pre>{<br>  "ami_release_version": null,<br>  "ami_type": "AL2_x86_64",<br>  "attributes": [],<br>  "desired_group_size": 1,<br>  "disk_size": 20,<br>  "instance_types": null,<br>  "kubernetes_version": null,<br>  "max_group_size": 100,<br>  "min_group_size": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_spotinst_oceans"></a> [spotinst\_oceans](#input\_spotinst\_oceans) | List of objects defining a Spotinst Ocean for the cluster | <pre>map(object({<br>    # Additional attributes (e.g. `1`) for the ocean<br>    attributes         = list(string)<br>    desired_group_size = number<br>    # Disk size in GiB for worker nodes. Terraform will only perform drift detection if a configuration value is provided.<br>    disk_size = number<br>    # List of allowed instance types. Leave null to allow Spot to choose any type.<br>    instance_types = list(string)<br>    # Type of Amazon Machine Image (AMI) associated with the EKS Node Group<br>    ami_type = string<br>    # EKS AMI version to use, e.g. "1.16.13-20200821" (no "v").<br>    ami_release_version = string<br>    # Desired Kubernetes master version. If you do not specify a value, the cluster version is used<br>    kubernetes_version = string # set to null to use cluster_kubernetes_version<br>    max_group_size     = number<br>    min_group_size     = number<br>    tags               = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_spotinst_secrets_region"></a> [spotinst\_secrets\_region](#input\_spotinst\_secrets\_region) | The region to retrieve the spotinst secrets from | `string` | `"us-west-2"` | no |
| <a name="input_spotinst_token_ssm_key"></a> [spotinst\_token\_ssm\_key](#input\_spotinst\_token\_ssm\_key) | SSM key for Spot Personal Access token | `string` | `"/spotinst/spotinst_token"` | no |
| <a name="input_ssm_installer"></a> [ssm\_installer](#input\_ssm\_installer) | Command to install AWS SSM agent on EC2 instance | `string` | `"yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpmn"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_subnet_type_tag_key"></a> [subnet\_type\_tag\_key](#input\_subnet\_type\_tag\_key) | The tag used to find the private subnets to find by availability zone. If null, will be looked up in vpc outputs. | `string` | `null` | no |
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
| <a name="input_update_policy_batch_size_percentage"></a> [update\_policy\_batch\_size\_percentage](#input\_update\_policy\_batch\_size\_percentage) | When rolling the cluster due to an update, the percentage of the instances to deploy in each batch. | `number` | `25` | no |
| <a name="input_update_policy_should_roll"></a> [update\_policy\_should\_roll](#input\_update\_policy\_should\_roll) | If true, roll the cluster when its configuration is updated | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_auth_worker_roles"></a> [eks\_auth\_worker\_roles](#output\_eks\_auth\_worker\_roles) | List of worker IAM roles that were included in the `auth-map` ConfigMap. |
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | The endpoint for the Kubernetes API server |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The name of the cluster |
| <a name="output_eks_cluster_identity_oidc_issuer"></a> [eks\_cluster\_identity\_oidc\_issuer](#output\_eks\_cluster\_identity\_oidc\_issuer) | The OIDC Identity issuer for the cluster |
| <a name="output_eks_cluster_managed_security_group_id"></a> [eks\_cluster\_managed\_security\_group\_id](#output\_eks\_cluster\_managed\_security\_group\_id) | Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads |
| <a name="output_eks_cluster_version"></a> [eks\_cluster\_version](#output\_eks\_cluster\_version) | The Kubernetes server version of the cluster |
| <a name="output_eks_managed_node_workers_role_arns"></a> [eks\_managed\_node\_workers\_role\_arns](#output\_eks\_managed\_node\_workers\_role\_arns) | List of ARNs for workers in managed node groups |
| <a name="output_eks_node_group_arns"></a> [eks\_node\_group\_arns](#output\_eks\_node\_group\_arns) | ARN of the worker nodes IAM role |
| <a name="output_eks_node_group_count"></a> [eks\_node\_group\_count](#output\_eks\_node\_group\_count) | Count of the worker nodes |
| <a name="output_eks_node_group_ids"></a> [eks\_node\_group\_ids](#output\_eks\_node\_group\_ids) | EKS Cluster name and EKS Node Group name separated by a colon |
| <a name="output_eks_node_group_role_names"></a> [eks\_node\_group\_role\_names](#output\_eks\_node\_group\_role\_names) | Name of the worker nodes IAM role |
| <a name="output_eks_spotinst_ocean_controller_ids"></a> [eks\_spotinst\_ocean\_controller\_ids](#output\_eks\_spotinst\_ocean\_controller\_ids) | The ID of the Ocean controller |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## References
* [cloudposse/terraform-aws-components](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/eks) - Cloud Posse's upstream component


[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/component)
