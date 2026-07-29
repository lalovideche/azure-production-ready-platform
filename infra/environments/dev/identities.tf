module "identities" {
  source = "../../modules/identities"

  frontend_name = "id-front-${local.prefix}-${var.name_suffix}"
  backend_name  = "id-back-${local.prefix}-${var.name_suffix}"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = local.common_tags
}