locals {
    vpc_cidr = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {
    state = "available"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = local.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names,0,2)
  private_subnets = [cidrsubnet(local.vpc_cidr ,8,0), cidrsubnet(local.vpc_cidr ,8,1)]
  public_subnets  = [cidrsubnet(local.vpc_cidr ,8,2), cidrsubnet(local.vpc_cidr ,8,3)]
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "angela-eks"
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.micro"
      asg_max_size                  = 1
    }
 ]
}
