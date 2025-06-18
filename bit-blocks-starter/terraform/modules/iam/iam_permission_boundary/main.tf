resource "aws_iam_policy" "permission_boundary" {
  name        = var.name
  path        = "/"
  description = var.description

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = var.allowed_actions
        Resource = var.resource_arns
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "boundary_attachment" {
  count      = var.attach_to_existing_roles ? length(var.target_roles) : 0
  role       = var.target_roles[count.index]
  policy_arn = aws_iam_policy.permission_boundary.arn
}
