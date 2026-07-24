resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${local.prefix}-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku               = "PerGB2018"
  retention_in_days = 30
  daily_quota_gb    = 0.5

  tags = local.common_tags
}

resource "azurerm_application_insights" "main" {
  name                = "appi-${local.prefix}-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  workspace_id     = azurerm_log_analytics_workspace.main.id
  application_type = "web"

  tags = local.common_tags
}

resource "azurerm_monitor_diagnostic_setting" "frontend" {
  name                       = "diag-frontend"
  target_resource_id         = azurerm_linux_web_app.frontend.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "backend" {
  name                       = "diag-backend"
  target_resource_id         = azurerm_linux_web_app.backend.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_action_group" "email" {
  name                = "ag-${local.prefix}-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "azrpalerts"

  email_receiver {
    name                    = "portfolio-owner"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = local.common_tags
}