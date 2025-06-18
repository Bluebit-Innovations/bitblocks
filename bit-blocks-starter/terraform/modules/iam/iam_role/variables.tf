variable "name" {
  description = "Name of the IAM Role"
  type        = string
}

variable "path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "max_session_duration" {
  description = "Max session duration in seconds"
  type        = number
  default     = 3600
}

variable "permissions_boundary" {
  description = "ARN of the permissions boundary policy"
  type        = string
  default     = null
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "List of inline policies (name + JSON)"
  type = list(object({
    name   = string
    policy = string
  }))
  default = []
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = false
}

variable "assume_role_principal_type" {
  description = "Type of principal to assume the role (e.g., Service, AWS, Federated)"
  type        = string
  default     = "Service"
}

variable "assume_role_principal_identifiers" {
  description = "List of principal ARNs or identifiers allowed to assume the role"
  type        = list(string)
}

variable "assume_role_conditions" {
  description = "Optional list of condition blocks for the assume role policy"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}
