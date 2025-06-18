#########################
# ACCOUNT ASSIGNMENTS
#########################
resource "aws_ssoadmin_account_assignment" "this" {
  for_each = { for idx, val in local.sso_assignments : idx => val }

  # instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  instance_arn       = local.identity_center_instance_arn
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  principal_type     = each.value.target_type
  principal_id       = each.value.target_id
}

# # Data source for SSO instance
# data "aws_ssoadmin_instances" "this" {}
