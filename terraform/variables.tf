# Define variables for your Terraform configuration

variable "aws_region" {
  description = "The AWS region where the infra will be deployed."
  default     = "us-east-1" # Or other AWS region per req
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16" #CIDR would be a smaller range depending on req
}

variable "subnet_cidr_blocks" {
  description = "The list of CIDR blocks for the private subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"] #CIDR would be a smaller range depending on req
}

variable "security_group_ingress_cidr_blocks" {
  description = "List of CIDR blocks to allow ingress traffic for the security group."
  default     = ["10.0.0.0/16"] #CIDR would be a smaller range depending on req
}

variable "node_groups" {
  description = "Map of EKS node groups"
  type        = map(object({
    desired_size = number
    max_size     = number
    min_size     = number
    instance_type = string
    ami_id       = string
    key_name     = string
    security_groups = list(string)
  }))
  
  default = {
    "example-node-group" = {
      desired_size   = 2
      max_size       = 5
      min_size       = 1
      instance_type  = "t2.micro" #req is small instances, usually this would be something more sustainable
      ami_id         = "ami-0bc4534a93057f9fb" #based on https://us-east-1.console.aws.amazon.com/systems-manager/parameters/aws/service/eks/optimized-ami/1.27/amazon-linux-2/recommended/image_id/description?region=us-east-1
      key_name       = "my-key-pair" #I would use a template if new is req
      security_groups = ["sg-0315fbf9211ef61ab"] #I would use a template if new is req
    }
  }
}


