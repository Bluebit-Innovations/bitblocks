# Enforce EBS Snapshot Encryption via IAM Policy
resource "aws_iam_policy" "snapshot_encryption_policy" {
  name        = "${var.name_prefix}-snapshot-encryption"
  path        = "/"
  description = "Policy enforcing EBS snapshot encryption."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Deny",
      Action = [
        "ec2:CreateSnapshot",
        "ec2:CreateSnapshots"
      ],
      Resource = "*",
      Condition = {
        StringNotEqualsIfExists = {
          "ec2:Encrypted" = "true"
        }
      }
    }]
  })
}

# CloudWatch Event Rule for Detecting Public Snapshots
resource "aws_cloudwatch_event_rule" "public_snapshot_alert" {
  name          = "${var.name_prefix}-public-snapshot-alert"
  description   = "Alerts on creation or modification of public EBS snapshots."
  event_pattern = jsonencode({
    source      = ["aws.ec2"],
    "detail-type" = ["AWS API Call via CloudTrail"],
    detail = {
      eventSource = ["ec2.amazonaws.com"],
      eventName   = ["ModifySnapshotAttribute"],
      requestParameters = {
        attributeType = ["createVolumePermission"],
        operationType = ["add"]
      }
    }
  })
}

# SNS Topic for Alerts
resource "aws_sns_topic" "snapshot_alerts_topic" {
  name = "${var.name_prefix}-snapshot-alerts"
}

# CloudWatch Event Target (SNS)
resource "aws_cloudwatch_event_target" "sns_alert" {
  rule      = aws_cloudwatch_event_rule.public_snapshot_alert.name
  target_id = "SnapshotAlertSNS"
  arn       = aws_sns_topic.snapshot_alerts_topic.arn
}

# SNS Subscription (optional email alerts)
resource "aws_sns_topic_subscription" "alert_email" {
  count     = length(var.alert_emails)
  topic_arn = aws_sns_topic.snapshot_alerts_topic.arn
  protocol  = "email"
  endpoint  = var.alert_emails[count.index]
}

# Lifecycle policy for snapshot retention and deletion
resource "aws_dlm_lifecycle_policy" "snapshot_retention_policy" {
  description        = "EBS Snapshot retention and auto-deletion"
  execution_role_arn = aws_iam_role.dlm_role.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]
    target_tags = {
      SnapshotManaged = "true"
    }
    schedule {
      name = "DailySnapshotRetention"
      create_rule {
        interval      = var.retention_interval
        interval_unit = "HOURS"
        times         = [var.snapshot_time]  # Only one time allowed
      }
      retain_rule {
        count = var.retention_count
      }
      copy_tags = true
    }
  }
}

# IAM role for DLM
resource "aws_iam_role" "dlm_role" {
  name = "${var.name_prefix}-dlm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "dlm.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach IAM policy to DLM role
resource "aws_iam_role_policy_attachment" "dlm_policy_attachment" {
  role       = aws_iam_role.dlm_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataLifecycleManagerServiceRole"
}
