output "inspector2_status" {
  value       = "Inspector2 enabled for resource types: ${join(", ", var.resource_types)}"
  description = "Status of Inspector2 activation."
}
