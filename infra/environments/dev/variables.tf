variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "location" {
  description = "Primary Azure region."
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Short project name."
  type        = string
  default     = "azrp"
}

variable "name_suffix" {
  description = "Globally unique suffix."
  type        = string
}

variable "frontend_image_tag" {
  description = "Frontend container tag."
  type        = string
  default     = "latest"
}

variable "backend_image_tag" {
  description = "Backend container tag."
  type        = string
  default     = "latest"
}

variable "alert_email" {
  description = "Email that receives Azure Monitor alerts."
  type        = string
}