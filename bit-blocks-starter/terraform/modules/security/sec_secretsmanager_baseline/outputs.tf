output "secret_arn" {
  value = aws_secretsmanager_secret.secret.arn
}

output "kms_key_arn" {
  value = aws_kms_key.secrets_encryption.arn
}

output "rotation_lambda_arn" {
  value       = var.enable_rotation ? aws_lambda_function.secret_rotation_lambda[0].arn : null
  description = "ARN of the rotation Lambda function (if rotation enabled)."
}
