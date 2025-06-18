module "eks_irsa_role" {
  source = "../../iam_role"

  name = "eks-irsa-myapp"
  path = "/"
  tags = {
    Environment = "prod"
    App         = "myapp"
  }

  assume_role_principal_type        = "Federated"
  assume_role_principal_identifiers = ["arn:aws:iam::111222334343:oidc-provider/${var.oidc_provider_url}"]

  inline_policies = [
    {
      name   = "eks-irsa-inline"
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect   = "Allow",
            Action   = ["s3:GetObject", "s3:PutObject"],
            Resource = "arn:aws:s3:::myapp-bucket/*"
          }
        ]
      })
    }
  ]

    assume_role_conditions = []

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

# data "aws_eks_cluster" "this" {
#   name = var.cluster_name
# }

# data "aws_caller_identity" "current" {}

# variable "cluster_name" {
#   description = "The name of the EKS cluster"
#   type        = string
#   default     = "my-eks-cluster"
# }
variable "oidc_provider_url" {
  description = "The OIDC provider URL for the EKS cluster"
  type        = string
  default     = "https://oidc.eks.us-west-2.amazonaws.com/id/EXAMPLE1234567890"
  validation {
    condition     = can(regex("^https://oidc\\.eks\\.[a-z]{2}-[a-z]+-[0-9]+\\.amazonaws\\.com/id/[A-Z0-9]+$", var.oidc_provider_url))
    error_message = "The OIDC provider URL must match the expected format."
  }
  validation {
    condition     = length(var.oidc_provider_url) > 0
    error_message = "The OIDC provider URL cannot be empty."
  }
}
