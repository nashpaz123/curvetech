provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "private_subnet" {
  count = length(var.subnet_cidr_blocks)
  cidr_block = var.subnet_cidr_blocks[count.index]
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "microservices_sg" {
  name        = "microservices-sg"
  description = "Security group for microservices"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80 # probably 443 but can be other ports as req
    to_port     = 80 # This would be a more exotic port depending on req
    protocol    = "tcp"
    cidr_blocks = var.security_group_ingress_cidr_blocks
  }
}

# Other resources like EKS cluster, node groups, etc. could be defined here but I prefer a seperate file for ease of POC