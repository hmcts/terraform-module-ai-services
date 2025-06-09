resource "azurerm_private_endpoint" "foundry_private_endpoint" {
  name                = "${var.product}-ai-foundry-pe-${var.env}"
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "ai-foundry-psc"
    private_connection_resource_id = azurerm_ai_foundry.ai_foundry.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "endpoint-dnszonegroup"
    private_dns_zone_ids = [
      "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms",
      "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
    ]
  }

  tags = var.common_tags

}

resource "azurerm_private_endpoint" "cognitive_private_endpoint" {
  name                = "${var.product}-cognitive-account-pe-${var.env}"
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "cognitive-account-psc"
    private_connection_resource_id = azurerm_cognitive_account.cognitive_account.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "endpoint-dnszonegroup"
    private_dns_zone_ids = [
      "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.cognitiveservices.azure.com"
    ]
  }

  tags = var.common_tags

}

resource "azurerm_private_endpoint" "ml_private_endpoint" {
  name                = "${var.product}-ml-workspace-pe-${var.env}"
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "ml-workspace-psc"
    private_connection_resource_id = azurerm_machine_learning_workspace.ml_workspace.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "endpoint-dnszonegroup"
    private_dns_zone_ids = [
      "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.api.azureml.ms",
      "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.notebooks.azure.net"
    ]
  }

  tags = var.common_tags

}