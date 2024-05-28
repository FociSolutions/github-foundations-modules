#Resource Group Variables
variable "rg_create" {
  description = "Create resource group. When set to false, uses id to reference an existing resource group."
  type        = bool
  default     = true
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group to create the github foundation azure resources in."
}

variable "rg_location" {
  type        = string
  description = "The location of the resource group to create the github foundation azure resources in."
}

#Storage Variables
variable "sa_name" {
  type        = string
  description = "The name of the storage account for github foundations."
}

variable "sa_tier" {
  type        = string
  description = "The tier of the storage account for github foundations. Valid options are Standard and Premium."
}

variable "sa_replication_type" {
  type        = string
  description = "The replication type of the storage account for github foundations. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, and RA_GZRS."
}

variable "tf_state_container" {
  type        = string
  description = "The name of the container to store the terraform state file(s) in."
  default     = "tfstate"
}

variable "tf_state_container_anonymous_access_level" {
  type        = string
  description = "The anonymous access level of the container to store the terraform state file(s) in."
  default     = "private"
}

variable "tf_state_container_encryption_scope_override_enabled" {
  type        = bool
  description = "Whether or not the encryption scope override is enabled for the container to store the terraform state file(s) in. Defaults to false"
  default     = false
}

variable "tf_state_container_default_encryption_scope" {
  type = object({
    name             = string
    source           = string
    key_vault_key_id = optional(string)
  })
  description = "The default encryption scope of the container to store the terraform state file(s) in."
  default = {
    name               = ""
    source             = ""
    storage_account_id = ""
  }
  validation {
    condition     = var.name == "" || var.tf_state_container_default_encryption_scope.source != "Microsoft.KeyVault" || (var.tf_state_container_default_encryption_scope.source == "Microsoft.KeyVault" && var.tf_state_container_default_encryption_scope.key_vault_key_id == null)
    error_message = "Key vault key id must be set when source is \"Microsoft.KeyVault\"."
  }
}

#Key Vault Variables
variable "kv_name" {
  type        = string
  description = "The name of the key vault to use for github foundation secrets."
}

variable "kv_resource_group" {
  type        = string
  description = "The name of the resource group that the key vault is in. If empty it will default to the github foundations resource group."
}

#Federated Identity Credentials Varialbes

variable "github_foundations_organization_name" {
  type        = string
  description = "The name of the organization that the github foundation repos will be under."
}

variable "drift_detection_branch_name" {
  type        = string
  description = "The name of the branch to use for drift detection."
}