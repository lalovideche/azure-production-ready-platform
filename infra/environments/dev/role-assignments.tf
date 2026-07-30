module "rbac" {
  source = "../../modules/rbac"

  acr_scope             = module.registry.id
  storage_account_scope = module.storage.storage_account_id
  key_vault_scope       = module.key_vault.id

  frontend_principal_id = module.identities.frontend_principal_id
  backend_principal_id  = module.identities.backend_principal_id
}