# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This module creates and manages AWS IAM groups with associated policies and memberships
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------

# IAM Group Module (iam_group/main.tf)

resource "aws_iam_group" "this" {
    name = var.group_name
    path = var.group_path
}

resource "aws_iam_group_membership" "this" {
    name  = "${var.group_name}-membership"
    group = aws_iam_group.this.name
    users = var.group_users
}

resource "aws_iam_group_policy" "this" {
    count  = var.enable_inline_policies ? length(var.inline_policies) : 0
    name   = "${var.group_name}-policy-${count.index}"
    group  = aws_iam_group.this.name
    policy = var.inline_policies[count.index]
}

resource "aws_iam_group_policy_attachment" "this" {
    count      = var.enable_managed_policies ? length(var.managed_policy_arns) : 0
    group      = aws_iam_group.this.name
    policy_arn = var.managed_policy_arns[count.index]
}


# Note: Some of the requested outputs might not be directly available
# as AWS doesn't provide certain functionalities natively


# Logging & auditing integration 
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