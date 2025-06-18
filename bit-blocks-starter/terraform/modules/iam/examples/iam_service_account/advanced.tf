# EKS IRSA Example
module "eks_irsa_service_account" {
  source = "../../iam_service_account"

  name               = "eks-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]

  tags = {
    Environment = "dev"
    Team        = "platform"
    Purpose     = "eks-irsa"
  }
}

# Replace with your actual cluster OIDC provider URL
# data "aws_eks_cluster" "example" {
#   name = "my-eks-cluster"
# }

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.<region>.amazonaws.com/id/<oidc-id>:sub"
      values   = ["system:serviceaccount:default:my-app-sa"]
    }
  }
}

resource "aws_iam_openid_connect_provider" "eks" {
  # url             = data.aws_eks_cluster.example.identity[0].oidc.issuer
  url             = "https://oidc.eks.<region>.amazonaws.com/id/<oidc-id>"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0ecd10be3"]
}


# GitHub Actions Role Example

module "github_actions_role" {
  source = "../../iam_service_account"

  name               = "github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  ]

  tags = {
    Environment = "ci"
    Owner       = "devops-team"
  }
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:your-org/your-repo:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
