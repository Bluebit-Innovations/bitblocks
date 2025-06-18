resource "aws_s3_bucket" "config_logs" {
  bucket = "my-config-logs-bucket-basic"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "config_role" {
  name = "config-role-basic"

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

resource "aws_iam_role_policy_attachment" "config_policy_attachment" {
  role       = aws_iam_role.config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

module "sec_config_compliance_basic" {
  source = "../../sec_config_compliance"

  recorder_role_arn      = aws_iam_role.config_role.arn
  delivery_s3_bucket     = aws_s3_bucket.config_logs.bucket
}
