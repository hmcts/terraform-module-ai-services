# Unit tests (plan mode + mocks) covering the module's create_* toggles:
# cognitive account, content safety account, ML workspace, compute instances,
# existing resource overrides, and the RBAC role assignments they drive.

mock_provider "azurerm" {
  mock_resource "azurerm_resource_group" {
    defaults = {
      location = "uksouth"
    }
  }

  mock_resource "azurerm_storage_account" {
    defaults = {
      location = "uksouth"
    }
  }

  mock_data "azurerm_subscription" {
    defaults = {
      id              = "/subscriptions/00000000-0000-0000-0000-000000000000"
      subscription_id = "00000000-0000-0000-0000-000000000000"
    }
  }
}

variables {
  env         = "test"
  product     = "example"
  project     = "sds"
  component   = "ai"
  common_tags = { environment = "test" }

  key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.KeyVault/vaults/example-kv"
}

run "test_cognitive_account_created_when_enabled" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_cognitive_account = true
    cognitive_account_kind   = "OpenAI"
  }

  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account) == 1
    error_message = "Cognitive account should be created when create_cognitive_account is true"
  }

  assert {
    condition     = azurerm_cognitive_account.cognitive_account[0].name == "example-cognitive-account-test"
    error_message = "Cognitive account name should follow the product-cognitive-account-env convention"
  }

  assert {
    condition     = azurerm_cognitive_account.cognitive_account[0].kind == "OpenAI"
    error_message = "Cognitive account kind should match the cognitive_account_kind variable"
  }

  assert {
    condition     = azurerm_cognitive_account.cognitive_account[0].sku_name == "F0"
    error_message = "Cognitive account SKU should default to F0"
  }

  assert {
    condition     = azurerm_cognitive_account.cognitive_account[0].local_auth_enabled == true
    error_message = "Cognitive account local auth should default to enabled"
  }

  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account[0].network_acls) == 0
    error_message = "Network ACLs block should be omitted when cognitive_account_network_acls_default_action is null"
  }

  # RBAC: cognitive account should get access to the workspace storage account
  # (created by default) but not to a files storage account (not supplied).
  assert {
    condition     = length(azurerm_role_assignment.cog_blob_contributor_to_ai_storage_account) == 1
    error_message = "Cognitive account should be granted Storage Blob Data Contributor on the workspace storage account"
  }

  assert {
    condition     = length(azurerm_role_assignment.cog_contributor_to_ai_storage_account) == 1
    error_message = "Cognitive account should be granted Contributor on the workspace storage account"
  }

  assert {
    condition     = length(azurerm_role_assignment.cog_blob_contributor_to_file_storage_account) == 0
    error_message = "Cognitive account should not be granted access to a files storage account when none is supplied"
  }
}

run "test_cognitive_account_disabled_by_default" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account) == 0
    error_message = "Cognitive account should not be created when create_cognitive_account is false"
  }

  assert {
    condition     = length(azurerm_role_assignment.cog_blob_contributor_to_ai_storage_account) == 0
    error_message = "No cognitive account role assignments should exist when the account is not created"
  }
}

run "test_cognitive_account_network_acls_and_files_storage" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_cognitive_account                      = true
    cognitive_account_kind                        = "OpenAI"
    cognitive_account_network_acls_default_action = "Deny"
    cognitive_account_local_auth_enabled          = false
    files_storage_account_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/files-rg/providers/Microsoft.Storage/storageAccounts/filessa"
  }

  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account[0].network_acls) == 1
    error_message = "Network ACLs block should be present when cognitive_account_network_acls_default_action is set"
  }

  assert {
    condition     = azurerm_cognitive_account.cognitive_account[0].network_acls[0].default_action == "Deny"
    error_message = "Network ACLs default action should match the variable"
  }

  assert {
    condition     = azurerm_cognitive_account.cognitive_account[0].local_auth_enabled == false
    error_message = "Local auth should be disabled when cognitive_account_local_auth_enabled is false"
  }

  assert {
    condition     = length(azurerm_role_assignment.cog_blob_contributor_to_file_storage_account) == 1
    error_message = "Cognitive account should be granted Storage Blob Data Contributor on the files storage account when supplied"
  }

  assert {
    condition     = length(azurerm_role_assignment.cog_contributor_to_file_storage_account) == 1
    error_message = "Cognitive account should be granted Contributor on the files storage account when supplied"
  }
}

run "test_content_safety_account_created_when_enabled" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_content_safety_account = true
  }

  assert {
    condition     = length(azurerm_cognitive_account.content_safety_account) == 1
    error_message = "Content safety account should be created when create_content_safety_account is true"
  }

  assert {
    condition     = azurerm_cognitive_account.content_safety_account[0].name == "example-content-safety-account-test"
    error_message = "Content safety account name should follow the product-content-safety-account-env convention"
  }

  assert {
    condition     = azurerm_cognitive_account.content_safety_account[0].kind == "ContentSafety"
    error_message = "Content safety account kind should always be ContentSafety"
  }
}

