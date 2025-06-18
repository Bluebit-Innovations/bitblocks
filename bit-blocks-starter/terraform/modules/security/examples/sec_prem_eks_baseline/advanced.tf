
module "eks_baseline_advanced" {
  source                  = "../../sec_prem_eks_baseline"
  cluster_name            = "bluebit-prod-eks"
  cluster_role_arn        = "arn:aws:iam::123456789012:role/BluebitProdEKSRole"
  subnet_ids              = [
    "subnet-11111111",
    "subnet-22222222",
    "subnet-33333333"
  ]
  enable_public_endpoint  = false
  service_ipv4_cidr       = "10.100.0.0/16"
  cluster_log_types       = ["api", "audit", "authenticator", "scheduler", "controllerManager"]
  thumbprint              = "4e99a48a9960b14926bb7f3b02e22da0afd40d9f"
  irsa_namespace          = "monitoring"
  irsa_service_account    = "external-dns"
  tags = {
    Project     = "secure-cluster"
    Environment = "production"
    CostCenter  = "cloud-native"
    Owner       = "devsecops-team"
  }
}

# Optional: Enable CloudWatch Log Group retention or integrate other modules here
