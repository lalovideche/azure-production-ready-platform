output "resource_group_name" {
  description = "Name of the main resource group."
  value       = azurerm_resource_group.main.name
}

output "acr_name" {
  description = "Name of the Azure Container Registry."
  value       = module.registry.name
}

output "acr_login_server" {
  description = "Login server of the Azure Container Registry."
  value       = module.registry.login_server
}

output "frontend_name" {
  description = "Name of the frontend Azure Web App."
  value       = azurerm_linux_web_app.frontend.name
}

output "backend_name" {
  description = "Name of the backend Azure Web App."
  value       = azurerm_linux_web_app.backend.name
}

output "frontend_hostname" {
  description = "Default hostname of the frontend Azure Web App."
  value       = azurerm_linux_web_app.frontend.default_hostname
}

output "backend_hostname" {
  description = "Default hostname of the backend Azure Web App."
  value       = azurerm_linux_web_app.backend.default_hostname
}