terraform { 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.61.0"
    }
  }
  backend "s3" {
    # Lembre de trocar o bucket para o seu, não pode ser o mesmo nome
    bucket         = "descomplicando-terraform-12345"
    key            = "terraform-test.tfstate"
    region         = "us-east-1"
    encrypt        = true  # Ativa a criptografia
  }
}
# Criar uma nova VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}

# Criar uma subnet pública
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1a"

  tags = {
    Name = "PublicSubnet"
  }
}

# Criar um gateway de internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainInternetGateway"
  }
}

# Criar uma tabela de roteamento
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

# Associar a tabela de roteamento à subnet pública
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Criar um Security Group para a instância EC2
resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Allow inbound traffic on port 80 from any IP"

  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir tráfego na porta 80 de qualquer IP
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir tráfego na porta 22 (SSH) de qualquer IP
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Permitir todo tráfego de saída
  }

  tags = {
    Name = "ExampleSecurityGroup"
  }
}

# Criar uma instância EC2
resource "aws_instance" "example" {
  ami           = "ami-09523541dfaa61c85" # Substitua pela AMI do Amazon Linux desejada
  instance_type = "t2.micro"              # Tipo da instância
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.example.id]

  user_data = <<-EOF
              #!/bin/bash
              # Atualizar o sistema
              sudo dnf update -y
              
              # Instalar Git
              sudo dnf install git -y
              
              # Clonar o repositório Git
              git clone https://github.com/lvgalvao/streamlit-app-docker.git /home/ec2-user/streamlit-app-docker
              
              # Instalar Docker
              sudo dnf install docker -y
              
              # Iniciar e habilitar Docker
              sudo systemctl start docker
              sudo systemctl enable docker
              
              # Adicionar o usuário ec2-user ao grupo Docker
              sudo usermod -aG docker ec2-user
              
              # Navegar para o diretório clonado
              cd /home/ec2-user/streamlit-app-docker

              # Construir a imagem docker
              docker build -t streamlit-app-docker .

              # Rodar a imagem
              docker run -p 80:80 streamlit-app-docker

              EOF

  tags = {
    Name = "MyEC2Instance"
  }
}
