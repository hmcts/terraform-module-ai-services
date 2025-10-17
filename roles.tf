# cognitive account access to ai storage account
resource "azurerm_role_assignment" "cog_blob_contributor_to_ai_storage_account" {
  scope                = azurerm_storage_account.workspace_storage_account[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}

resource "azurerm_role_assignment" "cog_contributor_to_ai_storage_account" {
  scope                = azurerm_storage_account.workspace_storage_account[0].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}

# cognitive account access to file storage account

resource "azurerm_role_assignment" "cog_blob_contributor_to_file_storage_account" {
  count                = var.files_storage_account_id == null ? 0 : 1
  scope                = var.files_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}

resource "azurerm_role_assignment" "cog_contributor_to_file_storage_account" {
  count                = var.files_storage_account_id == null ? 0 : 1
  scope                = var.files_storage_account_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}

# ml workspace access to ai storage account

resource "azurerm_role_assignment" "ml_blob_contributor_to_ai_storage_account" {
  scope                = azurerm_storage_account.workspace_storage_account[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_machine_learning_workspace.ml_workspace[count.index].identity.principal_id
}

resource "azurerm_role_assignment" "ml_contributor_from_to_ai_storage_account" {
  scope                = azurerm_storage_account.workspace_storage_account[0].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_machine_learning_workspace.ml_workspace[count.index].identity.principal_id
}

# ml workspace access to file storage account

resource "azurerm_role_assignment" "ml_blob_contributor_to_file_storage_account" {
  count = var.files_storage_account_id == null ? 0 : 1

  scope                = var.files_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_machine_learning_workspace.ml_workspace[count.index].identity.principal_id
}

resource "azurerm_role_assignment" "ml_contributor_to_file_storage_account" {
  count = var.files_storage_account_id == null ? 0 : 1

  scope                = var.files_storage_account_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_machine_learning_workspace.ml_workspace[count.index].identity.principal_id
}

# compute cluster access to ai storage account
resource "azurerm_role_assignment" "compute_blob_contributor_to_ai_storage_account" {
  for_each = tomap({
    for i in azurerm_machine_learning_compute_instance.compute_instance : i.name => i.identity[0].principal_id
  })
  scope                = azurerm_storage_account.workspace_storage_account[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "compute_contributor_to_ai_storage_account" {
  for_each = tomap({
    for i in azurerm_machine_learning_compute_instance.compute_instance : i.name => i.identity[0].principal_id
  })
  scope                = azurerm_storage_account.workspace_storage_account[0].id
  role_definition_name = "Contributor"
  principal_id         = each.value
}

# compute cluster access to file storage account
resource "azurerm_role_assignment" "compute_blob_contributor_to_file_storage_account" {
  for_each = tomap({
    for i in azurerm_machine_learning_compute_instance.compute_instance : i.name => i.identity[0].principal_id
  })
  scope                = var.files_storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "compute_contributor_to_file_storage_account" {
  for_each = tomap({
    for i in azurerm_machine_learning_compute_instance.compute_instance : i.name => i.identity[0].principal_id
  })
  scope                = var.files_storage_account_id
  role_definition_name = "Contributor"
  principal_id         = each.value
}

