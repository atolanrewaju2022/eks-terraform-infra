data "tls_certificate" "certificate" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

}

#OIDC provider enable the ingress controller to be able to route traffic to the pods running 
resource "aws_iam_openid_connect_provider" "main" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [ data.tls_certificate.certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
