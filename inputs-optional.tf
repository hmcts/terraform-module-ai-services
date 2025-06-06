variable "existing_resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  default     = ""
  description = "The default name will be product+component+env, you can override the product+component part by setting this"
}

variable "cognitive_account_sku" {
  description = "SKU of cognitive account"
  type        = string
  default     = "F0"
}

variable "ip_rules" {
  description = "IP rules for the resources"
  default     = []
}

variable "vm_size" {
  description = "Size of the VM for the compute cluster"
  type        = string
  default     = "Standard_D2ds_v5"
}

variable "vm_priority" {
  description = "Priority of the VM for the compute cluster"
  type        = string
  default     = "LowPriority"
}

variable "min_node_count" {
  description = "Minimum number of nodes in the compute cluster"
  type        = number
  default     = 0
}

variable "max_node_count" {
  description = "Maximum number of nodes in the compute cluster"
  type        = number
  default     = 1
}
variable "scaledown_idle_duration" {
  description = "Duration to scale down the compute cluster after idle"
  type        = string
  default     = "PT30S"
}

variable "public_network_access_foundry" {
  description = "Public network access for the resource"
  type        = string
  default     = "Enabled"
}

variable "public_network_access_cognitive" {
  description = "Public network access for cognitive account"
  type        = bool
  default     = true
}

variable "public_network_access_ml" {
  description = "Public network access for ML workspace"
  type        = bool
  default     = true
}

variable "ai_project_name_override" {
  description = "value to override the project name"
  type        = string
  default     = null
}

variable "instances" {
  type        = number
  default     = 0
  description = "The number of compute instances to deploy"
}

variable "files_storage_account_id" {
  description = "ID of existing storage account where files to be processed are stored"
  type        = string
  default     = null
}

variable "workspace_storage_account_tier" {
  description = "Tier of the workspace storage account"
  type        = string
  default     = "Standard"
}
variable "workspace_storage_account_replication_type" {
  description = "Replication type of the workspace storage account"
  type        = string
  default     = "ZRS"
}

variable "sa_subnets" {
  type        = list(string)
  description = "(Optional) List of subnet ID's which will have access to this storage account."
  default     = []
}

variable "default_action" {
  description = "(Optional) Network rules default action"
  default     = "Allow"
}