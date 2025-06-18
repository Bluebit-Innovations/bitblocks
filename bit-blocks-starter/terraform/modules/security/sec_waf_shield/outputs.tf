output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.this.id
}

output "shield_protection_id" {
  description = "ID of the Shield protection (if enabled)"
  value       = try(aws_shield_protection.this[0].id, null)
}
