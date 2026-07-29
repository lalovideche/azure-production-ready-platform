resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source = "../../modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  vnet_name          = local.vnet_name
  vnet_address_space = ["10.20.0.0/16"]

  appsvc_nsg_name            = "nsg-appsvc-${local.prefix}-${var.name_suffix}"
  private_endpoints_nsg_name = "nsg-pe-${local.prefix}-${var.name_suffix}"

  appsvc_subnet_name     = "snet-appsvc-integration"
  appsvc_subnet_prefixes = ["10.20.1.0/26"]

  private_endpoints_subnet_name     = "snet-private-endpoints"
  private_endpoints_subnet_prefixes = ["10.20.2.0/27"]

  tags = local.common_tags
}