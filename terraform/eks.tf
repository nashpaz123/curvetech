provider "aws" {
  region = var.aws_region
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "microservices-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.private_subnet[*].id
  }
}

resource "aws_iam_role" "eks_cluster" {
  name = "microservices-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_eks_node_group" "eks_nodes" {
  for_each = var.node_groups

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = each.key

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  launch_template {
    instance_type = each.value.instance_type
  }

  remote_access {
    ec2_ssh_key = each.value.key_name
  }

  subnet_ids = aws_subnet.private_subnet[*].id
}

output "eks_config" {
  value = {
    cluster_name = aws_eks_cluster.eks_cluster.name
    cluster_endpoint = aws_eks_cluster.eks_cluster.endpoint
    cluster_certificate_authority_data = aws_eks_cluster.eks_cluster.certificate_authority.0.data
  }
}
