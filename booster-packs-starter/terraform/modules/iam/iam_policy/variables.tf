variable "name" {
    description = "The name of the policy"
    type        = string
}

variable "path" {
    description = "The path of the policy"
    type        = string
    default     = "/"
}

variable "description" {
    description = "The description of the policy"
    type        = string
}

variable "policy" {
    description = "The policy document"
    type        = string
}

variable "groups" {
    description = "The list of IAM groups to attach the policy to"
    type        = list(string)
    default     = []
}

variable "users" {
    description = "The list of IAM users to attach the policy to"
    type        = list(string)
    default     = []
}

variable "roles" {
    description = "The list of IAM roles to attach the policy to"
    type        = list(string)
    default     = []
}

# Add a variable to control SSO resources creation
variable "enable_sso" {
    description = "Flag to enable/disable SSO resources"
    type        = bool
    default     = false
}


variable "permission_set_arn" {
    description = "The ARN of the permission set"
    type        = string
}


variable "principal_arn" {
    description = "The ARN of the principal"
    type        = string
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
    description = "The name of the IAM group"
    type        = string
}