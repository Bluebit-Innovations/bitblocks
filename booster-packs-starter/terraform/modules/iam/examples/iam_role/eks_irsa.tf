module "eks_irsa_role" {
  source = "../../iam_role"

  name = "eks-irsa-myapp"
  path = "/"
  tags = {
    Environment = "prod"
    App         = "myapp"
  }

  assume_role_principal_type        = "Federated"
  assume_role_principal_identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider_url}"]

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

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_caller_identity" "current" {}

variable "cluster_name" {}
variable "oidc_provider_url" {}
