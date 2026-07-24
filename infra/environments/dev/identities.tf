resource "azurerm_user_assigned_identity" "frontend" {
  name                = "id-front-${local.prefix}-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = local.common_tags
}

resource "azurerm_user_assigned_identity" "backend" {
  name                = "id-back-${local.prefix}-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = local.common_tags
}