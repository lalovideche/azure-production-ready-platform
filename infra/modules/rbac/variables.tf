variable "acr_scope" {
  description = "Resource ID of the Azure Container Registry."
  type        = string
}

variable "storage_account_scope" {
  description = "Resource ID of the Azure Storage Account."
  type        = string
}

variable "key_vault_scope" {
  description = "Resource ID of the Azure Key Vault."
  type        = string
}

variable "frontend_principal_id" {
  description = "Principal ID of the frontend managed identity."
  type        = string
}

variable "backend_principal_id" {
  description = "Principal ID of the backend managed identity."
  type        = string
}