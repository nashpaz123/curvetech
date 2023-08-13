# Define outputs for your Terraform configuration

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "The IDs of the created private subnets."
  value       = aws_subnet.private_subnet[*].id
}

output "security_group_id" {
  description = "The ID of the created security group."
  value       = aws_security_group.microservices_sg.id
}

#another output in eks.tf