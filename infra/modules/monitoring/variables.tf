variable "log_analytics_workspace_name" {
  description = "Name of the Azure Log Analytics Workspace."
  type        = string
}

variable "application_insights_name" {
  description = "Name of the Azure Application Insights component."
  type        = string
}

variable "action_group_name" {
  description = "Name of the Azure Monitor Action Group."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group containing the monitoring resources."
  type        = string
}

variable "location" {
  description = "Azure region where the monitoring resources are deployed."
  type        = string
}

variable "log_analytics_sku" {
  description = "SKU assigned to the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_in_days" {
  description = "Number of days that Log Analytics data is retained."
  type        = number
  default     = 30
}

variable "log_analytics_daily_quota_gb" {
  description = "Daily ingestion quota for the Log Analytics Workspace in GB."
  type        = number
  default     = 0.5
}

variable "application_type" {
  description = "Type of application monitored by Application Insights."
  type        = string
  default     = "web"
}

variable "action_group_short_name" {
  description = "Short name of the Azure Monitor Action Group."
  type        = string
  default     = "azrpalerts"
}

variable "email_receiver_name" {
  description = "Name assigned to the Action Group email receiver."
  type        = string
  default     = "portfolio-owner"
}

variable "alert_email" {
  description = "Email address that receives Azure Monitor alerts."
  type        = string
}

variable "use_common_alert_schema" {
  description = "Whether the email receiver uses the Azure common alert schema."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the monitoring resources."
  type        = map(string)
  default     = {}
}