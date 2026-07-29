output "id" {
  description = "Resource ID of the Azure Container Registry."
  value       = azurerm_container_registry.main.id
}

output "name" {
  description = "Name of the Azure Container Registry."
  value       = azurerm_container_registry.main.name
}

output "login_server" {
  description = "Login server of the Azure Container Registry."
  value       = azurerm_container_registry.main.login_server
}