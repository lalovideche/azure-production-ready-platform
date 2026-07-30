module "monitoring" {
  source = "../../modules/monitoring"

  log_analytics_workspace_name = "log-${local.prefix}-${var.name_suffix}"
  application_insights_name    = "appi-${local.prefix}-${var.name_suffix}"
  action_group_name            = "ag-${local.prefix}-${var.name_suffix}"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  log_analytics_sku               = "PerGB2018"
  log_analytics_retention_in_days = 30
  log_analytics_daily_quota_gb    = 0.5

  application_type = "web"

  action_group_short_name = "azrpalerts"
  email_receiver_name     = "portfolio-owner"
  alert_email             = var.alert_email
  use_common_alert_schema = true

  tags = local.common_tags
}

resource "azurerm_monitor_diagnostic_setting" "frontend" {
  name                       = "diag-frontend"
  target_resource_id         = module.application.frontend_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

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

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "backend" {
  name                       = "diag-backend"
  target_resource_id         = module.application.backend_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

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

  lifecycle {
    ignore_changes = [
      log_analytics_destination_type
    ]
  }
}