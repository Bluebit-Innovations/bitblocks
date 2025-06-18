variable "name" {
  description = "Name of the IAM service account role"
  type        = string
}

variable "assume_role_policy" {
  description = "IAM Assume Role Policy JSON"
  type        = string
}

variable "managed_policy_arns" {
  description = "List of AWS managed or custom managed policy ARNs"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policies to attach to the role"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to attach to the IAM role"
  type        = map(string)
  default     = {}
}

variable "permissions_boundary" {
  description = "Optional IAM permission boundary to attach"
  type        = string
  default     = null
}
