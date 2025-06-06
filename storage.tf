resource "azurerm_storage_account" "workspace_storage_account" {
  name                     = "${replace(var.product, "-", "")}${var.component}sa${var.env}"
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