variable "identity_center_instance_arn" {
  type        = string
  description = "The ARN of the AWS IAM Identity Center instance"
}

variable "permission_sets" {
  description = "Map of permission sets to create"
  type = map(object({
    description       = string
    session_duration  = string
    relay_state       = optional(string)
    managed_policies  = list(string)
  }))
}

variable "assignments" {
  description = "Map of IAM Identity Center assignments"
  type = map(object({
    permission_set     = string
    principal_id       = string
    principal_type     = string
    target_account_id  = string
  }))
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to permission sets"
}
