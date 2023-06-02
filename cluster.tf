#Get caller identity 
data "aws_caller_identity" "current" {}


#EKS cloudwatch log group
resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${var.domain}-${var.env}/cluster"
  retention_in_days = var.retention_in_days

  tags = {
    Name            = var.node_grp_name
    DeptOwner       = "DevOps"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "INFRA: ${var.env}"
    BillingSubGroup = "EksCluster"
    Environment     = var.env
    CreatedBy       = "DevOps@olanrewaju.com"
  }

}


#EKS Cluster 
resource "aws_eks_cluster" "eks_cluster" {
  name                      = "${var.cluster_name}-eks"
  version                   = var.eks_version 
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = [ "api", "audit", "authenticator", "controllerManager", "scheduler" ]

  kubernetes_network_config {

        ip_family           = "ipv4"
        service_ipv4_cidr   = "172.20.0.0/16"
  }      
  
  vpc_config {

    subnet_ids              = 
    security_group_ids      = [ aws_security_group.eks_security_group.id ]
  }
   
  tags = {
    Name            = "${var.cluster_name}-eks"
    DeptOwner       = "DevOps"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "INFRA: ${var.env}"
    BillingSubGroup = "EksCluster"
    Environment     = var.env
    CreatedBy       = "DevOps@olanrewaju.com"
  }
}


#EKS managed node group
resource "aws_eks_node_group" "app_eks_node_group" {

  ami_type                    = var.ami_type
  capacity_type               = var.capacity_type
  cluster_name                = aws_eks_cluster.eks_cluster.name
  node_group_name             = "${var.node_grp_name}-1"
  node_role_arn               = aws_iam_role.eks_worker_nodes.arn
  subnet_ids                  = var.public_subnet_ids
  instance_types              = [ "t2.large" ]   #[ var.instance_type ]
  disk_size                   = var.disk_size
  version                     = var.eks_version 

  # remote_access {
  #   ec2_ssh_key               = var.keypair
  #   source_security_group_ids = [ aws_security_group.eks_security_group.id ]
    
  # }
  
  scaling_config {
    desired_size = 3
    min_size     = 3
    max_size     = 4
  }

  update_config {
        max_unavailable            = 1
  }


}


#EKS Addon - Amazon VPC CNI(Enable pod networking within your cluster)
# aws_eks_addon.amazon_vpc_cni:
resource "aws_eks_addon" "amazon_vpc_cni" {
    addon_name    = "vpc-cni"
    addon_version = "v1.12.5-eksbuild.2"
    cluster_name  = aws_eks_cluster.eks_cluster.name

    tags = {
    Name            = var.cluster_name
    DeptOwner       = "DevOps"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "INFRA: ${var.env}"
    BillingSubGroup = "EksCluster"
    Environment     = var.env
    CreatedBy       = "DevOps@olanrewaju.com"
  }
}


#EKS Addon - coredns(Enable service discovery within your cluster)
# aws_eks_addon.core_dns:
resource "aws_eks_addon" "core_dns" {
    addon_name    = "coredns"
    addon_version = "v1.9.3-eksbuild.2"
    cluster_name  = aws_eks_cluster.eks_cluster.name

    tags = {
    Name            = var.cluster_name
    DeptOwner       = "DevOps"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "INFRA: ${var.env}"
    BillingSubGroup = "EksCluster"
    Environment     = var.env
    CreatedBy       = "DevOps@olanrewaju.com"
  }
}


#EKS Addon - kube proxy (Enable service networking within your cluster)
# aws_eks_addon.kube_proxy:
resource "aws_eks_addon" "kube_proxy" {
    addon_name    = "kube-proxy"
    addon_version = "v1.26.2-eksbuild.1"
    cluster_name  = aws_eks_cluster.eks_cluster.name

    tags = {
    Name            = var.cluster_name
    DeptOwner       = "DevOps"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "INFRA: ${var.env}"
    BillingSubGroup = "EksCluster"
    Environment     = var.env
    CreatedBy       = "DevOps@olanrewaju.com"
  }

}

#Enable Elastic Block Storage(EBS) within the cluster
resource "aws_eks_addon" "ebs_csi-driver" {
    addon_name    = "aws-ebs-csi-driver"
    addon_version = "v1.15.0-eksbuild.1"
    cluster_name  = aws_eks_cluster.eks_cluster.name

    tags = {
    Name            = var.cluster_name
    DeptOwner       = "DevOps"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "INFRA: ${var.env}"
    BillingSubGroup = "EksCluster"
    Environment     = var.env
    CreatedBy       = "DevOps@olanrewaju.com"
  }

}
