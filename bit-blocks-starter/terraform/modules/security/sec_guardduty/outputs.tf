output "guardduty_detector_ids" {
  description = "Map of region to GuardDuty detector IDs"
  value = {
    for region, detector in aws_guardduty_detector.this :
    region => detector.id
  }
}

output "guardduty_admin_account_id" {
  description = "Admin account ID for GuardDuty Organization Admin (if enabled)"
  value       = var.enable_organization_admin ? var.admin_account_id : null
}

output "guardduty_sns_destinations" {
  description = "List of GuardDuty publishing destinations (if configured)"
  value       = aws_guardduty_publishing_destination.this[*].destination_arn
}
