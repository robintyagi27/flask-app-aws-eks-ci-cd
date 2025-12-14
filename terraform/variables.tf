variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-3"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "flask-eks"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}
