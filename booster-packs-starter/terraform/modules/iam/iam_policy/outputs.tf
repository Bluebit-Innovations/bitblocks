output "iam_policy_arn" {
  description = "The ARN of the IAM policy"
  value       = aws_iam_policy.this.arn
}
