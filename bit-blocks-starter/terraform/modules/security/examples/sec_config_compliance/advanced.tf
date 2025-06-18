resource "aws_s3_bucket" "config_logs_advanced" {
  bucket = "my-config-bucket-advanced-example"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "expire-logs"
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_iam_role" "config_role_advanced" {
  name = "aws-config-role-advanced"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "config.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "config_policy_advanced" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_sns_topic" "compliance_alerts_advanced" {
  name = "compliance-alerts-topic"
}


# You would need to create a Lambda function for the custom rule and specify the zip file path
resource "aws_lambda_function" "s3_checker_advanced" {
  filename         = "lambda/s3_checker.zip"
  function_name    = "s3-public-check"
  role             = aws_iam_role.config_role.arn
  handler          = "index.handler"
  runtime          = "python3.9"
  source_code_hash = null
#   source_code_hash = filebase64sha256("lambda/s3_checker.zip")
}

module "sec_config_compliance_advanced" {
  source = "../../sec_config_compliance"

  recorder_name              = "advanced-compliance-recorder"
  recorder_role_arn          = aws_iam_role.config_role.arn
  delivery_channel_name      = "advanced-delivery-channel"
  delivery_s3_bucket         = aws_s3_bucket.config_logs.bucket
  delivery_sns_topic_arn     = aws_sns_topic.compliance_alerts_advanced.arn
  enable_conformance_pack    = true
  conformance_pack_name      = "cis-pack"
  conformance_pack_template_s3_uri = "s3://my-template-bucket/cis.yaml"
  global_resource_region     = "us-east-1"

  custom_rules = {
    s3_bucket_public_read_check = {
      lambda_function_arn     = aws_lambda_function.s3_checker_advanced.arn
      input_parameters        = { "bucketName" = "example" }
      max_execution_frequency = "TwentyFour_Hours"
      resource_types          = ["AWS::S3::Bucket"]
    }
  }
}
