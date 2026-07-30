resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku               = var.log_analytics_sku
  retention_in_days = var.log_analytics_retention_in_days
  daily_quota_gb    = var.log_analytics_daily_quota_gb

  tags = var.tags
}

resource "azurerm_application_insights" "main" {
  name                = var.application_insights_name
  resource_group_name = var.resource_group_name
  location            = var.location

  workspace_id     = azurerm_log_analytics_workspace.main.id
  application_type = var.application_type

  tags = var.tags
}

resource "azurerm_monitor_action_group" "email" {
  name                = var.action_group_name
  resource_group_name = var.resource_group_name
  short_name          = var.action_group_short_name

  email_receiver {
    name                    = var.email_receiver_name
    email_address           = var.alert_email
    use_common_alert_schema = var.use_common_alert_schema
  }

  tags = var.tags
}