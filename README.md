# Overview 

This eks-terraform-infra repository will be use as template to provision Elastic Kubernetes Service(EKS) for multiple applications and is reusable with minimal refactoring.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Purpose](#purpose)
- [Scope](#scope)
- [Resources](#resources)
- [Terraform plan output](#terraform-plan-output)
- [Infracost](#Infracost)

# Purpose
Provisions an EKS cluster, the Node Group attached to the cluster, and other supporting resources (ALB's,VPC, IAM etc).

# Scope

This module includes eks cluster configuration for DLFrame eks  cluster. It can provision clusters in `dev`,`qa`, `uat`, or `prod`. The desired application/environment can be configured via command line invocation. I.e. to deploy the user-magmt-app eks cluster to `uat`, you'd use the following command: `ENV=uat`.

# Resources
- EKS
- EKS Node Group
- Security Group
- IAM Role and Permissions
- 

# Infracost 
