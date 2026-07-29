output "service_plan_id" {
  description = "Resource ID of the Azure App Service Plan."
  value       = azurerm_service_plan.main.id
}

output "frontend_id" {
  description = "Resource ID of the frontend Azure Web App."
  value       = azurerm_linux_web_app.frontend.id
}

output "frontend_name" {
  description = "Name of the frontend Azure Web App."
  value       = azurerm_linux_web_app.frontend.name
}

output "frontend_hostname" {
  description = "Default hostname of the frontend Azure Web App."
  value       = azurerm_linux_web_app.frontend.default_hostname
}

output "backend_id" {
  description = "Resource ID of the backend Azure Web App."
  value       = azurerm_linux_web_app.backend.id
}

output "backend_name" {
  description = "Name of the backend Azure Web App."
  value       = azurerm_linux_web_app.backend.name
}

output "backend_hostname" {
  description = "Default hostname of the backend Azure Web App."
  value       = azurerm_linux_web_app.backend.default_hostname
}