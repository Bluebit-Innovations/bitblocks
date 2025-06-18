#############################
# outputs.tf
#############################

output "config_aggregator_id" {
  value       = var.enable_aggregator ? aws_config_configuration_aggregator.org_aggregator[0].id : null
  description = "AWS Config Aggregator ID"
}

output "security_hub_enabled_regions" {
  value       = var.enable_security_hub ? var.regions : []
  description = "Regions where Security Hub is enabled"
}

output "guardduty_status" {
  value       = var.enable_guardduty
  description = "Status of GuardDuty enablement"
}