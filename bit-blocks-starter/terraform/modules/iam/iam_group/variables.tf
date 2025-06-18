variable "group_name" {
  description = "The name of the IAM group"
  type        = string
}

variable "group_description" {
  description = "Description of the IAM group"
  type        = string
  
}

variable "group_users" {
  description = "List of IAM users to add to the group"
  type        = list(string)
}

variable "enable_inline_policies" {
  description = "Flag to enable/disable inline policies"
  type        = bool
  default     = false
}

variable "enable_managed_policies" {
  description = "Flag to enable/disable managed policies"
  type        = bool
  default     = false
}

variable "group_path" {
  description = "The path of the IAM group"
  type        = string
}

variable "inline_policies" {
  description = "List of inline policies to attach to the group"
  type        = list(string)
  default = [ "" ]
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the group"
  type        = list(string)
}




variable "tags" {
    description = "A map of tags to assign to the resources"
    type        = map(string)
    default     = {}
}