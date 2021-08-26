terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
    required_version = ">= 0.13"
    backend "s3" {
        bucket = "bmc-practice-terraform-devops"
        key    = "angela/terraform.tfstate"
        region = "eu-central-1"
    }       
}

provider "kubernetes" {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

