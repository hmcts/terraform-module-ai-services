resource "azurerm_private_endpoint" "foundry_private_endpoint" {
  count               = var.enable_managed_network && var.create_ai_foundry ? 1 : 0
  name                = "${var.product}-ai-foundry-pe-${var.env}"
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "ai-foundry-psc"
    private_connection_resource_id = azurerm_ai_foundry.ai_foundry[0].id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = length(local.foundry_private_dns_zone_ids) == 0 ? [] : [1]
    content {
      name                 = "endpoint-dnszonegroup"
      private_dns_zone_ids = local.foundry_private_dns_zone_ids
    }
  }

  tags = var.common_tags

}

resource "azurerm_private_endpoint" "cognitive_private_endpoint" {
  count = var.enable_managed_network && var.create_cognitive_account ? 1 : 0

  name                = "${var.product}-cognitive-account-pe-${var.env}"
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "cognitive-account-psc"
    private_connection_resource_id = azurerm_cognitive_account.cognitive_account[0].id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  # Omitted when the zone ID list is empty (DNS managed externally).
  dynamic "private_dns_zone_group" {
    for_each = length(local.cognitive_private_dns_zone_ids) == 0 ? [] : [1]
    content {
      name                 = "endpoint-dnszonegroup"
      private_dns_zone_ids = local.cognitive_private_dns_zone_ids
    }
  }

  tags = var.common_tags

}

resource "azurerm_private_endpoint" "content_safety_private_endpoint" {
  count = var.enable_managed_network && var.create_content_safety_account ? 1 : 0

  name                = "${var.product}-content-safety-account-pe-${var.env}"
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "content-safety-account-psc"
    private_connection_resource_id = azurerm_cognitive_account.content_safety_account[0].id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  # Omitted when the zone ID list is empty (DNS managed externally).
  dynamic "private_dns_zone_group" {
    for_each = length(local.cognitive_private_dns_zone_ids) == 0 ? [] : [1]
    content {
      name                 = "endpoint-dnszonegroup"
      private_dns_zone_ids = local.cognitive_private_dns_zone_ids
    }
  }

  tags = var.common_tags
}

resource "azurerm_private_endpoint" "ml_private_endpoint" {
  count = var.enable_managed_network && var.create_ml_workspace ? 1 : 0

  name                = "${var.product}-ml-workspace-pe-${var.env}"
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {

    name                           = "ml-workspace-psc"
    private_connection_resource_id = azurerm_machine_learning_workspace.ml_workspace[0].id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  # Omitted when the zone ID list is empty (DNS managed externally).
  dynamic "private_dns_zone_group" {
    for_each = length(local.ml_private_dns_zone_ids) == 0 ? [] : [1]
    content {
      name                 = "endpoint-dnszonegroup"
      private_dns_zone_ids = local.ml_private_dns_zone_ids
    }
  }

  tags = var.common_tags

}
