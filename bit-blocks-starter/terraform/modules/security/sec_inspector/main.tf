# data "aws_caller_identity" "current" {}

resource "aws_inspector2_enabler" "this" {
  count        = var.enable_for_organization ? 0 : 1
  account_ids  = var.account_ids
  resource_types = var.resource_types
}

resource "aws_inspector2_organization_configuration" "this" {
  count = var.enable_for_organization ? 1 : 0

  auto_enable {
    ec2     = var.auto_enable_ec2
    ecr     = var.auto_enable_ecr
    lambda  = var.auto_enable_lambda
  }
}

resource "aws_inspector2_delegated_admin_account" "this" {
  count        = var.enable_for_organization && var.delegated_admin_account_id != "" ? 1 : 0
  account_id   = var.delegated_admin_account_id
}

