output "log_analytics_workspace_id" {
  description = "Resource ID of the Azure Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Azure Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.main.name
}

output "application_insights_id" {
  description = "Resource ID of the Azure Application Insights component."
  value       = azurerm_application_insights.main.id
}

output "application_insights_name" {
  description = "Name of the Azure Application Insights component."
  value       = azurerm_application_insights.main.name
}

output "application_insights_connection_string" {
  description = "Connection string of the Azure Application Insights component."
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "action_group_id" {
  description = "Resource ID of the Azure Monitor Action Group."
  value       = azurerm_monitor_action_group.email.id
}

output "action_group_name" {
  description = "Name of the Azure Monitor Action Group."
  value       = azurerm_monitor_action_group.email.name
}