resource "aws_securityhub_account" "main" {
  count = var.enable_securityhub ? 1 : 0
}

resource "aws_securityhub_standards_subscription" "cis" {
  count         = var.enable_securityhub && var.enable_cis_standard ? 1 : 0
  standards_arn = "arn:aws:securityhub:::standards/cis-aws-foundations-benchmark/v/1.4.0"
}

resource "aws_securityhub_finding_aggregator" "aggregator" {
  count               = var.enable_aggregator ? 1 : 0
  linking_mode        = "ALL_REGIONS"
}

resource "aws_securityhub_member" "members" {
  for_each   = var.member_accounts
  account_id = each.key
  email      = each.value
  invite     = true
}

resource "aws_securityhub_product_subscription" "third_party_products" {
  for_each    = var.enable_third_party_products ? toset(var.third_party_product_arns) : []
  product_arn = each.value
}

resource "aws_cloudwatch_event_rule" "securityhub_findings" {
  count        = var.enable_eventbridge ? 1 : 0
  name         = "SecurityHubFindingsRule"
  description  = "Forward SecurityHub findings to EventBridge target"
  event_pattern = jsonencode({
    source      = ["aws.securityhub"],
    detail-type = ["Security Hub Findings - Imported"]
  })
}

resource "aws_cloudwatch_event_target" "eventbridge_target" {
  count     = var.enable_eventbridge ? 1 : 0
  rule      = aws_cloudwatch_event_rule.securityhub_findings[0].name
  target_id = "SendToTarget"
  arn       = var.findings_target_arn
}

# Optional: AWS Config
resource "aws_config_configuration_recorder" "default" {
  count        = var.enable_aws_config ? 1 : 0
  name         = "default"
  role_arn     = var.config_role_arn
  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "default" {
  count           = var.enable_aws_config ? 1 : 0
  name            = "default"
  s3_bucket_name  = aws_s3_bucket.config_snapshot[0].bucket
  snapshot_delivery_properties {
    delivery_frequency = "TwentyFour_Hours"
  }
  depends_on = [aws_config_configuration_recorder.default]
}

resource "aws_config_configuration_recorder_status" "default" {
  count                 = var.enable_aws_config ? 1 : 0
  name                  = aws_config_configuration_recorder.default[0].name
  is_enabled            = true
  depends_on            = [aws_config_delivery_channel.default]
}

# Optional: S3 bucket for archival
resource "aws_s3_bucket" "config_snapshot" {
  count  = var.enable_aws_config ? 1 : 0
  bucket = var.config_snapshot_bucket_name

  lifecycle_rule {
    enabled = true

    transition {
      days          = var.snapshot_transition_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.snapshot_expiration_days
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "aws-config-snapshot-archive"
    Environment = "compliance"
  }
}
