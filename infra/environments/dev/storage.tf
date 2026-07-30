module "storage" {
  source = "../../modules/storage"

  storage_account_name = local.storage_name
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true

  container_name        = "messages"
  container_access_type = "private"

  tags = local.common_tags
}