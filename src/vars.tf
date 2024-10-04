# Common
variable "regionDefault" {
  default = "us-east-1"
}

variable "projectName" {
  default = "health-med"
}

# EKS
variable "eksAccessConfig" {
  default = "API_AND_CONFIG_MAP"
}

variable "eksInstanceType" {
  default = "t3.small"
}

variable "eksPolicyArn" {
  default = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

# RDS
variable "rdsInstanceClass" {
  default = "db.t3.micro"
}

variable "rdsHealthmedUsername" {
  default = "postgres"
}

variable "rdsHealthmedPassword" {
  default = "postgres"
}
