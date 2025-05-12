
variable "role_name" {
    type        = string
    description = "Name of the IAM role"
}

variable "assume_role_policy" {
    type        = string
    description = "JSON encoded assume role policy"
}

variable "policy_arns" {
    type        = list(string)
    description = "List of policy ARNs to attach to the role"
    default     = []
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

