moved {
  from = azurerm_virtual_network.main
  to   = module.network.azurerm_virtual_network.main
}

moved {
  from = azurerm_network_security_group.appsvc
  to   = module.network.azurerm_network_security_group.appsvc
}

moved {
  from = azurerm_network_security_group.private_endpoints
  to   = module.network.azurerm_network_security_group.private_endpoints
}

moved {
  from = azurerm_subnet.appsvc_integration
  to   = module.network.azurerm_subnet.appsvc_integration
}

moved {
  from = azurerm_subnet.private_endpoints
  to   = module.network.azurerm_subnet.private_endpoints
}

moved {
  from = azurerm_subnet_network_security_group_association.appsvc
  to   = module.network.azurerm_subnet_network_security_group_association.appsvc
}

moved {
  from = azurerm_subnet_network_security_group_association.private_endpoints
  to   = module.network.azurerm_subnet_network_security_group_association.private_endpoints
}
moved {
  from = azurerm_container_registry.main
  to   = module.registry.azurerm_container_registry.main
}
moved {
  from = azurerm_storage_account.main
  to   = module.storage.azurerm_storage_account.main
}

moved {
  from = azurerm_storage_container.messages
  to   = module.storage.azurerm_storage_container.messages
}
moved {
  from = azurerm_key_vault.main
  to   = module.key_vault.azurerm_key_vault.main
}
moved {
  from = azurerm_user_assigned_identity.frontend
  to   = module.identities.azurerm_user_assigned_identity.frontend
}

moved {
  from = azurerm_user_assigned_identity.backend
  to   = module.identities.azurerm_user_assigned_identity.backend
}
moved {
  from = azurerm_service_plan.main
  to   = module.application.azurerm_service_plan.main
}

moved {
  from = azurerm_linux_web_app.frontend
  to   = module.application.azurerm_linux_web_app.frontend
}

moved {
  from = azurerm_linux_web_app.backend
  to   = module.application.azurerm_linux_web_app.backend
}
moved {
  from = azurerm_log_analytics_workspace.main
  to   = module.monitoring.azurerm_log_analytics_workspace.main
}

moved {
  from = azurerm_application_insights.main
  to   = module.monitoring.azurerm_application_insights.main
}

moved {
  from = azurerm_monitor_action_group.email
  to   = module.monitoring.azurerm_monitor_action_group.email
}