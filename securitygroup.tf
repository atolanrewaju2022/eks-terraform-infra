# EKS Cluster and Nodes Security group 

resource "aws_security_group" "eks_security_group"  {
  name        = "${var.domain}-${var.env}-eks-security-group"
  vpc_id      = var.vpc_id 
  description = "allows access from anywhere in the ${var.env}1 VPC"

  tags = {
    Name            = "${var.domain}-${var.env}-eks-security-group"
    DeptOwner       = "SRE"
    DeptSubOwner    = "Infrastructure"
    BillingGroup    = "DLFrame: ${var.env}"
    BillingSubGroup = "EksCluster"
    Environment     = var.env
    RequestedBy     = "sreteam@glidewelldental.com"
    CreatedBy       = "sreteam@glidewelldental.com"
  }

}


resource "aws_security_group_rule" "eks_ingress_rules" {
  count             = length(var.eks_sg_ingress_rules)
  type              = "ingress"
  from_port         = var.eks_sg_ingress_rules[count.index].from_port
  to_port           = var.eks_sg_ingress_rules[count.index].to_port
  protocol          = var.eks_sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.eks_sg_ingress_rules[count.index].cidr_block]
  description       = var.eks_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.eks_security_group.id
  
}


resource "aws_security_group_rule" "eks_egress_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Egress can access all traffic."
  security_group_id = aws_security_group.eks_security_group.id
  
}

