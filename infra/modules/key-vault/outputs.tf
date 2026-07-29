output "id" {
  description = "Resource ID of the Azure Key Vault."
  value       = azurerm_key_vault.main.id
}

output "name" {
  description = "Name of the Azure Key Vault."
  value       = azurerm_key_vault.main.name
}

output "vault_uri" {
  description = "URI used to access the Azure Key Vault."
  value       = azurerm_key_vault.main.vault_uri
}