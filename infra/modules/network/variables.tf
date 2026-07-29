variable "resource_group_name" {
  description = "Name of the resource group containing the network resources."
  type        = string
}

variable "location" {
  description = "Azure region where the network resources are deployed."
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space assigned to the virtual network."
  type        = list(string)
}

variable "appsvc_nsg_name" {
  description = "Name of the App Service integration subnet NSG."
  type        = string
}

variable "private_endpoints_nsg_name" {
  description = "Name of the private endpoints subnet NSG."
  type        = string
}

variable "appsvc_subnet_name" {
  description = "Name of the App Service integration subnet."
  type        = string
}

variable "appsvc_subnet_prefixes" {
  description = "Address prefixes assigned to the App Service integration subnet."
  type        = list(string)
}

variable "private_endpoints_subnet_name" {
  description = "Name of the private endpoints subnet."
  type        = string
}

variable "private_endpoints_subnet_prefixes" {
  description = "Address prefixes assigned to the private endpoints subnet."
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to the network resources."
  type        = map(string)
  default     = {}
}