
module "eks_baseline_basic" {
  source                  = "../../sec_prem_eks_baseline"
  cluster_name            = "bluebit-eks"
  cluster_role_arn        = "arn:aws:iam::123456789012:role/EKSClusterRole"
  subnet_ids              = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]
  enable_public_endpoint  = false
  service_ipv4_cidr       = "172.20.0.0/16"
  thumbprint              = "9e99a48a9960b14926bb7f3b02e22da0afd40c8a"
  irsa_namespace          = "default"
  irsa_service_account    = "app-sa"
  tags = {
    Environment = "dev"
    Owner       = "platform-team"
  }
}
