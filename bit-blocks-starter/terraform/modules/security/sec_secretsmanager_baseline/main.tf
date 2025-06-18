
# KMS Key for encryption
resource "aws_kms_key" "secrets_encryption" {
  description             = "KMS key for Secrets Manager encryption"
  deletion_window_in_days = var.kms_deletion_window
  enable_key_rotation     = var.enable_kms_rotation
}

resource "aws_kms_alias" "secrets_key_alias" {
  name          = "alias/${var.kms_alias_name}"
  target_key_id = aws_kms_key.secrets_encryption.id
}

# Secrets Manager Secret
resource "aws_secretsmanager_secret" "secret" {
  name                    = var.secret_name
  description             = var.secret_description
  kms_key_id              = aws_kms_key.secrets_encryption.id
  recovery_window_in_days = var.recovery_window
  tags                    = var.tags
}

# Rotation configuration for Secret (optional)
resource "aws_secretsmanager_secret_rotation" "rotation" {
  count = var.enable_rotation ? 1 : 0

  secret_id           = aws_secretsmanager_secret.secret.id
  rotation_lambda_arn = aws_lambda_function.secret_rotation_lambda[0].arn

  rotation_rules {
    automatically_after_days = var.rotation_days
  }
}


# Lambda for automated rotation (optional)
resource "aws_lambda_function" "secret_rotation_lambda" {
  count = var.enable_rotation ? 1 : 0

  filename         = var.lambda_zip_path
  function_name    = "${var.secret_name}-rotation"
  role             = aws_iam_role.lambda_exec.arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = var.lambda_env_vars
  }
}

# IAM Role for Lambda rotation
resource "aws_iam_role" "lambda_exec" {
  name = "${var.secret_name}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM policy attachment for Lambda
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# CloudWatch Alarms for usage tracking (optional)
resource "aws_cloudwatch_metric_alarm" "secret_access_alarm" {
  count = var.enable_usage_alerts ? 1 : 0

  alarm_name          = "${var.secret_name}-access-alert"
  alarm_description   = "Alarm triggered on secret access frequency."
  metric_name         = "GetSecretValue"
  namespace           = "AWS/SecretsManager"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = var.access_alert_threshold
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    SecretId = aws_secretsmanager_secret.secret.id
  }

  alarm_actions = [var.sns_topic_arn]
}
