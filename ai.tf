resource "azurerm_ai_foundry" "ai_foundry" {
  name                  = "${var.product}-ai-foundry-${var.env}"
  location              = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name   = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  storage_account_id    = azurerm_storage_account.workspace_storage_account.id
  key_vault_id          = var.key_vault_id
  public_network_access = var.public_network_access_foundry

  identity {
    type = "SystemAssigned"
  }
  dynamic "managed_network" {
    for_each = var.enable_managed_network ? [1] : []
    content {
      isolation_mode = var.managed_network_isolation_mode
    }
  }

  tags = var.common_tags
}

resource "azurerm_ai_foundry_project" "ai_foundry_project" {
  name               = var.ai_project_name_override == null ? "${var.product}-project-${var.env}" : var.ai_project_name_override
  location           = azurerm_ai_foundry.ai_foundry.location
  ai_services_hub_id = azurerm_ai_foundry.ai_foundry.id
  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags

}

resource "azurerm_cognitive_account" "cognitive_account" {
  count               = var.create_cognitive_account == true ? 1 : 0
  name                = var.existing_cognitive_account_name == null ? "${var.product}-cognitive-account-${var.env}" : var.existing_cognitive_account_name
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  kind                = var.cognitive_account_kind

  public_network_access_enabled = var.public_network_access_cognitive
  custom_subdomain_name         = var.existing_cognitive_account_name == null ? "${var.product}-cognitive-account-${var.env}" : var.existing_cognitive_account_name

  sku_name = var.cognitive_account_sku

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags

}

resource "azurerm_machine_learning_workspace" "ml_workspace" {
  count = var.create_ml_workspace == true ? 1 : 0

  name                          = "${var.product}-ml-workspace-${var.env}"
  location                      = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name           = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  application_insights_id       = var.application_insights_id
  key_vault_id                  = var.key_vault_id
  storage_account_id            = azurerm_storage_account.workspace_storage_account.id
  public_network_access_enabled = var.public_network_access_ml

  identity {
    type = "SystemAssigned"
  }

  managed_network {
    isolation_mode = "AllowInternetOutbound"
  }

  tags = var.common_tags
}

resource "azurerm_machine_learning_compute_instance" "compute_instance" {
  count                         = var.instances
  name                          = "${var.product}-ci-${var.env}${count.index + 1}"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.ml_workspace[count.index].id
  virtual_machine_size          = var.vm_size
  authorization_type            = "personal"
  node_public_ip_enabled        = var.compute_instance_public_ip_enabled
  subnet_resource_id            = var.compute_instance_public_ip_enabled == false ? var.subnet_id : null

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}
