# Unit tests (plan mode + mocks) covering private endpoints, managed network
# isolation, and private DNS zone ID resolution logic.

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

  mock_data "azurerm_private_dns_zone" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/mocked.zone"
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
  subnet_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
}

run "test_no_private_endpoints_when_managed_network_disabled" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    create_cognitive_account      = true
    cognitive_account_kind        = "OpenAI"
    create_content_safety_account = true
    create_ml_workspace           = true
    application_insights_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Insights/components/example-ai"
  }

  assert {
    condition     = length(azurerm_private_endpoint.foundry_private_endpoint) == 0
    error_message = "AI Foundry private endpoint should not be created when enable_managed_network is false"
  }

  assert {
    condition     = length(azurerm_private_endpoint.cognitive_private_endpoint) == 0
    error_message = "Cognitive account private endpoint should not be created when enable_managed_network is false"
  }

  assert {
    condition     = length(azurerm_private_endpoint.content_safety_private_endpoint) == 0
    error_message = "Content safety private endpoint should not be created when enable_managed_network is false"
  }

  assert {
    condition     = length(azurerm_private_endpoint.ml_private_endpoint) == 0
    error_message = "ML workspace private endpoint should not be created when enable_managed_network is false"
  }
}

run "test_private_endpoints_created_when_managed_network_enabled" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    enable_managed_network        = true
    create_cognitive_account      = true
    cognitive_account_kind        = "OpenAI"
    create_content_safety_account = true
    create_ml_workspace           = true
    application_insights_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Insights/components/example-ai"
  }

  assert {
    condition     = length(azurerm_private_endpoint.foundry_private_endpoint) == 1
    error_message = "AI Foundry private endpoint should be created when enable_managed_network is true and create_ai_foundry is true"
  }

  assert {
    condition     = azurerm_private_endpoint.foundry_private_endpoint[0].subnet_id == var.subnet_id
    error_message = "AI Foundry private endpoint should use the supplied subnet"
  }

  assert {
    condition     = length(azurerm_private_endpoint.cognitive_private_endpoint) == 1
    error_message = "Cognitive account private endpoint should be created when enable_managed_network and create_cognitive_account are true"
  }

  assert {
    condition     = length(azurerm_private_endpoint.content_safety_private_endpoint) == 1
    error_message = "Content safety private endpoint should be created when enable_managed_network and create_content_safety_account are true"
  }

  assert {
    condition     = length(azurerm_private_endpoint.ml_private_endpoint) == 1
    error_message = "ML workspace private endpoint should be created when enable_managed_network and create_ml_workspace are true"
  }
}

run "test_managed_network_isolation_mode_applied_to_foundry" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    enable_managed_network         = true
    managed_network_isolation_mode = "AllowOnlyApprovedOutbound"
  }

  assert {
    condition     = azurerm_ai_foundry.ai_foundry[0].managed_network[0].isolation_mode == "AllowOnlyApprovedOutbound"
    error_message = "AI Foundry managed network isolation mode should match the configured variable"
  }
}

run "test_central_dns_zones_looked_up_by_default" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    enable_managed_network   = true
    create_cognitive_account = true
    cognitive_account_kind   = "OpenAI"
  }

  assert {
    condition     = length(data.azurerm_private_dns_zone.api_azureml) == 1
    error_message = "The central api.azureml private DNS zone should be looked up when foundry_private_dns_zone_ids is null"
  }

  assert {
    condition     = length(data.azurerm_private_dns_zone.cognitiveservices) == 1
    error_message = "The central cognitiveservices private DNS zone should be looked up when cognitive_private_dns_zone_ids is null"
  }

  assert {
    condition     = length(azurerm_private_endpoint.foundry_private_endpoint[0].private_dns_zone_group) == 1
    error_message = "The DNS zone group should be present on the AI Foundry private endpoint when zone IDs are resolved"
  }
}

run "test_explicit_dns_zone_ids_skip_lookup" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    enable_managed_network       = true
    foundry_private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/custom.zone"]
  }

  assert {
    condition     = length(data.azurerm_private_dns_zone.api_azureml) == 0
    error_message = "The central DNS zone lookup should be skipped when foundry_private_dns_zone_ids is explicitly supplied"
  }

  assert {
    condition     = azurerm_private_endpoint.foundry_private_endpoint[0].private_dns_zone_group[0].private_dns_zone_ids[0] == var.foundry_private_dns_zone_ids[0]
    error_message = "The private endpoint should use the explicitly supplied DNS zone ids"
  }
}

run "test_empty_dns_zone_ids_omit_zone_group" {
  command = plan

  providers = {
    azurerm             = azurerm
    azurerm.private_dns = azurerm
  }

  variables {
    enable_managed_network       = true
    foundry_private_dns_zone_ids = []
  }

  assert {
    condition     = length(data.azurerm_private_dns_zone.api_azureml) == 0
    error_message = "The central DNS zone lookup should be skipped when foundry_private_dns_zone_ids is an empty list"
  }

  assert {
    condition     = length(azurerm_private_endpoint.foundry_private_endpoint[0].private_dns_zone_group) == 0
    error_message = "The DNS zone group block should be omitted when the resolved zone ID list is empty"
  }
}
