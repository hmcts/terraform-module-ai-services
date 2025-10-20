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

variable "existing_cognitive_account_name" {
  description = "Name of existing cognitive account to use"
  type        = string
  default     = null
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

variable "compute_instance_public_ip_enabled" {
  description = "Enable public IP for compute instances"
  type        = bool
  default     = false
}

variable "enable_managed_network" {
  description = "Enable managed network for ai resources"
  type        = bool
  default     = false
}

variable "managed_network_isolation_mode" {
  description = "Set the network mode when using managed network"
  type        = string
  default     = "AllowInternetOutbound"
}

variable "create_cognitive_account" {
  description = "Create cognitive account resource"
  type        = bool
  default     = false
}

variable "create_ml_workspace" {
  description = "Create machine learning workspace resource"
  type        = bool
  default     = false
}

variable "storage_account_name_override" {
  type    = string
  default = null
}

variable "cognitive_deployment" {
  description = "Configuration for cognitive deployment. Should be a map containing deployment-specific settings."
  type = object({
    name          = optional(string)
    model_name    = optional(string)
    model_version = optional(string)
    model_format  = optional(string)
    sku_name      = optional(string)
    sku_capacity  = optional(number)
  })
  default = {
    name          = "my-openai-deployment"
    model_name    = "gpt-5-mini"
    model_version = "2025-08-07"
    model_format  = "OpenAI"
    sku_name      = "GlobalStandard"
    sku_capacity  = 1
  }
}