# Unit tests (plan mode + mocks) covering the module's default configuration:
# resource group creation, naming conventions, AI Foundry hub/project, and
# workspace storage account defaults.

mock_provider "azurerm" {
  mock_resource "azurerm_resource_group" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-ai-type-test"
      location = "uksouth"
    }
  }

  mock_resource "azurerm_storage_account" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-ai-type-test/providers/Microsoft.Storage/storageAccounts/exampleaisatest"
      location = "uksouth"
    }
  }

  mock_resource "azurerm_ai_foundry" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-ai-type-test/providers/Microsoft.MachineLearningServices/workspaces/example-ai-foundry-test"
      location = "uksouth"
      identity = [{
        type         = "SystemAssigned"
        principal_id = "11111111-1111-1111-1111-111111111111"
        tenant_id    = "22222222-2222-2222-2222-222222222222"
      }]
    }
  }

  mock_resource "azurerm_ai_foundry_project" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-ai-type-test/providers/Microsoft.MachineLearningServices/workspaces/example-ai-foundry-test/projects/example-project-test"
      location = "uksouth"
      identity = [{
        type         = "SystemAssigned"
        principal_id = "33333333-3333-3333-3333-333333333333"
        tenant_id    = "22222222-2222-2222-2222-222222222222"
      }]
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

run "test_default_resource_group_created" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  assert {
    condition     = length(azurerm_resource_group.rg) == 1
    error_message = "A resource group should be created when existing_resource_group_name is not set"
  }

  assert {
    condition     = azurerm_resource_group.rg[0].name == "example-ai-type-test"
    error_message = "Resource group name should follow the product-component-type-env convention"
  }

  assert {
    condition     = azurerm_resource_group.rg[0].location == "UK South"
    error_message = "Resource group should default to UK South"
  }
}

run "test_default_ai_foundry_created" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  assert {
    condition     = length(azurerm_ai_foundry.ai_foundry) == 1
    error_message = "AI Foundry hub should be created by default (create_ai_foundry defaults to true)"
  }

  assert {
    condition     = azurerm_ai_foundry.ai_foundry[0].name == "example-ai-foundry-test"
    error_message = "AI Foundry hub name should follow the product-ai-foundry-env convention"
  }

  assert {
    condition     = azurerm_ai_foundry.ai_foundry[0].public_network_access == "Enabled"
    error_message = "AI Foundry public network access should default to Enabled"
  }

  assert {
    condition     = length(azurerm_ai_foundry.ai_foundry[0].managed_network) == 0
    error_message = "Managed network block should be omitted when enable_managed_network is false"
  }

  assert {
    condition     = length(azurerm_ai_foundry_project.ai_foundry_project) == 1
    error_message = "AI Foundry project should be created alongside the hub"
  }

  assert {
    condition     = azurerm_ai_foundry_project.ai_foundry_project[0].name == "example-project-test"
    error_message = "AI Foundry project name should follow the product-project-env convention"
  }
}

run "test_default_workspace_storage_account_created" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  assert {
    condition     = length(azurerm_storage_account.workspace_storage_account) == 1
    error_message = "Workspace storage account should be created by default"
  }

  assert {
    condition     = azurerm_storage_account.workspace_storage_account[0].name == "exampleaisatest"
    error_message = "Storage account name should follow the product+component+sa+env convention with hyphens stripped"
  }

  assert {
    condition     = azurerm_storage_account.workspace_storage_account[0].account_tier == "Standard"
    error_message = "Storage account tier should default to Standard"
  }

  assert {
    condition     = azurerm_storage_account.workspace_storage_account[0].account_replication_type == "ZRS"
    error_message = "Storage account replication type should default to ZRS"
  }

  assert {
    condition     = azurerm_storage_account.workspace_storage_account[0].allow_nested_items_to_be_public == false
    error_message = "Storage account should not allow public nested items"
  }
}

run "test_no_cognitive_or_ml_resources_by_default" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  assert {
    condition     = length(azurerm_cognitive_account.cognitive_account) == 0
    error_message = "Cognitive account should not be created by default (create_cognitive_account defaults to false)"
  }

  assert {
    condition     = length(azurerm_cognitive_account.content_safety_account) == 0
    error_message = "Content safety account should not be created by default"
  }

  assert {
    condition     = length(azurerm_machine_learning_workspace.ml_workspace) == 0
    error_message = "ML workspace should not be created by default (create_ml_workspace defaults to false)"
  }

  assert {
    condition     = length(azurerm_machine_learning_compute_instance.compute_instance) == 0
    error_message = "No compute instances should be created by default (instances defaults to 0)"
  }
}
