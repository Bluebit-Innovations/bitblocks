# IRSA / EKS Service Role Example (No SSO)

module "iam_policy_irsa" {
  source      = "../../iam_policy"

  name        = "eks-irsa-s3-reader"
  description = "Allows EKS pods to access S3 via IRSA"
  path        = "/"

  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::my-app-bucket",
          "arn:aws:s3:::my-app-bucket/*"
        ]
      }
    ]
  })

  tags = {
    Environment = "staging"
    App         = "eks-service"
  }

  roles_to_attach = ["eks-irsa-role"]
  enable_sso      = false
}



# SSO Enabled Example Using Managed Policies

module "iam_policy_sso_managed" {
  source      = "../../iam_policy"

  name        = "sso-managed-access"
  description = "Attaches AWS managed policies to an SSO permission set"
  path        = "/"

  policy_json = jsonencode({}) # Optional inline policy placeholder

  tags = {
    Department = "Engineering"
    Environment = "prod"
  }

  enable_sso              = true
  sso_instance_arn        = "arn:aws:sso:::instance/ssoins-EXAMPLE1234"
  sso_permission_set_arn  = "arn:aws:sso:::permissionSet/ssoins-EXAMPLE1234/ps-EXAMPLE5678"

  sso_managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  ]

  roles_to_attach = [] # Not attaching to IAM roles in this example
}
