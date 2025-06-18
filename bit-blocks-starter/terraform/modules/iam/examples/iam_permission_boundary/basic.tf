# Example Use case: Create a permission boundary policy only, without attaching to any roles.

module "iam_permission_boundary_basic" {
  source  = "../../iam_permission_boundary"

  name            = "basic-permission-boundary"
  description     = "Restrict actions to S3 list and read only"
  allowed_actions = [
    "s3:ListBucket",
    "s3:GetObject"
  ]
  resource_arns = [
    "arn:aws:s3:::example-bucket",
    "arn:aws:s3:::example-bucket/*"
  ]

  tags = {
    Environment = "dev"
    Owner       = "team-platform"
  }
}

