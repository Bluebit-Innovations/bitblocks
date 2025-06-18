variable "key_description" {
  description = "Description of the KMS key."
  type        = string
  default     = "Managed by Terraform"
}

variable "alias_name" {
  description = "Name of the KMS alias (without 'alias/' prefix)."
  type        = string
}

variable "deletion_window_in_days" {
  description = "Days before deletion after key is scheduled for deletion."
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation."
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "Whether the key is enabled."
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Enable multi-region key."
  type        = bool
  default     = false
}

variable "key_policy" {
  description = "The key policy in JSON format."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "create_grants" {
  description = "Whether to create KMS grants."
  type        = bool
  default     = false
}

variable "grants" {
  description = "List of grant definitions."
  type = list(object({
    name                     = string
    grantee_principal        = string
    operations               = list(string)
    encryption_context_equals = map(string)
  }))
  default = []
}
