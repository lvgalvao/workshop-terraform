# Criar uma tabela DynamoDB para o bloqueio do estado
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-locks"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformLocks"
  }
}