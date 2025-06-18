module "lambda_guardrails_advanced" {
  source         = "../../sec_prem_lambda_guardrails"
  region         = "us-east-1"
  analyzer_name  = "bluebit-lambda-iam-analyzer"
  sns_topic_arn  = "arn:aws:sns:us-east-1:123456789012:security-alerts"
  lambda_zip_path = "${path.module}/lambda_permission_checker.zip"
  notification_lambda_function_name = "lambda-alert-processor"
}
