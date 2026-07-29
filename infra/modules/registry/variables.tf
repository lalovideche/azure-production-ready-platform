variable "name" {
  description = "Name of the Azure Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the registry."
  type        = string
}

variable "location" {
  description = "Azure region where the registry is deployed."
  type        = string
}

variable "sku" {
  description = "Service tier of the Azure Container Registry."
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Whether the registry administrator account is enabled."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the Azure Container Registry."
  type        = map(string)
  default     = {}
}