provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/networking"
}

module "ec2" {
  source = "./modules/compute"
}

module "iam" {
  source = "./modules/security"
}