variable "sso_group_name" {
  description = "The name of the SSO group"
  type        = string
}

# Variables
variable "permission_sets" {
    description = "Map of permission sets to create"
    type = map(object({
        description      = string
        session_duration = string
        managed_policies = list(string)
    }))
}

variable "account_assignments" {
    description = "Map of account assignments to create"
    type = map(object({
        account_id         = string
        permission_set_arn = string
        principal_id       = string
        principal_type     = string
    }))
}



# Add a variable to control Access Analyzer resources creation
variable "enable_access_analyzer" {
    description = "Flag to enable/disable IAM Access Analyzer"
    type        = bool
    default     = false
}

variable "enable_cloudtrail" {
    description = "Flag to enable/disable CloudTrail monitoring"
    type        = bool
    default     = false
}

variable "cloudtrail_bucket_name" {
    description = "Name of the S3 bucket for CloudTrail logs"
    type        = string
}

variable "enable_scp" {
    description = "Flag to enable/disable Service Control Policies"
    type        = bool
    default     = false
}

variable "environment" {
    description = "Environment name (prod, staging, dev)"
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the resources"
    type        = map(string)
    default     = {}
}

variable "group_name" {
    description = "Name of the IAM group"
    type        = string
}

