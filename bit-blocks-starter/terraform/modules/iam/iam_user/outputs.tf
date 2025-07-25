output "iam_user_arn" {
  description = "The ARN of the IAM user"
  value       = aws_iam_user.this.arn
}

output "name" {
    description = "The name of the IAM user"
    value       = aws_iam_user.this.name
  
}

output "user_password" {
    description = "The encrypted password of the IAM user login profile"
    value = length(aws_iam_user_login_profile.this) > 0 ? nonsensitive(aws_iam_user_login_profile.this[0].encrypted_password) : null
    sensitive = true
}

output "access_key_id" {
    description = "The access key ID of the IAM user"
    value = length(aws_iam_access_key.this) > 0 ? nonsensitive(aws_iam_access_key.this[0].id) : null
}

output "access_secret" {
    description = "The encrypted secret access key of the IAM user"
    value       = length(aws_iam_access_key.this) > 0 ? nonsensitive(aws_iam_access_key.this[0].encrypted_secret) : null
    sensitive   = true
}
