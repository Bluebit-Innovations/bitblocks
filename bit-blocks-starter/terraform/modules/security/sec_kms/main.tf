resource "aws_kms_key" "this" {
  description             = var.key_description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  is_enabled              = var.is_enabled
  policy                  = var.key_policy
  multi_region            = var.multi_region
  tags                    = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_grant" "this" {
  count            = var.create_grants ? length(var.grants) : 0
  name             = var.grants[count.index].name
  key_id           = aws_kms_key.this.id
  grantee_principal = var.grants[count.index].grantee_principal
  operations       = var.grants[count.index].operations
  constraints {
    encryption_context_equals = var.grants[count.index].encryption_context_equals
  }
}