run "test_ml_workspace_and_compute_instances_created" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_ml_workspace                = true
    application_insights_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Insights/components/example-ai"
    instances                          = 2
    compute_instance_public_ip_enabled = false
    subnet_id                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
  }

  assert {
    condition     = length(azurerm_machine_learning_workspace.ml_workspace) == 1
    error_message = "ML workspace should be created when create_ml_workspace is true"
  }

  assert {
    condition     = azurerm_machine_learning_workspace.ml_workspace[0].name == "example-ml-workspace-test"
    error_message = "ML workspace name should follow the product-ml-workspace-env convention"
  }

  assert {
    condition     = length(azurerm_machine_learning_compute_instance.compute_instance) == 2
    error_message = "Two compute instances should be created when instances is set to 2"
  }

  assert {
    condition     = azurerm_machine_learning_compute_instance.compute_instance[0].name == "example-ci-test1"
    error_message = "First compute instance name should follow the product-ci-env-index convention"
  }

  assert {
    condition     = azurerm_machine_learning_compute_instance.compute_instance[0].virtual_machine_size == "Standard_D2ds_v5"
    error_message = "Compute instance VM size should default to Standard_D2ds_v5"
  }

  assert {
    condition     = azurerm_machine_learning_compute_instance.compute_instance[0].subnet_resource_id == var.subnet_id
    error_message = "Compute instance should use the supplied subnet when public IP is disabled"
  }

  assert {
    condition     = length(azurerm_role_assignment.ml_blob_contributor_to_ai_storage_account) == 1
    error_message = "ML workspace should be granted Storage Blob Data Contributor on the workspace storage account"
  }

  assert {
    condition     = length(azurerm_role_assignment.compute_blob_contributor_to_ai_storage_account) == 2
    error_message = "Each compute instance should be granted Storage Blob Data Contributor on the workspace storage account"
  }
}

run "test_existing_resource_group_and_storage_account_used" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    existing_resource_group_name = "existing-rg"
    existing_storage_account_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/existing-rg/providers/Microsoft.Storage/storageAccounts/existingsa"
  }

  assert {
    condition     = length(azurerm_resource_group.rg) == 0
    error_message = "No resource group should be created when existing_resource_group_name is supplied"
  }

  assert {
    condition     = length(azurerm_storage_account.workspace_storage_account) == 0
    error_message = "No storage account should be created when existing_storage_account_id is supplied"
  }

  assert {
    condition     = azurerm_ai_foundry.ai_foundry[0].resource_group_name == "existing-rg"
    error_message = "AI Foundry should be deployed into the existing resource group"
  }

  assert {
    condition     = azurerm_ai_foundry.ai_foundry[0].storage_account_id == var.existing_storage_account_id
    error_message = "AI Foundry should use the existing storage account id"
  }
}

run "test_create_storage_account_false_without_existing_id" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_ai_foundry      = false
    create_storage_account = false
  }

  assert {
    condition     = length(azurerm_storage_account.workspace_storage_account) == 0
    error_message = "Storage account should not be created when create_storage_account is false"
  }

  assert {
    condition     = length(azurerm_ai_foundry.ai_foundry) == 0
    error_message = "AI Foundry should not be created when create_ai_foundry is false"
  }

  assert {
    condition     = length(azurerm_ai_foundry_project.ai_foundry_project) == 0
    error_message = "AI Foundry project should not be created when create_ai_foundry is false"
  }
}

run "test_cognitive_deployments_created" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_cognitive_account = true
    cognitive_account_kind   = "OpenAI"
    cognitive_deployments = {
      "gpt-5-mini" = {
        model_name    = "gpt-5-mini"
        model_version = "2025-08-07"
        sku_name      = "GlobalStandard"
        sku_capacity  = 10
      }
    }
  }

  assert {
    condition     = length(azurerm_cognitive_deployment.cognitive_deployment) == 1
    error_message = "One cognitive deployment should be created per entry in cognitive_deployments"
  }

  assert {
    condition     = azurerm_cognitive_deployment.cognitive_deployment["gpt-5-mini"].model[0].name == "gpt-5-mini"
    error_message = "Cognitive deployment model name should match the configured value"
  }

  assert {
    condition     = azurerm_cognitive_deployment.cognitive_deployment["gpt-5-mini"].sku[0].capacity == 10
    error_message = "Cognitive deployment SKU capacity should match the configured value"
  }
}

run "test_cognitive_deployment_defaults" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_cognitive_account = true
    cognitive_account_kind   = "OpenAI"
    cognitive_deployments = {
      "default-deployment" = {}
    }
  }

  assert {
    condition     = azurerm_cognitive_deployment.cognitive_deployment["default-deployment"].model[0].name == "gpt-5-mini"
    error_message = "Cognitive deployment model name should default to gpt-5-mini"
  }

  assert {
    condition     = azurerm_cognitive_deployment.cognitive_deployment["default-deployment"].model[0].format == "OpenAI"
    error_message = "Cognitive deployment model format should default to OpenAI"
  }

  assert {
    condition     = azurerm_cognitive_deployment.cognitive_deployment["default-deployment"].sku[0].name == "GlobalStandard"
    error_message = "Cognitive deployment SKU name should default to GlobalStandard"
  }

  assert {
    condition     = azurerm_cognitive_deployment.cognitive_deployment["default-deployment"].sku[0].capacity == 1
    error_message = "Cognitive deployment SKU capacity should default to 1"
  }
}
