resource "azurerm_storage_account" "workspace_storage_account" {
  count                    = var.create_storage_account && var.existing_storage_account_id == null ? 1 : 0
  name                     = var.storage_account_name_override == null ? "${replace(var.product, "-", "")}${var.component}sa${var.env}" : var.storage_account_name_override
  resource_group_name      = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  location                 = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  account_tier             = var.workspace_storage_account_tier
  account_replication_type = var.workspace_storage_account_replication_type

  allow_nested_items_to_be_public = false

  tags = var.common_tags

  network_rules {
    bypass                     = ["AzureServices"]
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.sa_subnets
    default_action             = var.default_action
  }

  blob_properties {
    container_delete_retention_policy {
      days = 7
    }
    cors_rule {

      allowed_headers = ["*"]
      allowed_methods = ["DELETE", "GET", "HEAD", "MERGE", "POST", "OPTIONS", "PUT", "PATCH"]
      allowed_origins = [
        "https://documentintelligence.ai.azure.com",
        "https://mlworkspace.azure.ai",
        "https://ml.azure.com",
        "https://*.ml.azure.com",
        "https://ai.azure.com",
        "https://*.ai.azure.com",
      ]
      exposed_headers    = ["*"]
      max_age_in_seconds = 120
    }
  }
}

locals {
  create_cognitive_account_storage = var.create_cognitive_account && var.create_cognitive_account_storage
  cognitive_account_storage_name   = var.cognitive_account_storage_name_override == null ? "${replace(var.product, "-", "")}${replace(var.component, "-", "")}byos${var.env}" : var.cognitive_account_storage_name_override
  # Built from its parts: reading it from the account would be a cycle, as the account needs this storage first.
  cognitive_account_resource_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name}/providers/Microsoft.CognitiveServices/accounts/${var.existing_cognitive_account_name == null ? "${var.product}-cognitive-account-${var.env}" : var.existing_cognitive_account_name}"
  cognitive_account_fqdns       = local.create_cognitive_account_storage && var.cognitive_account_outbound_network_access_restricted ? distinct(concat(coalesce(var.cognitive_account_fqdns, []), [azurerm_storage_account.cognitive_account_storage[0].primary_blob_host])) : var.cognitive_account_fqdns
}

resource "azurerm_storage_account" "cognitive_account_storage" {
  count                    = local.create_cognitive_account_storage ? 1 : 0
  name                     = local.cognitive_account_storage_name
  resource_group_name      = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  location                 = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = false

  tags = var.common_tags

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Deny"

    private_link_access {
      endpoint_resource_id = local.cognitive_account_resource_id
    }
  }
}