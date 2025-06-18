module "lambda_guardrails_basic" {
  source         = "../../sec_prem_lambda_guardrails"  # Adjust based on your folder structure
  region         = "us-east-1"
  sns_topic_arn  = "arn:aws:sns:us-east-1:123456789012:security-alerts"
  lambda_zip_path = "${path.module}/lambda_permission_checker.zip"
}
