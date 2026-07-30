variable "frontend_name" {
  description = "Name of the user-assigned managed identity used by the frontend."
  type        = string
}

variable "backend_name" {
  description = "Name of the user-assigned managed identity used by the backend."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the managed identities."
  type        = string
}

variable "location" {
  description = "Azure region where the managed identities are deployed."
  type        = string
}

variable "tags" {
  description = "Tags applied to the managed identities."
  type        = map(string)
  default     = {}
}