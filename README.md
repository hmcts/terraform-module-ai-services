# terraform-module-ai-services

Terraform module to create Azure AI resources

## Example

```hcl
module "ai" {
  source = "git@github.com:hmcts/terraform-module-ai-services?ref=main"
  ...
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.24.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_ai_foundry.ai_foundry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_foundry) | resource |
<<<<<<< HEAD
| [azurerm_ai_services.ai_services](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_services) | resource |
| [azurerm_machine_learning_workspace.ml_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_workspace) | resource |
=======
| [azurerm_ai_foundry_project.ai_foundry_project](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ai_foundry_project) | resource |
| [azurerm_cognitive_account.cognitive_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account) | resource |
| [azurerm_machine_learning_compute_instance.compute_instance](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_compute_instance) | resource |
| [azurerm_machine_learning_workspace.ml_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/machine_learning_workspace) | resource |
| [azurerm_private_endpoint.cognitive_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.foundry_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.ml_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
>>>>>>> main
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.cog_blob_contributor_to_ai_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cog_blob_contributor_to_file_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cog_contributor_to_ai_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cog_contributor_to_file_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.compute_blob_contributor_to_ai_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.compute_blob_contributor_to_file_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.compute_contributor_to_ai_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.compute_contributor_to_file_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.ml_blob_contributor_to_ai_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.ml_blob_contributor_to_file_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.ml_contributor_from_to_ai_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.ml_contributor_to_file_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.workspace_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
<<<<<<< HEAD
| <a name="input_application_insights_id"></a> [application\_insights\_id](#input\_application\_insights\_id) | ID of existing application insights | `string` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | https://hmcts.github.io/glossary/#component | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
=======
| <a name="input_ai_project_name_override"></a> [ai\_project\_name\_override](#input\_ai\_project\_name\_override) | value to override the project name | `string` | `null` | no |
| <a name="input_application_insights_id"></a> [application\_insights\_id](#input\_application\_insights\_id) | ID of existing application insights | `string` | n/a | yes |
| <a name="input_cognitive_account_kind"></a> [cognitive\_account\_kind](#input\_cognitive\_account\_kind) | Kind of cognitive account | `string` | n/a | yes |
| <a name="input_cognitive_account_sku"></a> [cognitive\_account\_sku](#input\_cognitive\_account\_sku) | SKU of cognitive account | `string` | `"F0"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | https://hmcts.github.io/glossary/#component | `string` | n/a | yes |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | (Optional) Network rules default action | `string` | `"Allow"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_cognitive_account_name"></a> [existing\_cognitive\_account\_name](#input\_existing\_cognitive\_account\_name) | Name of existing cognitive account to use | `string` | `null` | no |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_files_storage_account_id"></a> [files\_storage\_account\_id](#input\_files\_storage\_account\_id) | ID of existing storage account where files to be processed are stored | `string` | `null` | no |
| <a name="input_instances"></a> [instances](#input\_instances) | The number of compute instances to deploy | `number` | `0` | no |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | IP rules for the resources | `list` | `[]` | no |
>>>>>>> main
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | ID of existing key vault | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_max_node_count"></a> [max\_node\_count](#input\_max\_node\_count) | Maximum number of nodes in the compute cluster | `number` | `1` | no |
| <a name="input_min_node_count"></a> [min\_node\_count](#input\_min\_node\_count) | Minimum number of nodes in the compute cluster | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be product+component+env, you can override the product+component part by setting this | `string` | `""` | no |
| <a name="input_product"></a> [product](#input\_product) | https://hmcts.github.io/glossary/#product | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Project name - sds or cft. | `any` | n/a | yes |
<<<<<<< HEAD
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | ID of existing storage account | `string` | n/a | yes |
=======
| <a name="input_public_network_access_cognitive"></a> [public\_network\_access\_cognitive](#input\_public\_network\_access\_cognitive) | Public network access for cognitive account | `bool` | `true` | no |
| <a name="input_public_network_access_foundry"></a> [public\_network\_access\_foundry](#input\_public\_network\_access\_foundry) | Public network access for the resource | `string` | `"Enabled"` | no |
| <a name="input_public_network_access_ml"></a> [public\_network\_access\_ml](#input\_public\_network\_access\_ml) | Public network access for ML workspace | `bool` | `true` | no |
| <a name="input_sa_subnets"></a> [sa\_subnets](#input\_sa\_subnets) | (Optional) List of subnet ID's which will have access to this storage account. | `list(string)` | `[]` | no |
| <a name="input_scaledown_idle_duration"></a> [scaledown\_idle\_duration](#input\_scaledown\_idle\_duration) | Duration to scale down the compute cluster after idle | `string` | `"PT30S"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of existing subnet for the private endpoint | `string` | n/a | yes |
| <a name="input_vm_priority"></a> [vm\_priority](#input\_vm\_priority) | Priority of the VM for the compute cluster | `string` | `"LowPriority"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Size of the VM for the compute cluster | `string` | `"Standard_D2ds_v5"` | no |
| <a name="input_workspace_storage_account_replication_type"></a> [workspace\_storage\_account\_replication\_type](#input\_workspace\_storage\_account\_replication\_type) | Replication type of the workspace storage account | `string` | `"ZRS"` | no |
| <a name="input_workspace_storage_account_tier"></a> [workspace\_storage\_account\_tier](#input\_workspace\_storage\_account\_tier) | Tier of the workspace storage account | `string` | `"Standard"` | no |
>>>>>>> main

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ai_foundry_identity"></a> [ai\_foundry\_identity](#output\_ai\_foundry\_identity) | n/a |
| <a name="output_ai_storage_account_id"></a> [ai\_storage\_account\_id](#output\_ai\_storage\_account\_id) | n/a |
| <a name="output_cognitive_account_identity"></a> [cognitive\_account\_identity](#output\_cognitive\_account\_identity) | n/a |
| <a name="output_cognitive_account_primary_access_key"></a> [cognitive\_account\_primary\_access\_key](#output\_cognitive\_account\_primary\_access\_key) | n/a |
| <a name="output_cognitive_account_secondary_access_key"></a> [cognitive\_account\_secondary\_access\_key](#output\_cognitive\_account\_secondary\_access\_key) | n/a |
| <a name="output_compute_instance_identity"></a> [compute\_instance\_identity](#output\_compute\_instance\_identity) | n/a |
| <a name="output_ml_workspace_identity"></a> [ml\_workspace\_identity](#output\_ml\_workspace\_identity) | n/a |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
