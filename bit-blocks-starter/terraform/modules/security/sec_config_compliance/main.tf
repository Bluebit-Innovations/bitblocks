resource "aws_config_configuration_recorder" "this" {
  name     = var.recorder_name
  role_arn = var.recorder_role_arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = var.delivery_channel_name
  s3_bucket_name = var.delivery_s3_bucket
  sns_topic_arn  = var.delivery_sns_topic_arn
  depends_on     = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_config_conformance_pack" "this" {
  count                     = var.enable_conformance_pack ? 1 : 0
  name                      = var.conformance_pack_name
  delivery_s3_bucket        = var.conformance_pack_s3_bucket
  delivery_s3_key_prefix    = var.conformance_pack_s3_prefix
  template_body             = var.conformance_pack_template_body
  template_s3_uri           = var.conformance_pack_template_s3_uri
  
  dynamic "input_parameter" {
  for_each = var.conformance_pack_input_parameters
  content {
    parameter_name  = input_parameter.key
    parameter_value = input_parameter.value
  }
}

}

resource "aws_config_config_rule" "custom_rules" {
  for_each = var.custom_rules

  name = each.key
  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = each.value.lambda_function_arn
    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  input_parameters = jsonencode(each.value.input_parameters)
  
  maximum_execution_frequency = each.value.max_execution_frequency
  scope {
    compliance_resource_types = each.value.resource_types
  }
}
