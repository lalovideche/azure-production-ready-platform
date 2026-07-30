output "storage_account_id" {
  description = "Resource ID of the Azure Storage Account."
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Name of the Azure Storage Account."
  value       = azurerm_storage_account.main.name
}

output "container_id" {
  description = "Resource ID of the Blob container."
  value       = azurerm_storage_container.messages.id
}

output "container_name" {
  description = "Name of the Blob container."
  value       = azurerm_storage_container.messages.name
}