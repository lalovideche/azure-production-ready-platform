variable "service_plan_name" {
  description = "Name of the Azure App Service Plan."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the application resources."
  type        = string
}

variable "location" {
  description = "Azure region where the application resources are deployed."
  type        = string
}

variable "os_type" {
  description = "Operating system used by the App Service Plan."
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "SKU assigned to the App Service Plan."
  type        = string
  default     = "B1"
}

variable "frontend_name" {
  description = "Name of the frontend Azure Web App."
  type        = string
}

variable "backend_name" {
  description = "Name of the backend Azure Web App."
  type        = string
}

variable "app_service_subnet_id" {
  description = "Resource ID of the subnet used for regional VNet integration."
  type        = string
}

variable "frontend_identity_id" {
  description = "Resource ID of the frontend user-assigned managed identity."
  type        = string
}

variable "frontend_identity_client_id" {
  description = "Client ID of the frontend user-assigned managed identity."
  type        = string
}

variable "backend_identity_id" {
  description = "Resource ID of the backend user-assigned managed identity."
  type        = string
}

variable "backend_identity_client_id" {
  description = "Client ID of the backend user-assigned managed identity."
  type        = string
}

variable "registry_login_server" {
  description = "Login server of the Azure Container Registry."
  type        = string
}

variable "frontend_image_tag" {
  description = "Docker image tag deployed to the frontend Web App."
  type        = string
}

variable "backend_image_tag" {
  description = "Docker image tag deployed to the backend Web App."
  type        = string
}

variable "frontend_app_settings" {
  description = "Application settings assigned to the frontend Web App."
  type        = map(string)
}

variable "backend_app_settings" {
  description = "Application settings assigned to the backend Web App."
  type        = map(string)
}

variable "https_only" {
  description = "Whether the Web Apps accept HTTPS traffic only."
  type        = bool
  default     = true
}

variable "frontend_public_network_access_enabled" {
  description = "Whether public network access is enabled for the frontend."
  type        = bool
  default     = true
}

variable "backend_public_network_access_enabled" {
  description = "Whether public network access is enabled for the backend."
  type        = bool
  default     = false
}

variable "always_on" {
  description = "Whether App Service Always On is enabled."
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version accepted by the Web Apps."
  type        = string
  default     = "1.2"
}

variable "vnet_route_all_enabled" {
  description = "Whether all outbound application traffic is routed through the VNet."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the application resources."
  type        = map(string)
  default     = {}
}