# S3 remote state 
terraform {
  backend "s3" {
    bucket         = "user-mgt-dev-bkt"
    key            = "project/user-mgt/eks"
    region         = "us-east-1"
    dynamodb_table = "user-mgt_state_locking"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12"
    }
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

module "dev_eks" {

  source                    = "../../"
  create                    = true
  cloudwatch_log_group_name = "dlframe-eks-dev"
  cloudwatch_log_stream     = "eks"
  disk_size                 = 30
  cluster_name              = "user-mgmt-dev"
  keypair                   = "user-mgmt-dev"
  eks_version               = "1.26"
  node_grp_name             = "user-mgmt-eks-node-group"
  ami_id                    = "ami-0ebd4e6356d0557a5" 
  ami_type                  = "AL2_x86_64"
  instance_type             = "t2.large"
  capacity_type             = "ON_DEMAND"
  retention_in_days         = 30

  ########################
  # Tags
  ########################
  domain = "user-mgmt"
  env    = "dev"
  name   = "dynamic-user-mgmt"


  ########################
  # Security Group
  ######################## 
  eks_sg_ingress_rules = [

    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0" # This need to be lock down to cidr in production use 
    },
    {
      description = "DC6 - All Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0" # # This need to be lock down to cidr in production use 
    }
  ]

}
