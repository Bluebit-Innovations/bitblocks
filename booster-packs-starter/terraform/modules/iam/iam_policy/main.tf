# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This module creates and manages AWS IAM policies with comprehensive security controls
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------

# IAM Policy resource
resource "aws_iam_policy" "this" {
    name        = var.name
    path        = var.path
    description = var.description
    policy      = var.policy
}

# IAM Policy Attachment resource
resource "aws_iam_policy_attachment" "this" {
    name       = "${var.name}-attachment"
    policy_arn = aws_iam_policy.this.arn
    groups     = var.groups
    users      = var.users
    roles      = var.roles
}


# SSO Policy Attachment resource

resource "aws_ssoadmin_permission_set_policy_attachment" "this" {
    count = var.enable_sso ? 1 : 0

    permission_set_arn = var.permission_set_arn
    policy_arn        = aws_iam_policy.this.arn
    principal_arn     = var.principal_arn
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