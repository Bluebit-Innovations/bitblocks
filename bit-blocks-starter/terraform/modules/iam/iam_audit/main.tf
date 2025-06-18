

# -------------------------
# IAM Access Analyzer
# -------------------------
resource "aws_accessanalyzer_analyzer" "default" {
  count = var.enable_access_analyzer ? 1 : 0
  analyzer_name = "${var.prefix}-access-analyzer"
  type  = "ACCOUNT"
  tags  = var.tags
}

# -------------------------
# Read-only Auditor Role
# -------------------------
resource "aws_iam_role" "auditor" {
  count = var.create_readonly_role ? 1 : 0

  name = "${var.prefix}-readonly-auditor"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = var.trusted_auditor_arns
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "readonly" {
  count      = var.create_readonly_role ? 1 : 0
  role       = aws_iam_role.auditor[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# -------------------------
# AWS Config Rules for IAM
# -------------------------
resource "aws_config_config_rule" "iam_root_access" {
  count        = var.enable_config_rules ? 1 : 0
  name         = "iam-root-access"
  source {
    owner             = "AWS"
    source_identifier = "IAM_ROOT_ACCESS_KEY_CHECK"
  }
}

resource "aws_config_config_rule" "iam_user_unused_credentials" {
  count        = var.enable_config_rules ? 1 : 0
  name         = "iam-user-unused-credentials"
  source {
    owner             = "AWS"
    source_identifier = "IAM_USER_UNUSED_CREDENTIALS_CHECK"
  }
}

# -------------------------
# Optional - S3 + Athena for IAM Logs
# -------------------------
resource "aws_s3_bucket" "iam_logs" {
  count = var.enable_athena_logs ? 1 : 0
  bucket = "${var.prefix}-iam-logs"
  force_destroy = true
  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "iam_logs" {
  count  = var.enable_athena_logs ? 1 : 0
  bucket = aws_s3_bucket.iam_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_athena_database" "iam_audit" {
  count   = var.enable_athena_logs ? 1 : 0
  name    = "iam_audit_db"
  bucket  = aws_s3_bucket.iam_logs[0].bucket
}

resource "aws_athena_workgroup" "iam_audit" {
  count = var.enable_athena_logs ? 1 : 0
  name  = "${var.prefix}-audit-workgroup"
  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.iam_logs[0].bucket}/results/"
    }
  }
}
