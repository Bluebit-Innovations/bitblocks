module "iam_role" {
  source = "../../iam_role"

  name                  = "example-role"
  permissions_boundary  = "arn:aws:iam::123456789012:policy/ExamplePermissionsBoundary"
  managed_policy_arns   = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
  inline_policies       = [
    {
      name   = "custom-policy"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect   = "Allow"
            Action   = ["s3:ListBucket"]
            Resource = ["*"]
          }
        ]
      })
    }
  ]
  create_instance_profile = true

  assume_role_principal_identifiers = ["arn:aws:iam::123456789012:root"]
}