variable "user_name" {
  description = "The name of the IAM user"
  type        = string
}

variable "user_path" {
  description = "The path for the IAM user"
  type        = string
  default     = "/"
}

variable "environment" {
    description = "Environment (dev/staging/prod)"
    type        = string
    validation {
        condition     = contains(["dev", "staging", "prod", "global"], var.environment)
        error_message = "Environment must be dev, staging, or prod."
    }
}

variable "create_login_profile" {
    description = "Create IAM user login profile"
    type        = bool
    default     = false
}

variable "create_access_key" {
    description = "Create IAM access key"
    type        = bool
    default     = false
}

variable "pgp_key" {
    description = "PGP key to encrypt the password and access key"
    type        = string
    default     = ""
}

variable "password_length" {
    description = "The length of the password"
    type        = number
    default     = 16
}

variable "password_reset_required" {
    description = "Require password reset on first login"
    type        = bool
    default     = true
}


variable "iam_groups" {
    description = "List of IAM groups to attach the user to"
    type        = list(string)
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
    default     = "cloudtrail_bucket"
}

variable "enable_scp" {
    description = "Flag to enable/disable Service Control Policies"
    type        = bool
    default     = false
}

variable "scp_name" {
    description = "Name of the Service Control Policy"
    type        = string
    default = "scp_user_policy"
  
}

variable "tags" {
    description = "A map of tags to assign to the resources"
    type        = map(string)
    default     = {}
}

variable "analyzer_name" {
    description = "Name of the Analyzer to be created in AWS Access Analyzer"
    type        = string
    default     = "access-analyzer"
}

