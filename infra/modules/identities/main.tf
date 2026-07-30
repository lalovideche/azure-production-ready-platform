resource "azurerm_user_assigned_identity" "frontend" {
  name                = var.frontend_name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "backend" {
  name                = var.backend_name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags
}