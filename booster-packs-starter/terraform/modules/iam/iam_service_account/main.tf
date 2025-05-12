# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This Terraform module creates and manages AWS IAM roles with comprehensive security
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------




resource "aws_iam_role" "this" {
    name               = var.service_account_name
    description        = var.service_account_description
    assume_role_policy = var.assume_role_policy
}

# Attach AWS managed policies to the role
resource "aws_iam_role_policy_attachment" "managed_policy" {
    count = length(var.service_account_policy_arns)

    role       = aws_iam_role.this.name
    policy_arn = var.service_account_policy_arns[count.index]
}


# Create AWS SSO permission set for the service account
resource "aws_ssoadmin_permission_set" "this" {
    count         = var.create_sso_permission_set ? 1 : 0
    name          = var.ssoadmin_permission_set_name
    description   = var.ssoadmin_permission_set_description
    instance_arn  = var.sso_instance_arn
    session_duration = "PT1H"
    }

    # Attach AWS managed policies to the SSO permission set
    resource "aws_ssoadmin_managed_policy_attachment" "this" {
    count              = var.create_sso_permission_set ? length(var.service_account_policy_arns) : 0
    instance_arn       = var.sso_instance_arn
    managed_policy_arn = var.service_account_policy_arns[count.index]
    permission_set_arn = var.create_sso_permission_set ? aws_ssoadmin_permission_set.this[0].arn : null
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
