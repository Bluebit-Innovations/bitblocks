resource "aws_iam_role" "this" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = var.path
  max_session_duration = var.max_session_duration
  tags               = var.tags

  permissions_boundary = var.permissions_boundary
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.managed_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  for_each = { for policy in var.inline_policies : policy.name => policy }
  name     = each.key
  role     = aws_iam_role.this.name
  policy   = each.value.policy
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = "${var.name}-profile"
  role  = aws_iam_role.this.name
  path  = var.path
}
