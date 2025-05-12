# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This module creates and manages AWS IAM roles with comprehensive security features
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------



# Example: IAM Role Module (iam_roles/main.tf)
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "this" {
    count = length(var.policy_arns)

    role       = aws_iam_role.this.name
    policy_arn = var.policy_arns[count.index]
}


# Logging and Auditing resources

# Enable IAM Access Analyzer
resource "aws_accessanalyzer_analyzer" "this" {
    count         = var.enable_access_analyzer ? 1 : 0
    analyzer_name = "${var.group_name}-analyzer-${local.environment}"
    type          = "ACCOUNT"
    tags          = local.default_tags
}

# Enable CloudTrail for IAM monitoring
resource "aws_cloudtrail" "iam_trail" {
    count                         = var.enable_cloudtrail ? 1 : 0
    name                         = "${var.group_name}-trail-${local.environment}"
    s3_bucket_name              = var.cloudtrail_bucket_name
    include_global_service_events = true
    is_multi_region_trail        = true
    
    event_selector {
        read_write_type           = "All"
        include_management_events = true
    }
    
    tags = local.default_tags
}

# Service control policies for environment-specific restrictions
resource "aws_organizations_policy" "env_restrictions" {
    count = var.enable_scp ? 1 : 0
    name  = "${var.group_name}-scp-${local.environment}"
    content = jsonencode({
        Version = "2012-10-17"
        Statement = concat(
            var.environment == "prod" ? local.prod_restrictions : [],
            var.environment == "staging" ? local.staging_restrictions : [],
            var.environment == "dev" ? local.dev_restrictions : []
        )
    })
}