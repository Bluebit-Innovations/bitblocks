resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  instance_arn  = var.identity_center_instance_arn
  name          = each.key
  description   = each.value.description
  session_duration = each.value.session_duration
  relay_state    = lookup(each.value, "relay_state", null)
  tags           = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = local.flattened_policy_attachments

  instance_arn       = var.identity_center_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set_name].arn
  managed_policy_arn = each.value.policy_arn
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = var.assignments

  instance_arn       = var.identity_center_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn
  principal_id       = each.value.principal_id
  principal_type     = each.value.principal_type
  target_id          = each.value.target_account_id
  target_type        = "AWS_ACCOUNT"
}
