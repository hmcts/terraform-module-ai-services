resource "azurerm_ai_foundry" "ai_foundry" {
  count                 = var.create_ai_foundry == true ? 1 : 0
  name                  = "${var.product}-ai-foundry-${var.env}"
  location              = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name   = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  storage_account_id    = length(azurerm_storage_account.workspace_storage_account) == 0 ? var.existing_storage_account_id : azurerm_storage_account.workspace_storage_account[0].id
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

moved {
  from = azurerm_ai_foundry.ai_foundry
  to   = azurerm_ai_foundry.ai_foundry[0]
}

resource "azurerm_ai_foundry_project" "ai_foundry_project" {
  count              = var.create_ai_foundry == true ? 1 : 0
  name               = var.ai_project_name_override == null ? "${var.product}-project-${var.env}" : var.ai_project_name_override
  location           = azurerm_ai_foundry.ai_foundry[0].location
  ai_services_hub_id = azurerm_ai_foundry.ai_foundry[0].id
  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags

}

moved {
  from = azurerm_ai_foundry_project.ai_foundry_project
  to   = azurerm_ai_foundry_project.ai_foundry_project[0]
}

resource "azurerm_cognitive_account" "cognitive_account" {
  count               = var.create_cognitive_account == true ? 1 : 0
  name                = var.existing_cognitive_account_name == null ? "${var.product}-cognitive-account-${var.env}" : var.existing_cognitive_account_name
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  kind                = var.cognitive_account_kind

  public_network_access_enabled = var.public_network_access_cognitive
  custom_subdomain_name         = var.existing_cognitive_account_name == null ? "${var.product}-cognitive-account-${var.env}" : var.existing_cognitive_account_name
  local_auth_enabled            = var.cognitive_account_local_auth_enabled

  outbound_network_access_restricted = var.cognitive_account_outbound_network_access_restricted

  sku_name = var.cognitive_account_sku

  dynamic "network_acls" {
    for_each = var.cognitive_account_network_acls_default_action == null ? [] : [1]
    content {
      default_action = var.cognitive_account_network_acls_default_action
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags

}

resource "azurerm_cognitive_account" "content_safety_account" {
  count               = var.create_content_safety_account == true ? 1 : 0
  name                = var.existing_content_safety_account_name == null ? "${var.product}-content-safety-account-${var.env}" : var.existing_content_safety_account_name
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  kind                = "ContentSafety"

  public_network_access_enabled = var.public_network_access_cognitive
  custom_subdomain_name         = var.existing_content_safety_account_name == null ? "${var.product}-content-safety-account-${var.env}" : var.existing_content_safety_account_name
  local_auth_enabled            = var.cognitive_account_local_auth_enabled

  outbound_network_access_restricted = var.cognitive_account_outbound_network_access_restricted

  sku_name = var.content_safety_account_sku

  dynamic "network_acls" {
    for_each = var.cognitive_account_network_acls_default_action == null ? [] : [1]
    content {
      default_action = var.cognitive_account_network_acls_default_action
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.common_tags
}

resource "azurerm_cognitive_deployment" "cognitive_deployment" {
  for_each             = var.cognitive_deployments
  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.cognitive_account[0].id

  version_upgrade_option = each.value.version_upgrade_option

  model {
    format  = each.value.model_format == null ? "OpenAI" : each.value.model_format
    name    = each.value.model_name == null ? "gpt-5-mini" : each.value.model_name
    version = each.value.model_version == null ? "2025-08-07" : each.value.model_version
  }

  sku {
    name     = each.value.sku_name == null ? "GlobalStandard" : each.value.sku_name
    capacity = each.value.sku_capacity == null ? 1 : each.value.sku_capacity
  }
}

resource "azurerm_machine_learning_workspace" "ml_workspace" {
  count = var.create_ml_workspace == true ? 1 : 0

  name                          = "${var.product}-ml-workspace-${var.env}"
  location                      = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].location : var.location
  resource_group_name           = var.existing_resource_group_name == null ? azurerm_resource_group.rg[0].name : var.existing_resource_group_name
  application_insights_id       = var.application_insights_id
  key_vault_id                  = var.key_vault_id
  storage_account_id            = length(azurerm_storage_account.workspace_storage_account) == 0 ? var.existing_storage_account_id : azurerm_storage_account.workspace_storage_account[0].id
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
