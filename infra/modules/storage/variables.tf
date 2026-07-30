variable "storage_account_name" {
  description = "Name of the Azure Storage Account."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the Storage Account."
  type        = string
}

variable "location" {
  description = "Azure region where the Storage Account is deployed."
  type        = string
}

variable "account_tier" {
  description = "Performance tier of the Storage Account."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type of the Storage Account."
  type        = string
  default     = "LRS"
}

variable "min_tls_version" {
  description = "Minimum TLS version accepted by the Storage Account."
  type        = string
  default     = "TLS1_2"
}

variable "public_network_access_enabled" {
  description = "Whether the Storage Account accepts public network access."
  type        = bool
  default     = false
}

variable "allow_nested_items_to_be_public" {
  description = "Whether nested objects can be configured for public access."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Whether shared-key authorization is allowed."
  type        = bool
  default     = false
}

variable "default_to_oauth_authentication" {
  description = "Whether Microsoft Entra authentication is the default."
  type        = bool
  default     = true
}

variable "container_name" {
  description = "Name of the private Blob container."
  type        = string
}

variable "container_access_type" {
  description = "Access type assigned to the Blob container."
  type        = string
  default     = "private"
}

variable "tags" {
  description = "Tags applied to the Storage Account."
  type        = map(string)
  default     = {}
}