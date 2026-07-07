locals {
  lookup_foundry_zones   = var.enable_managed_network && var.create_ai_foundry && var.foundry_private_dns_zone_ids == null
  lookup_cognitive_zones = var.enable_managed_network && var.create_cognitive_account && var.cognitive_private_dns_zone_ids == null
  lookup_ml_zones        = var.enable_managed_network && var.create_ml_workspace && var.ml_private_dns_zone_ids == null
}

data "azurerm_private_dns_zone" "api_azureml" {
  provider            = azurerm.private_dns
  count               = local.lookup_foundry_zones || local.lookup_ml_zones ? 1 : 0
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "notebooks" {
  provider            = azurerm.private_dns
  count               = local.lookup_foundry_zones || local.lookup_ml_zones ? 1 : 0
  name                = "privatelink.notebooks.azure.net"
  resource_group_name = var.private_dns_zone_resource_group_name
}

data "azurerm_private_dns_zone" "cognitiveservices" {
  provider            = azurerm.private_dns
  count               = local.lookup_cognitive_zones ? 1 : 0
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = var.private_dns_zone_resource_group_name
}

locals {
  foundry_private_dns_zone_ids   = local.lookup_foundry_zones ? [data.azurerm_private_dns_zone.api_azureml[0].id, data.azurerm_private_dns_zone.notebooks[0].id] : coalesce(var.foundry_private_dns_zone_ids, [])
  cognitive_private_dns_zone_ids = local.lookup_cognitive_zones ? [data.azurerm_private_dns_zone.cognitiveservices[0].id] : coalesce(var.cognitive_private_dns_zone_ids, [])
  ml_private_dns_zone_ids        = local.lookup_ml_zones ? [data.azurerm_private_dns_zone.api_azureml[0].id, data.azurerm_private_dns_zone.notebooks[0].id] : coalesce(var.ml_private_dns_zone_ids, [])
}
