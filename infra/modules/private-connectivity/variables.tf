variable "resource_group_name" {
  description = "Name of the resource group containing the private connectivity resources."
  type        = string
}

variable "location" {
  description = "Azure region where the private endpoints are deployed."
  type        = string
}

variable "virtual_network_id" {
  description = "Resource ID of the virtual network linked to the private DNS zones."
  type        = string
}

variable "private_endpoints_subnet_id" {
  description = "Resource ID of the subnet containing the private endpoints."
  type        = string
}

variable "backend_private_endpoint_name" {
  description = "Name of the backend Web App private endpoint."
  type        = string
}

variable "blob_private_endpoint_name" {
  description = "Name of the Storage Blob private endpoint."
  type        = string
}

variable "key_vault_private_endpoint_name" {
  description = "Name of the Key Vault private endpoint."
  type        = string
}

variable "backend_resource_id" {
  description = "Resource ID of the backend Azure Web App."
  type        = string
}

variable "storage_account_id" {
  description = "Resource ID of the Azure Storage Account."
  type        = string
}

variable "key_vault_id" {
  description = "Resource ID of the Azure Key Vault."
  type        = string
}

variable "webapps_private_dns_zone_name" {
  description = "Name of the Azure Web Apps private DNS zone."
  type        = string
  default     = "privatelink.azurewebsites.net"
}

variable "blob_private_dns_zone_name" {
  description = "Name of the Azure Blob Storage private DNS zone."
  type        = string
  default     = "privatelink.blob.core.windows.net"
}

variable "key_vault_private_dns_zone_name" {
  description = "Name of the Azure Key Vault private DNS zone."
  type        = string
  default     = "privatelink.vaultcore.azure.net"
}

variable "tags" {
  description = "Tags applied to the private endpoints."
  type        = map(string)
  default     = {}
}