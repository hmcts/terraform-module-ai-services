# Unit tests (plan mode + mocks) covering module outputs across the
# create_ai_foundry / create_storage_account / existing_storage_account_id
# combinations.

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

run "test_ai_storage_account_id_output_uses_created_storage_account" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  assert {
    condition     = azurerm_storage_account.workspace_storage_account[0].name == "exampleaisatest"
    error_message = "Storage account should be created by default and drive the ai_storage_account_id output"
  }
}

run "test_ai_storage_account_id_output_uses_existing_storage_account" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    existing_storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/existing-rg/providers/Microsoft.Storage/storageAccounts/existingsa"
  }

  assert {
    condition     = output.ai_storage_account_id == var.existing_storage_account_id
    error_message = "ai_storage_account_id output should resolve to the existing storage account id when supplied"
  }
}

run "test_cognitive_account_id_output_null_when_not_created" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  assert {
    condition     = output.cognitive_account_id == null
    error_message = "cognitive_account_id output should be null when create_cognitive_account is false"
  }

  assert {
    condition     = output.content_safety_account_id == null
    error_message = "content_safety_account_id output should be null when create_content_safety_account is false"
  }
}

run "test_cognitive_account_id_output_set_when_created" {
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
    error_message = "Cognitive account should be created when create_cognitive_account is true, driving a non-null cognitive_account_id output"
  }
}

run "test_compute_instance_identity_output_keyed_by_name" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_ml_workspace     = true
    application_insights_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Insights/components/example-ai"
    instances               = 1
  }

  assert {
    condition     = contains(keys(output.compute_instance_identity), "example-ci-test1")
    error_message = "compute_instance_identity output should be keyed by the compute instance name"
  }
}
