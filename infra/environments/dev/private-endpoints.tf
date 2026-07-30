module "private_connectivity" {
  source = "../../modules/private-connectivity"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  virtual_network_id          = module.network.virtual_network_id
  private_endpoints_subnet_id = module.network.private_endpoints_subnet_id

  backend_private_endpoint_name   = "pe-${local.backend_name}"
  blob_private_endpoint_name      = "pe-blob-${local.prefix}-${var.name_suffix}"
  key_vault_private_endpoint_name = "pe-kv-${local.prefix}-${var.name_suffix}"

  backend_resource_id = module.application.backend_id
  storage_account_id  = module.storage.storage_account_id
  key_vault_id        = module.key_vault.id

  webapps_private_dns_zone_name   = "privatelink.azurewebsites.net"
  blob_private_dns_zone_name      = "privatelink.blob.core.windows.net"
  key_vault_private_dns_zone_name = "privatelink.vaultcore.azure.net"

  tags = local.common_tags
}