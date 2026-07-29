variable "name" {
  description = "Name of the Azure Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the Key Vault."
  type        = string
}

variable "location" {
  description = "Azure region where the Key Vault is deployed."
  type        = string
}

variable "tenant_id" {
  description = "Microsoft Entra tenant ID associated with the Key Vault."
  type        = string
}

variable "sku_name" {
  description = "SKU assigned to the Key Vault."
  type        = string
  default     = "standard"
}

variable "rbac_authorization_enabled" {
  description = "Whether Azure RBAC is used for Key Vault data-plane authorization."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Whether the Key Vault accepts public network access."
  type        = bool
  default     = false
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled for the Key Vault."
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "Number of days deleted Key Vault objects are retained."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to the Azure Key Vault."
  type        = map(string)
  default     = {}
}