locals {
  prefix = "${var.project_name}-${var.environment}"

  resource_group_name = "rg-${var.project_name}-platform-${var.environment}-${var.name_suffix}"
  vnet_name           = "vnet-${local.prefix}-${var.name_suffix}"
  service_plan_name   = "asp-${local.prefix}-${var.name_suffix}"

  frontend_name = "app-${var.project_name}-front-${var.environment}-${var.name_suffix}"
  backend_name  = "app-${var.project_name}-back-${var.environment}-${var.name_suffix}"

  acr_name     = lower("acr${var.project_name}${var.environment}${var.name_suffix}")
  storage_name = lower("st${var.project_name}${var.environment}${var.name_suffix}")
  key_vault    = lower("kv-${local.prefix}-${var.name_suffix}")

  common_tags = {
    Project     = "AzureProductionReadyPlatform"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Abelardo Videche"
    Portfolio   = "True"
  }
}