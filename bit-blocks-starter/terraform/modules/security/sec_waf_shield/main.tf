resource "aws_wafv2_web_acl" "this" {
  name        = var.web_acl_name
  description = "WAF ACL for application-layer protection"
  scope       = var.scope # CLOUDFRONT or REGIONAL
  default_action {
    allow {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.web_acl_name
    sampled_requests_enabled   = true
  }
  tags = var.tags

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "this" {
  count        = var.resource_arn != "" ? 1 : 0
  resource_arn = var.resource_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

resource "aws_shield_protection" "this" {
  count         = var.enable_shield_protection ? 1 : 0
  name          = "${var.web_acl_name}-shield"
  resource_arn  = var.resource_arn
  tags          = var.tags
}

resource "aws_shield_protection_group" "group" {
  count = var.enable_protection_group ? 1 : 0
  aggregation = "SUM"
  pattern     = "ARBITRARY"
  members     = var.shield_group_members
  protection_group_id = var.shield_group_name
}
