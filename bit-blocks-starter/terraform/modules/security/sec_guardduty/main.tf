
# data "aws_caller_identity" "current" {}

resource "aws_guardduty_detector" "this" {
  for_each = var.enabled ? toset(var.regions) : toset([])

  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"

  datasources {
    s3_logs {
      enable = true
    }

    kubernetes {
      audit_logs {
        enable = true
      }
    }

    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_guardduty_organization_admin_account" "this" {
  count             = var.enable_organization_admin ? 1 : 0
  admin_account_id  = var.admin_account_id
}

resource "aws_guardduty_publishing_destination" "this" {
  count = var.kms_key_arn != null && var.sns_topic_arn != null ? length(var.regions) : 0

  detector_id     = aws_guardduty_detector.this[element(var.regions, count.index)].id
  destination_arn = var.sns_topic_arn
  kms_key_arn     = var.kms_key_arn
  destination_type = "S3"
}
