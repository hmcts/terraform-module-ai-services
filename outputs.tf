output "cognitive_account_identity" {
  value = azurerm_cognitive_account.cognitive_account[0].identity[0].principal_id
}

output "ai_foundry_identity" {
  value = azurerm_ai_foundry.ai_foundry.identity[0].principal_id
}

output "ml_workspace_identity" {
  value = azurerm_machine_learning_workspace.ml_workspace.identity[count.index].principal_id
}

output "cognitive_account_primary_access_key" {
  value = azurerm_cognitive_account.cognitive_account[0].primary_access_key
}

output "cognitive_account_secondary_access_key" {
  value = azurerm_cognitive_account.cognitive_account[0].secondary_access_key
}

output "compute_instance_identity" {
  value = tomap({
    for i in azurerm_machine_learning_compute_instance.compute_instance : i.name => i.identity[0].principal_id
  })
}

output "ai_storage_account_id" {
  value = azurerm_storage_account.workspace_storage_account[0].id
}
