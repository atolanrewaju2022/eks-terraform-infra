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
  cloudwatch_log_group_name = "user-mgmt-eks-dev"
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
  vpc_cidr                  = "172.31.0.0/16"
  azs                       = [ "us-east-1a", "us-east-1b" , "us-east-1c", "us-east-1d" ]
  private_subnets_cidr      = [ "172.31.4.0/24" , "172.31.5.0/24", "172.31.6.0/24", "172.31.7.0/24" ]
  public_subnets_cidr       = [ "172.31.11.0/24" , "172.31.12.0/24", "172.31.13.0/24","172.31.14.0/24" ]



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
      description = "Test and allow all traffic before locking it down"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0" # This needs to be lock down to cidr in production use 
    },
    {
      description = "All Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0" # # This needs to be lock down to cidr in production use 
    }
  ]

}

