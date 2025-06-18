locals {
  tag_policy_content = jsonencode({
    tags = {
      Environment = {
        tag_value = {
          "*": {
            enforced_for = ["ec2:instance", "s3:bucket"]
          }
        }
      }
      Owner = {
        tag_value = {
          "*": {
            enforced_for = ["ec2:instance"]
          }
        }
      }
    }
  })
}

resource "aws_organizations_policy" "tag_policy" {
  name        = var.tag_policy_name
  description = var.tag_policy_description
  content     = local.tag_policy_content
  type        = "TAG_POLICY"
}

resource "aws_organizations_policy_attachment" "this" {
  policy_id = aws_organizations_policy.tag_policy.id
  target_id = var.target_ou_id
}

resource "aws_config_config_rule" "required_tags" {
  name = "required-tags"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = jsonencode({
    tag1Key = "Environment",
    tag2Key = "Owner"
  })

  scope {
    compliance_resource_types = var.config_resource_types
  }

  depends_on = [aws_organizations_policy_attachment.this]
}

resource "aws_sns_topic" "compliance_alerts" {
  count = var.enable_sns_alerts ? 1 : 0
  name  = "compliance-alerts-topic"
}
resource "aws_config_config_rule" "sns_alert" {
  count = var.enable_sns_alerts ? 1 : 0
  name  = "sns-config-compliance-alert"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = jsonencode({
    tag1Key = "Environment"
  })

  scope {
    compliance_resource_types = ["AWS::EC2::Instance"]
  }

  depends_on = [aws_sns_topic.compliance_alerts]
}

