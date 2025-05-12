# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This module provides comprehensive IAM Single Sign-On (SSO) management in AWS.
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------


# # Example: IAM SSO Module (iam_sso/main.tf)
# resource "aws_ssoadmin_group" "this" {
#   name = var.sso_group_name
# }

# Permission Sets
resource "aws_ssoadmin_permission_set" "this" {
    for_each = var.permission_sets

    name             = each.key
    description      = each.value.description
    instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
    session_duration = each.value.session_duration
}

# Attach managed policies to permission sets
resource "aws_ssoadmin_managed_policy_attachment" "this" {
    for_each = {
        for policy in local.flattened_policies : "${policy.name}-${policy.policy_arn}" => policy
    }

    instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
    permission_set_arn = aws_ssoadmin_permission_set.this[each.value.name].arn
    managed_policy_arn = each.value.policy_arn
}

# Account assignments
resource "aws_ssoadmin_account_assignment" "this" {
    for_each = var.account_assignments

    instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
    permission_set_arn = each.value.permission_set_arn
    principal_id       = each.value.principal_id
    principal_type     = each.value.principal_type
    target_id          = each.value.account_id
    target_type        = "AWS_ACCOUNT"
}

# Data source for SSO instance
data "aws_ssoadmin_instances" "this" {}


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