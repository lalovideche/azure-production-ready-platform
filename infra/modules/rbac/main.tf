resource "azurerm_role_assignment" "frontend_acr_pull" {
  scope                = var.acr_scope
  role_definition_name = "AcrPull"
  principal_id         = var.frontend_principal_id
}

resource "azurerm_role_assignment" "backend_acr_pull" {
  scope                = var.acr_scope
  role_definition_name = "AcrPull"
  principal_id         = var.backend_principal_id
}

resource "azurerm_role_assignment" "backend_blob_data" {
  scope                = var.storage_account_scope
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.backend_principal_id
}

resource "azurerm_role_assignment" "backend_key_vault" {
  scope                = var.key_vault_scope
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.backend_principal_id
}