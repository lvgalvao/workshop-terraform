###########################
########### VPC ###########
###########################
output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

# Output para a primeira subnet pública
output "public_subnet_a_id" {
  value       = aws_subnet.public_a.id
  description = "The ID of the first public subnet"
}

# Output para a segunda subnet pública
output "public_subnet_b_id" {
  value       = aws_subnet.public_b.id
  description = "The ID of the second public subnet"
}

# Output para a primeira subnet privada
output "private_subnet_a_id" {
  value       = aws_subnet.private_a.id
  description = "The ID of the first private subnet"
}

# Output para a segunda subnet privada
output "private_subnet_b_id" {
  value       = aws_subnet.private_b.id
  description = "The ID of the second private subnet"
}


###########################
########### EC2 ###########
###########################
output "ec2_public_ipv4" {
  value       = aws_instance.web.public_ip
  description = "The public IPv4 address of the EC2 instance"
}

output "ec2_id" {
  value       = aws_instance.web.id
  description = "The ID of the EC2 instance"
}

###########################
########### RDS ###########
###########################
output "rds_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "The endpoint of the RDS instance"
}

output "rds_instance_id" {
  value       = aws_db_instance.postgres.id
  description = "The ID of the RDS instance"
}
