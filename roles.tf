resource "azurerm_role_assignment" "blob_contributor_from_cognitive_account" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}