# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This module creates and manages AWS IAM policies with comprehensive security controls
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------

# IAM Policy resource
resource "aws_iam_policy" "this" {
  name        = var.name
  path        = var.path
  description = var.description
  policy      = var.policy_json
  tags        = var.tags
}

resource "aws_iam_policy_attachment" "this" {
  count      = length(var.roles_to_attach) > 0 ? 1 : 0
  name       = "${var.name}-attachment"
  policy_arn = aws_iam_policy.this.arn
  roles      = var.roles_to_attach
}


# SSO permission Set resources section.
resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  count = var.enable_sso && var.sso_permission_set_arn != null ? 1 : 0

  instance_arn       = var.sso_instance_arn
  permission_set_arn = var.sso_permission_set_arn
  inline_policy      = var.policy_json
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = var.enable_sso && var.sso_permission_set_arn != null ? {
    for idx, arn in var.sso_managed_policy_arns : idx => arn
  } : {}

  instance_arn       = var.sso_instance_arn
  permission_set_arn = var.sso_permission_set_arn
  managed_policy_arn = each.value
}
