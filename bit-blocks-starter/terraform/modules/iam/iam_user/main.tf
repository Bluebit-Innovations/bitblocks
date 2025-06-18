# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This Terraform module creates and manages AWS IAM users with comprehensive security features:.
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------


# Example: IAM User Module (iam_user/main.tf)
resource "aws_iam_user" "this" {
  name = var.user_name
  path = var.user_path
}


# Create IAM user login profile if enabled
resource "aws_iam_user_login_profile" "this" {
    count                   = var.create_login_profile ? 1 : 0
    user                    = aws_iam_user.this.name
    pgp_key                = var.pgp_key
    password_length        = var.password_length
    password_reset_required = var.password_reset_required
}

# Create IAM access key if enabled
resource "aws_iam_access_key" "this" {
    count    = var.create_access_key ? 1 : 0
    user     = aws_iam_user.this.name
    pgp_key  = var.pgp_key
}


# Attach user to specified IAM groups
resource "aws_iam_user_group_membership" "this" {
    user   = aws_iam_user.this.name
    groups = var.iam_groups

    depends_on = [aws_iam_user.this]
}



