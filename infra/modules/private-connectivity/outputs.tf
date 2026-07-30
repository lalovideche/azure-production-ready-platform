output "webapps_private_dns_zone_id" {
  description = "Resource ID of the Azure Web Apps private DNS zone."
  value       = azurerm_private_dns_zone.webapps.id
}

output "blob_private_dns_zone_id" {
  description = "Resource ID of the Azure Blob Storage private DNS zone."
  value       = azurerm_private_dns_zone.blob.id
}

output "key_vault_private_dns_zone_id" {
  description = "Resource ID of the Azure Key Vault private DNS zone."
  value       = azurerm_private_dns_zone.key_vault.id
}

output "backend_private_endpoint_id" {
  description = "Resource ID of the backend private endpoint."
  value       = azurerm_private_endpoint.backend.id
}

output "blob_private_endpoint_id" {
  description = "Resource ID of the Storage Blob private endpoint."
  value       = azurerm_private_endpoint.blob.id
}

output "key_vault_private_endpoint_id" {
  description = "Resource ID of the Key Vault private endpoint."
  value       = azurerm_private_endpoint.key_vault.id
}