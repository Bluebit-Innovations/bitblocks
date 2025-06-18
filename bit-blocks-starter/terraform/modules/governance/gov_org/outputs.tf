output "organization_id" {
  value = aws_organizations_organization.this.id
}

output "root_id" {
  value = aws_organizations_organization.this.roots[0].id
}

output "organizational_unit_ids" {
  value = { for k, ou in aws_organizations_organizational_unit.ou : k => ou.id }
}
