#############################
# main.tf
#############################

# AWS Config Recorder
resource "aws_config_configuration_recorder" "this" {
  count    = var.enable_config ? 1 : 0
  name     = "config-recorder"
  role_arn = var.config_role_arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "this" {
  count          = var.enable_config ? 1 : 0
  name           = "config-delivery-channel"
  s3_bucket_name = var.config_bucket_name
  depends_on     = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  count      = var.enable_config ? 1 : 0
  name       = aws_config_configuration_recorder.this[0].name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}

# AWS GuardDuty
resource "aws_guardduty_detector" "this" {
  count  = var.enable_guardduty ? 1 : 0
  enable = true
}

# AWS Security Hub
resource "aws_securityhub_account" "this" {
  count = var.enable_security_hub ? 1 : 0
}

resource "aws_securityhub_standards_subscription" "this" {
  for_each     = var.enable_security_hub ? toset(var.security_hub_standards) : []
  standards_arn = "arn:aws:securityhub:::ruleset/${each.value}/v/1.0.0"
  depends_on    = [aws_securityhub_account.this]
}

# AWS Config Aggregator
resource "aws_config_configuration_aggregator" "org_aggregator" {
  count = var.enable_aggregator ? 1 : 0
  name  = "org-aggregator"

  organization_aggregation_source {
    all_regions = var.enable_cross_region_agg
    role_arn    = var.aggregator_role_arn
  }
}

# Delegated Admin Setup
resource "aws_securityhub_organization_admin_account" "this" {
  count            = var.assign_delegated_admin && var.enable_security_hub ? 1 : 0
  admin_account_id = var.aggregator_account_id
}

resource "aws_guardduty_organization_admin_account" "this" {
  count            = var.assign_delegated_admin && var.enable_guardduty ? 1 : 0
  admin_account_id = var.aggregator_account_id
}

# Optional: S3 Lifecycle Rules for Config logs
resource "aws_s3_bucket_lifecycle_configuration" "log_lifecycle" {
  count  = var.enable_log_archive && var.log_bucket_name != null ? 1 : 0
  bucket = var.log_bucket_name

  rule {
    id     = "ArchiveConfigLogs"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}

# Optional: SNS Notifications for audit events
resource "aws_sns_topic_subscription" "audit_notify" {
  count     = var.enable_sns_notify && var.sns_topic_arn != null ? 1 : 0
  topic_arn = var.sns_topic_arn
  protocol  = "email"
  endpoint  = var.alert_email
}