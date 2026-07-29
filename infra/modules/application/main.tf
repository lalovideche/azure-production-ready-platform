resource "azurerm_service_plan" "main" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = var.os_type
  sku_name = var.sku_name

  tags = var.tags
}

resource "azurerm_linux_web_app" "frontend" {
  name                = var.frontend_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only                    = var.https_only
  public_network_access_enabled = var.frontend_public_network_access_enabled
  virtual_network_subnet_id     = var.app_service_subnet_id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.frontend_identity_id]
  }

  site_config {
    always_on              = var.always_on
    minimum_tls_version    = var.minimum_tls_version
    vnet_route_all_enabled = var.vnet_route_all_enabled

    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = var.frontend_identity_client_id

    application_stack {
      docker_image_name   = "frontend:${var.frontend_image_tag}"
      docker_registry_url = "https://${var.registry_login_server}"
    }
  }

  app_settings = var.frontend_app_settings

  tags = var.tags
}

resource "azurerm_linux_web_app" "backend" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.main.id

  https_only                    = var.https_only
  public_network_access_enabled = var.backend_public_network_access_enabled
  virtual_network_subnet_id     = var.app_service_subnet_id

  identity {
    type         = "UserAssigned"
    identity_ids = [var.backend_identity_id]
  }

  site_config {
    always_on              = var.always_on
    minimum_tls_version    = var.minimum_tls_version
    vnet_route_all_enabled = var.vnet_route_all_enabled

    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = var.backend_identity_client_id

    application_stack {
      docker_image_name   = "backend:${var.backend_image_tag}"
      docker_registry_url = "https://${var.registry_login_server}"
    }
  }

  app_settings = var.backend_app_settings

  tags = var.tags
}