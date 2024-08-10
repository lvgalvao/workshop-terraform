# Provedor AWS
provider "aws" {
  region = "sa-east-1"
}

# Criar uma nova VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}

# Criar a primeira subnet pública para a EC2 na AZ1
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1a"

  tags = {
    Name = "PublicSubnetA"
  }
}

# Criar a segunda subnet pública para a EC2 na AZ2
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1b"

  tags = {
    Name = "PublicSubnetB"
  }
}

# Criar a primeira subnet privada para o PostgreSQL na AZ1
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "PrivateSubnetA"
  }
}

# Criar a segunda subnet privada para o PostgreSQL na AZ2
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "PrivateSubnetB"
  }
}

# Criar um gateway de internet para a VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainInternetGateway"
  }
}

# Criar uma tabela de roteamento para a subnet pública
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associar a tabela de roteamento pública às subnets públicas
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Security Group para permitir acesso à instância EC2 e ao RDS
resource "aws_security_group" "allow_ec2_rds" {
  vpc_id = aws_vpc.main.id

  # Regra para permitir acesso à porta 5432 (PostgreSQL)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Permitir tráfego da subnet privada
  }

  # Regra para permitir acesso SSH (porta 22) de qualquer lugar
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acesso SSH de qualquer lugar
  }

  # Regra para permitir acesso HTTP (porta 80) de qualquer lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acesso HTTP de qualquer lugar
  }

  # Regras de egress (saída) permitindo todo o tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowEC2RDS"
  }
}

# Criar um grupo de subnets para o RDS PostgreSQL cobrindo duas AZs
resource "aws_db_subnet_group" "postgres" {
  name       = "postgres-subnet-group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "PostgresSubnetGroup"
  }
}

# RDS PostgreSQL com Multi-AZ Desativado
resource "aws_db_instance" "postgres" {
  engine            = "postgres"
  engine_version    = "16.3"  # Mantém a versão atual
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  publicly_accessible = false
  multi_az          = false  # Desativando Multi-AZ
  vpc_security_group_ids = [aws_security_group.allow_ec2_rds.id]
  db_subnet_group_name = aws_db_subnet_group.postgres.name
  skip_final_snapshot = true

  tags = {
    Name = "PostgresDBInstance"
  }
}


# Instância EC2 na subnet pública
resource "aws_instance" "web" {
  ami           = "ami-09523541dfaa61c85"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  
  vpc_security_group_ids = [aws_security_group.allow_ec2_rds.id]

  user_data = base64encode(templatefile("user_data.sh.tpl", {
    db_username = var.db_username,
    db_password = var.db_password,
    db_address  = aws_db_instance.postgres.address,
    db_name     = var.db_name
  }))

  depends_on = [aws_db_instance.postgres]

  tags = {
    Name = "MyEC2Instance"
  }
}
