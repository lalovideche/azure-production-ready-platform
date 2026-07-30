output "frontend_acr_pull_id" {
  description = "Resource ID of the frontend AcrPull role assignment."
  value       = azurerm_role_assignment.frontend_acr_pull.id
}

output "backend_acr_pull_id" {
  description = "Resource ID of the backend AcrPull role assignment."
  value       = azurerm_role_assignment.backend_acr_pull.id
}

output "backend_blob_data_id" {
  description = "Resource ID of the backend Storage Blob Data Contributor assignment."
  value       = azurerm_role_assignment.backend_blob_data.id
}

output "backend_key_vault_id" {
  description = "Resource ID of the backend Key Vault Secrets User assignment."
  value       = azurerm_role_assignment.backend_key_vault.id
}