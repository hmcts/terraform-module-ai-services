resource "azurerm_role_assignment" "blob_contributor_from_cognitive_account" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}

resource "azurerm_role_assignment" "contributor_from_cognitive_account" {
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}

resource "azurerm_role_assignment" "blob_contributor_from_compute_instance" {
  for_each = tomap({
    for i in azurerm_machine_learning_compute_instance.compute_instance : i.name => i.identity[0].principal_id
  })
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "contributor_from_compute_instance" {
  for_each = tomap({
    for i in azurerm_machine_learning_compute_instance.compute_instance : i.name => i.identity[0].principal_id
  })
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "blob_contributor_from_ml_workspace" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_machine_learning_workspace.ml_workspace.identity[0].principal_id
}

resource "azurerm_role_assignment" "contributor_from_ml_workspace" {
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_machine_learning_workspace.ml_workspace.identity[0].principal_id
}