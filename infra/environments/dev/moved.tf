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