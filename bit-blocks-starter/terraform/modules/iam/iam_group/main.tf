# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This module creates and manages AWS IAM groups with associated policies and memberships
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------

# IAM Group Module (iam_group/main.tf)

resource "aws_iam_group" "this" {
    name = var.group_name
    path = var.group_path
}

resource "aws_iam_group_membership" "this" {
    name  = "${var.group_name}-membership"
    group = aws_iam_group.this.name
    users = var.group_users
}

resource "aws_iam_group_policy" "this" {
    count  = var.enable_inline_policies ? length(var.inline_policies) : 0
    name   = "${var.group_name}-policy-${count.index}"
    group  = aws_iam_group.this.name
    policy = var.inline_policies[count.index]
}

resource "aws_iam_group_policy_attachment" "this" {
    count      = var.enable_managed_policies ? length(var.managed_policy_arns) : 0
    group      = aws_iam_group.this.name
    policy_arn = var.managed_policy_arns[count.index]
}

