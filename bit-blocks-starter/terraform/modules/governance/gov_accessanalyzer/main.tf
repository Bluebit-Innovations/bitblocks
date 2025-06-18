# Resource to create an AWS Access Analyzer
resource "aws_accessanalyzer_analyzer" "this" {
    count         = var.enabled ? 1 : 0
    analyzer_name = var.analyzer_name
    type          = var.analyzer_type
    tags          = var.tags
}

# Resource to create an archive rule for the Access Analyzer
resource "aws_accessanalyzer_archive_rule" "this" {
    count         = var.enable_archive_rule && var.enabled ? 1 : 0
    analyzer_name = aws_accessanalyzer_analyzer.this[0].analyzer_name
    rule_name     = var.archive_rule_name

    # Dynamic block to define filters for the archive rule
    dynamic "filter" {
        for_each = var.archive_filters
        content {
            criteria = filter.value.criteria
            eq       = filter.value.eq
        }
    }
}

# Resource to create an SNS topic for alerts
resource "aws_sns_topic" "this" {
    count = var.enable_sns_alerts && var.enabled ? 1 : 0
    name  = var.sns_topic_name
}

# Resource to create an email subscription for the SNS topic
resource "aws_sns_topic_subscription" "email" {
    count     = var.enable_sns_alerts && var.enabled ? 1 : 0
    topic_arn = aws_sns_topic.this[0].arn
    protocol  = "email"
    endpoint  = var.alert_email
}

# Resource to create a CloudWatch Event Rule for Access Analyzer findings
resource "aws_cloudwatch_event_rule" "access_analyzer_findings" {
    count         = var.enable_sns_alerts && var.enabled ? 1 : 0
    name          = "access-analyzer-findings"
    description   = "Capture IAM Access Analyzer findings"
    event_pattern = jsonencode({
        source      = ["aws.access-analyzer"],
        "detail-type" = ["Access Analyzer Finding"]
    })
}

# Resource to create a CloudWatch Event Target to send findings to SNS
resource "aws_cloudwatch_event_target" "send_to_sns" {
    count     = var.enable_sns_alerts && var.enabled ? 1 : 0
    rule      = aws_cloudwatch_event_rule.access_analyzer_findings[0].name
    target_id = "sns"
    arn       = aws_sns_topic.this[0].arn
}

# Resource to create an IAM Role for AWS Config
resource "aws_iam_role" "config_role" {
    count = var.enable_aws_config && var.enabled ? 1 : 0

    name = "config-recorder-role"

    # Trust policy for AWS Config to assume the role
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Action = "sts:AssumeRole",
            Principal = {
                Service = "config.amazonaws.com"
            },
            Effect = "Allow",
            Sid    = ""
        }]
    })
}

# Resource to create an S3 bucket for AWS Config logs
resource "aws_s3_bucket" "config_logs" {
    count = var.enable_aws_config && var.enabled ? 1 : 0
    bucket = var.config_bucket_name
}

# Resource to create an AWS Config Configuration Recorder
resource "aws_config_configuration_recorder" "this" {
    count    = var.enable_aws_config && var.enabled ? 1 : 0
    name     = "config"
    role_arn = aws_iam_role.config_role[0].arn
}

# Resource to create an AWS Config Delivery Channel
resource "aws_config_delivery_channel" "this" {
    count           = var.enable_aws_config && var.enabled ? 1 : 0
    name            = "default"
    s3_bucket_name  = aws_s3_bucket.config_logs[0].bucket
    depends_on      = [aws_config_configuration_recorder.this]
}

# Resource to create an AWS Config Rule to block public read access to S3 buckets
resource "aws_config_config_rule" "s3_public_block" {
    count = var.enable_aws_config && var.enabled ? 1 : 0
    name  = "s3-bucket-public-read-prohibited"
    source {
        owner             = "AWS"
        source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
    }
}
