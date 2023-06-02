# S3 remote state 
terraform {
  backend "s3" {
    bucket         = "dlframe-tf-remote-dev-bkt"
    key            = "project/DLFrame/eks"
    region         = "us-east-1"
    dynamodb_table = "DLFrame_state_locking"
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
  vpc_id                    = "vpc-91cac0e8"
  private_subnet_ids        = [ "subnet-e8a088c4", "subnet-43f22827", "subnet-e8a088c4", "subnet-791b4675" ]
  create                    = true
  cloudwatch_log_group_name = "dlframe-eks-dev"
  cloudwatch_log_stream     = "eks"
  disk_size                 = 30
  cluster_name              = "dlframe-dev"
  keypair                   = "dlframe-eks-dev"
  eks_version               = "1.26"
  node_grp_name             = "dlframe_eks_node_group"
  ami_id                    = "ami-0ebd4e6356d0557a5" 
  ami_type                  = "AL2_x86_64"
  instance_type             = "t2.large"
  capacity_type             = "ON_DEMAND"
  retention_in_days         = 30

  ########################
  # Tags
  ########################
  domain = "dlframe"
  env    = "dev"
  name   = "Glidewell-dlframe"


  ########################
  # Security Group
  ######################## 
  eks_sg_ingress_rules = [

    {
      description = "gl-InfraServices ClientVPN Users"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "192.168.128.0/19"
    },
    {
      description = "DC6 - All Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "10.249.0.0/20"
    }
  ]

}
