module "iam_policy_basic" {
  source      = "../../iam_policy"

  name        = "basic-readonly-policy"
  description = "Grants read-only access to S3"
  path        = "/"
  
  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "dev"
    Owner       = "example-team"
  }

  roles_to_attach = ["readonly-role"]
  enable_sso      = false
}
