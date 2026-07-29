resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space

  tags = var.tags
}

resource "azurerm_network_security_group" "appsvc" {
  name                = var.appsvc_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "private_endpoints" {
  name                = var.private_endpoints_nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "appsvc_integration" {
  name                 = var.appsvc_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.appsvc_subnet_prefixes

  delegation {
    name = "app-service-delegation"

    service_delegation {
      name = "Microsoft.Web/serverFarms"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = var.private_endpoints_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.private_endpoints_subnet_prefixes

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_subnet_network_security_group_association" "appsvc" {
  subnet_id                 = azurerm_subnet.appsvc_integration.id
  network_security_group_id = azurerm_network_security_group.appsvc.id
}

resource "azurerm_subnet_network_security_group_association" "private_endpoints" {
  subnet_id                 = azurerm_subnet.private_endpoints.id
  network_security_group_id = azurerm_network_security_group.private_endpoints.id
}
