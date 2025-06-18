resource "aws_organizations_organization" "this" {
  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "ou" {
  for_each  = var.organizational_units
  name      = each.value.name
  parent_id = aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_account" "account" {
  for_each = var.create_accounts ? var.managed_accounts : {}

  name      = each.value.name
  email     = each.value.email
  role_name = each.value.role_name
  iam_user_access_to_billing = "ALLOW"
  parent_id = aws_organizations_organizational_unit.ou[each.value.ou_key].id

  lifecycle {
    ignore_changes = [role_name] # account-level changes are often managed elsewhere
  }
}

resource "aws_organizations_delegated_administrator" "delegated_admins" {
  for_each = var.delegated_administrators

  account_id = var.create_accounts?aws_organizations_account.account[each.value.account_key].id:each.value.account_id

  service_principal = each.value.service_principal

  depends_on = [aws_organizations_organization.this]
}
