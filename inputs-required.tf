variable "env" {
  description = "Environment value"
  type        = string
}

variable "common_tags" {
  description = "Common tag to be applied to resources"
  type        = map(string)
}

variable "product" {
  description = "https://hmcts.github.io/glossary/#product"
  type        = string
}

variable "project" {
  description = "Project name - sds or cft."
}

variable "component" {
  description = "https://hmcts.github.io/glossary/#component"
  type        = string
}

variable "storage_account_id" {
  description = "ID of existing storage account"
  type        = string
}

variable "key_vault_id" {
  description = "ID of existing key vault"
  type        = string
}

variable "application_insights_id" {
  description = "ID of existing application insights"
  type        = string
}

variable "cognitive_account_kind" {
  description = "Kind of cognitive account"
  type        = string
}

variable "subnet_id" {
  description = "ID of existing subnet for the private endpoint"
  type        = string
}