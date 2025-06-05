output "cognitive_account_identity" {
  value = azurerm_cognitive_account.cognitive_account.identity[0].principal_id
}

output "ai_foundry_identity" {
  value = azurerm_ai_foundry.ai_foundry.identity[0].principal_id
}

output "ml_workspace_identity" {
  value = azurerm_machine_learning_workspace.ml_workspace.identity[0].principal_id
}

output "cognitive_account_primary_access_key" {
  value = azurerm_cognitive_account.cognitive_account.primary_access_key
}

output "cognitive_account_secondary_access_key" {
  value = azurerm_cognitive_account.cognitive_account.secondary_access_key
}

output "compute_instance_identity" {
  value = azurerm_machine_learning_compute_instance.compute_instance.identity[0].principal_id
}
