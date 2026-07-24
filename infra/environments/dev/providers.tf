provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  subscription_id     = var.subscription_id
  storage_use_azuread = true
}