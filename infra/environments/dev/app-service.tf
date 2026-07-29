module "application" {
  source = "../../modules/application"

  service_plan_name   = local.service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  os_type  = "Linux"
  sku_name = "B1"

  frontend_name = local.frontend_name
  backend_name  = local.backend_name

  app_service_subnet_id = module.network.appsvc_integration_subnet_id

  frontend_identity_id        = module.identities.frontend_id
  frontend_identity_client_id = module.identities.frontend_client_id

  backend_identity_id        = module.identities.backend_id
  backend_identity_client_id = module.identities.backend_client_id

  registry_login_server = module.registry.login_server

  frontend_image_tag = var.frontend_image_tag
  backend_image_tag  = var.backend_image_tag

  https_only = true

  frontend_public_network_access_enabled = true
  backend_public_network_access_enabled  = false

  always_on              = true
  minimum_tls_version    = "1.2"
  vnet_route_all_enabled = true

  frontend_app_settings = {
    BACKEND_URL   = "https://${local.backend_name}.azurewebsites.net"
    WEBSITES_PORT = "8000"

    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.main.connection_string
    OTEL_SERVICE_NAME                     = "azrp-frontend"
  }

  backend_app_settings = {
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