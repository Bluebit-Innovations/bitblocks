resource "aws_s3_bucket" "cloudtrail_logs" {
  count  = var.enable_trail && var.create_s3_bucket ? 1 : 0
  bucket = var.s3_bucket_name

  force_destroy = true

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "cloudtrail_logs" {
  count  = var.enable_trail && var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
  count  = var.enable_trail && var.create_s3_bucket ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_logs" {
  count  = var.enable_trail && var.create_s3_bucket && var.enable_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  rule {
    id     = "log-archive"
    status = "Enabled"

    filter {
      prefix = "" # Required: Applies rule to all objects
        }  

    transition {
      days          = var.archive_after_days
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      newer_noncurrent_versions = 1
      noncurrent_days           = var.archive_after_days
      storage_class             = "GLACIER"
    }

    expiration {
      days = 3650
    }
  }
}


resource "aws_s3_bucket_policy" "cloudtrail" {
  count = var.enable_trail && var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:GetBucketAcl",
        Resource  = "${aws_s3_bucket.cloudtrail_logs[0].arn}"
      },
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.cloudtrail_logs[0].arn}/AWSLogs/${var.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  count = var.enable_trail && var.enable_cloudwatch ? 1 : 0

  name              = var.cloudwatch_log_group_name
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_iam_role" "cloudtrail_cloudwatch" {
  count = var.enable_trail && var.enable_cloudwatch ? 1 : 0

  name = "cloudtrail-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "cloudtrail.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch" {
  count      = var.enable_trail && var.enable_cloudwatch ? 1 : 0
  role       = aws_iam_role.cloudtrail_cloudwatch[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCloudTrailLoggingPolicy"
}

resource "aws_kms_key" "cloudtrail" {
  count               = var.enable_trail && var.create_kms_key ? 1 : 0
  description         = "KMS key for CloudTrail log encryption"
  enable_key_rotation = true
  tags                = var.tags
}

resource "aws_kms_alias" "cloudtrail" {
  count        = var.enable_trail && var.create_kms_key ? 1 : 0
  name         = "alias/cloudtrail-logs"
  target_key_id = aws_kms_key.cloudtrail[0].key_id
}

resource "aws_cloudtrail" "this" {
  count                         = var.enable_trail ? 1 : 0
  name                          = var.trail_name
  s3_bucket_name                = var.s3_bucket_name
  include_global_service_events = true
  is_multi_region_trail         = var.is_multi_region_trail
  enable_log_file_validation    = true
  kms_key_id                    = var.create_kms_key ? aws_kms_key.cloudtrail[0].arn : var.kms_key_id
  cloud_watch_logs_role_arn     = var.enable_cloudwatch ? aws_iam_role.cloudtrail_cloudwatch[0].arn : null
  cloud_watch_logs_group_arn    = var.enable_cloudwatch ? aws_cloudwatch_log_group.cloudtrail[0].arn : null
  is_organization_trail         = var.is_organization_trail
  tags                          = var.tags

  dynamic "insight_selector" {
    for_each = var.enable_insights ? [1] : []
    content {
      insight_type = "ApiCallRateInsight"
    }
  }
}
