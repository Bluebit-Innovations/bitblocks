# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This Terraform module creates and manages AWS IAM users with comprehensive security features:.
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------


# Example: IAM User Module (iam_user/main.tf)
resource "aws_iam_user" "this" {
  name = var.user_name
  path = var.user_path
}


# Create IAM user login profile if enabled
resource "aws_iam_user_login_profile" "this" {
    count                   = var.create_login_profile ? 1 : 0
    user                    = aws_iam_user.this.name
    pgp_key                = var.pgp_key
    password_length        = var.password_length
    password_reset_required = var.password_reset_required
}

# Create IAM access key if enabled
resource "aws_iam_access_key" "this" {
    count    = var.create_access_key ? 1 : 0
    user     = aws_iam_user.this.name
    pgp_key  = var.pgp_key
}


# Attach user to specified IAM groups
resource "aws_iam_user_group_membership" "this" {
    user   = aws_iam_user.this.name
    groups = var.iam_groups

    depends_on = [aws_iam_user.this]
}




resource "aws_s3_bucket" "trail_logs" {
    count         = var.enable_cloudtrail == true ? 1 : 0
    bucket        = "${var.user_name}-trail-logs-${var.environment}"
    force_destroy = true
    tags          = merge(var.tags, { Environment = var.environment })
}


# Logging and Auditing resources

# Enable IAM Access Analyzer
resource "aws_accessanalyzer_analyzer" "this" {
    count         = var.enable_access_analyzer == true ? 1 : 0
    analyzer_name = "${var.analyzer_name}-${local.environment}"
    type          = "ACCOUNT"
    tags          = local.default_tags
}

# Enable CloudTrail for IAM monitoring
resource "aws_cloudtrail" "iam_trail" {
    count                         = var.enable_cloudtrail == true ? 1 : 0
    name                         = "${var.cloudtrail_bucket_name}-trail-${local.environment}"
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
    count = var.enable_scp == true ? 1 : 0
    name  = "${var.scp_name}-scp-${local.environment}"
    content = jsonencode({
        Version = "2012-10-17"
        Statement = concat(
            var.environment == "global" ? local.global_restrictions : [],
            var.environment == "prod" ? local.prod_restrictions : [],
            var.environment == "staging" ? local.staging_restrictions : [],
            var.environment == "dev" ? local.dev_restrictions : []
        )
    })
}