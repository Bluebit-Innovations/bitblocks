
variable "name" {
  description = "The name of the IAM policy"
  type        = string
}

variable "path" {
  description = "The path for the IAM policy"
  type        = string
  default     = "/"
}

variable "description" {
  description = "The description of the IAM policy"
  type        = string
  default     = ""
}

variable "policy_json" {
  description = "The policy JSON document"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the policy"
  type        = map(string)
  default     = {}
}

variable "roles_to_attach" {
  description = "List of IAM role names to attach the policy to"
  type        = list(string)
  default     = []
}

variable "sso_instance_arn" {
  description = "The ARN of the SSO instance"
  type        = string
  default     = null
}

variable "sso_permission_set_arn" {
  description = "The ARN of the SSO permission set"
  type        = string
  default     = null
}

variable "sso_managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the SSO permission set"
  type        = list(string)
  default     = []
}

variable "enable_sso" {
  description = "Flag to enable or disable SSO-related resources"
  type        = bool
  default     = false
}

