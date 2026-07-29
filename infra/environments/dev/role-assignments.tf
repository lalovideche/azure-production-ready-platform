resource "azurerm_role_assignment" "frontend_acr_pull" {
  scope                = module.registry.id
  role_definition_name = "AcrPull"
  principal_id         = module.identities.frontend_principal_id
}

resource "azurerm_role_assignment" "backend_acr_pull" {
  scope                = module.registry.id
  role_definition_name = "AcrPull"
  principal_id         = module.identities.backend_principal_id
}

resource "azurerm_role_assignment" "backend_blob_data" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.identities.backend_principal_id
}

resource "azurerm_role_assignment" "backend_key_vault" {
  scope                = module.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.identities.backend_principal_id
}