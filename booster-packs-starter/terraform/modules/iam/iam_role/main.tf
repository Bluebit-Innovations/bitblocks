# ---------------------------------------------------------------------------------------------------------------------
# File: main.tf
# Description: This module creates and manages AWS IAM roles with comprehensive security features
# Author: Oreoluwa Adegbite
# Last Modified: 2025-03-05
# ---------------------------------------------------------------------------------------------------------------------



# Example: IAM Role Module (iam_roles/main.tf)
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "this" {
    count = length(var.policy_arns)

    role       = aws_iam_role.this.name
    policy_arn = var.policy_arns[count.index]
}

