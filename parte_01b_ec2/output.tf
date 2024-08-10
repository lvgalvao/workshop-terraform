output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.example.id
}

output "instance_public_ip" {
  description = "IP público da instância EC2"
  value       = aws_instance.example.public_ip
}
