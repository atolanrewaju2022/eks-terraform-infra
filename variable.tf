# ----------------------------------------------------------------------------------------------------------------------
# VARIABLES / LOCALS / REMOTE STATE
# ----------------------------------------------------------------------------------------------------------------------

variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = string
  default     = "gp2"
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC cidr notation for eks cluster"
  type        = string 
  default     = ""

}

variable "env" {
  type        = string
  description = "The isolated environment the module is associated with (e.g. Shared Services `shared`, Application `app`)"
  default     = ""
}

variable "domain" {
  type        = string
  description = "Namespace, which could be your organization abbreviation, client name, etc. (e.g. uclib)"
  default     = ""
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name`"
}


variable "ami_id" {
  description = "Amazon machine image to use"
  type        = string 
  default     = ""

}

variable "instance_type" {
  type        = string 
  default     = ""

}
 
variable "disk_size" {
  type        = string 
  default     = ""   

}
  
variable "eks_cluster_endpoint" {
  type        = string 
  default     = ""    

}
  
variable "eks_oidc_url" {
  type        = string 
  default     = ""    

}
  
variable "eks_ca_certificate" {
  type        = string 
  default     = ""      

}

variable "eks_version" {
  type        = string
  default     =  "" 

}

variable "cluster_name" {
  type        = string
  default     =  ""   

}

variable "node_grp_name" {
  description = "The given name for the group of EC2 instances "
  type        = string
  default     = ""
}

variable "keypair" {
  description = "The keypair for group of Worker Nodes "
  type        = string
  default     = ""
}

variable "cloudwatch_log_stream" {}
variable "cloudwatch_log_group_name" {}
variable "name" {}
variable "ami_type" {}
variable "eks_sg_ingress_rules" {}
#variable "transit_gateway_id" {}
variable "capacity_type" {}
variable "retention_in_days" {}
#variable "public_subnets_cidr" {}
#variable "private_subnets_cidr" {}
#variable "azs" {}
variable "vpc_id" {}
variable "private_subnet_ids" {}

locals {
 
  environment_prefix = join(var.delimiter, compact([var.domain, var.env]))
  module_prefix      = join(var.delimiter, compact([local.environment_prefix, var.name]))
}
