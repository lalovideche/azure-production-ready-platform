resource "azurerm_service_plan" "main" {
  name                = local.service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  os_type  = "Linux"
  sku_name = "B1"

  tags = local.common_tags
}

resource "azurerm_linux_web_app" "frontend" {
  name                = local.frontend_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only                    = true
  public_network_access_enabled = true
  virtual_network_subnet_id     = module.network.appsvc_integration_subnet_id

  identity {
    type         = "UserAssigned"
    identity_ids = [module.identities.frontend_id]
  }

  site_config {
    always_on              = true
    minimum_tls_version    = "1.2"
    vnet_route_all_enabled = true

    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = module.identities.frontend_client_id

    application_stack {
      docker_image_name   = "frontend:${var.frontend_image_tag}"
      docker_registry_url = "https://${module.registry.login_server}"
    }
  }

  app_settings = {
    BACKEND_URL   = "https://${local.backend_name}.azurewebsites.net"
    WEBSITES_PORT = "8000"

    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.main.connection_string
    OTEL_SERVICE_NAME                     = "azrp-frontend"
  }

  tags = local.common_tags
}

resource "azurerm_linux_web_app" "backend" {
  name                = local.backend_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only                    = true
  public_network_access_enabled = false
  virtual_network_subnet_id     = module.network.appsvc_integration_subnet_id

  identity {
    type         = "UserAssigned"
    identity_ids = [module.identities.backend_id]
  }

  site_config {
    always_on                                     = true
    minimum_tls_version                           = "1.2"
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = module.identities.backend_client_id
    vnet_route_all_enabled                        = true

    application_stack {
      docker_image_name   = "backend:${var.backend_image_tag}"
      docker_registry_url = "https://${module.registry.login_server}"
    }
  }

  app_settings = {
    AZURE_CLIENT_ID      = module.identities.backend_client_id
    STORAGE_ACCOUNT_NAME = module.storage.storage_account_name
    BLOB_CONTAINER_NAME  = module.storage.container_name
    KEY_VAULT_URL        = module.key_vault.vault_uri
    WEBSITES_PORT        = "8000"

    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.main.connection_string
    OTEL_SERVICE_NAME                     = "azrp-backend"
  }

  tags = local.common_tags
}