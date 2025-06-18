

# Use case: Create a permission boundary and attach it to existing roles.

module "iam_permission_boundary_advanced" {
  source  = "../../iam_permission_boundary"

  name        = "advanced-boundary-policy"
  description = "Permission boundary for limited read/write on DynamoDB and S3"

  allowed_actions = [
    "dynamodb:GetItem",
    "dynamodb:Query",
    "dynamodb:PutItem",
    "s3:GetObject",
    "s3:PutObject"
  ]

  resource_arns = [
    "arn:aws:dynamodb:us-east-1:123456789012:table/my-table",
    "arn:aws:s3:::project-data/*"
  ]

  target_roles = [
    "analytics-read-role",
    "app-lambda-execution-role"
  ]

  attach_to_existing_roles = true

  tags = {
    Environment = "prod"
    CostCenter  = "security"
    Project     = "analytics"
  }
}
