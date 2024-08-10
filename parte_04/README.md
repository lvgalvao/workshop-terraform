### README.md

# Terraform AWS Infrastructure Setup

Este projeto configura uma infraestrutura básica na AWS utilizando Terraform. A infraestrutura inclui uma VPC personalizada, subnets públicas e privadas, uma instância EC2 e um banco de dados RDS PostgreSQL.

![imagem](/arquitetura.png)

## Arquivos do Projeto

- `main.tf`: Define os recursos principais da AWS, como VPC, subnets, security groups, instância EC2 e RDS PostgreSQL.
- `outputs.tf`: Define os outputs que o Terraform fornecerá após a execução, como os IDs e endereços IP.
- `variables.tf`: Define as variáveis que serão usadas no Terraform para configurar o banco de dados RDS.
- `terraform.tfvars`: Define os valores das variáveis que serão passados para o Terraform.

## Explicação de Cada Bloco de Código

### 1. `provider "aws"` - Provedor AWS

```hcl
provider "aws" {
  region = "sa-east-1"
}
```

Este bloco especifica o provedor AWS e a região onde os recursos serão criados. No caso, a região é `sa-east-1` (São Paulo).

### 2. `aws_vpc` - Virtual Private Cloud (VPC)

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}
```

Este bloco cria uma VPC com o bloco CIDR `10.0.0.0/16`. A VPC serve como a rede virtual onde todos os outros recursos serão criados.

### 3. `aws_subnet` - Subnets Públicas e Privadas

- **Subnets Públicas**:

```hcl
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1a"

  tags = {
    Name = "PublicSubnetA"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "sa-east-1b"

  tags = {
    Name = "PublicSubnetB"
  }
}
```

Esses blocos criam duas subnets públicas em diferentes zonas de disponibilidade (`sa-east-1a` e `sa-east-1b`). As subnets públicas são usadas para hospedar a instância EC2.

- **Subnets Privadas**:

```hcl
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "PrivateSubnetA"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "PrivateSubnetB"
  }
}
```

Esses blocos criam duas subnets privadas em diferentes zonas de disponibilidade (`sa-east-1a` e `sa-east-1b`). As subnets privadas são usadas para o banco de dados RDS, garantindo que ele não seja acessível diretamente da internet.

Criar múltiplas subnets, tanto públicas quanto privadas, em diferentes Zonas de Disponibilidade (AZs) é uma prática comum em arquiteturas de infraestrutura na nuvem, especialmente na AWS. Vou explicar o motivo disso:

### 1. **Alta Disponibilidade**

- **Zonas de Disponibilidade (AZs)**: Cada região da AWS é composta por múltiplas Zonas de Disponibilidade, que são centros de dados fisicamente separados e independentes dentro de uma mesma região. Se uma AZ falhar, os recursos em outra AZ continuarão funcionando.
- **Redundância**: Ao criar subnets em diferentes AZs, você garante que seus recursos estejam distribuídos geograficamente dentro da mesma região. Isso protege sua aplicação contra falhas em uma única AZ. Por exemplo, se você tiver uma instância EC2 em `sa-east-1a` e outra em `sa-east-1b`, uma falha em `sa-east-1a` não afetará a instância em `sa-east-1b`.

### 2. **Melhor Performance e Failover**

- **Load Balancing**: Com múltiplas subnets públicas, você pode distribuir o tráfego de entrada de forma mais eficiente. Um balanceador de carga (ELB) pode ser configurado para distribuir o tráfego entre instâncias EC2 em diferentes AZs.
- **Failover Automático**: Para bancos de dados como o RDS, a AWS pode configurar automaticamente o failover para uma réplica em uma AZ diferente em caso de falha da AZ principal. Para suportar esse cenário, você precisa de subnets em diferentes AZs.

### 3. **Conformidade e Resiliência**

- **Conformidade com Padrões de Indústria**: Muitas arquiteturas de referência da AWS e práticas recomendadas de segurança e conformidade exigem a distribuição de recursos em várias AZs para atender a requisitos de resiliência e conformidade.
- **Redução de Latência**: Ter instâncias em diferentes AZs permite que você atenda melhor a usuários de diferentes partes da região, minimizando a latência.

### 4. **Backup e Recuperação de Desastres**

- **Planejamento para Recuperação de Desastres**: Ao distribuir seus recursos em várias AZs, você pode planejar melhor para cenários de recuperação de desastres, garantindo que a perda de uma AZ não afete totalmente sua aplicação.
- **Redundância de Banco de Dados**: Para bancos de dados críticos, como o RDS, você pode configurar réplicas em diferentes AZs para garantir que seus dados estejam seguros e acessíveis mesmo em caso de falhas.

### Resumindo

- **Subnets Públicas em Múltiplas AZs**: São usadas para hospedar instâncias EC2 e outros recursos que precisam de acesso à internet. Ter duas subnets públicas em diferentes AZs garante que o tráfego de entrada possa ser gerenciado mesmo em caso de falha em uma AZ.
  
- **Subnets Privadas em Múltiplas AZs**: São usadas para hospedar recursos que não precisam de acesso direto à internet, como bancos de dados e servidores de aplicativos. Ter duas subnets privadas em diferentes AZs garante que esses recursos possam continuar funcionando e acessíveis mesmo em caso de falha em uma AZ.

### Quando Você Pode Não Precisar de Múltiplas Subnets

- **Ambientes de Desenvolvimento ou Teste**: Se você está apenas criando um ambiente para desenvolvimento ou teste, ou se a alta disponibilidade não é uma preocupação, você pode simplificar criando apenas uma subnet pública e uma privada.
- **Redução de Custo**: Em alguns casos, se você deseja reduzir os custos e a complexidade, pode optar por usar apenas uma AZ, embora isso sacrifique a alta disponibilidade.

Por fim, a decisão de usar múltiplas subnets em diferentes AZs geralmente depende do requisito de alta disponibilidade, resiliência e conformidade da sua aplicação.

### 4. `aws_internet_gateway` - Gateway de Internet

```hcl
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MainInternetGateway"
  }
}
```

Este bloco cria um gateway de internet, permitindo que os recursos dentro da VPC tenham acesso à internet. É necessário para permitir que as instâncias EC2 em subnets públicas se conectem à internet.

### 5. `aws_route_table` e `aws_route_table_association` - Tabelas de Roteamento

- **Tabela de Roteamento**:

```hcl
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
```

Este bloco cria uma tabela de roteamento para a VPC, permitindo que o tráfego de saída vá para a internet através do gateway de internet.

- **Associações de Tabela de Roteamento**:

```hcl
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
```

Esses blocos associam a tabela de roteamento pública às subnets públicas, permitindo que as instâncias nessas subnets se conectem à internet.

### 6. `aws_security_group` - Grupo de Segurança

```hcl
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
```

Este bloco cria um grupo de segurança que permite:

- Acesso ao PostgreSQL na porta 5432, mas apenas dentro da VPC.
- Acesso SSH na porta 22 de qualquer lugar (pode ser restrito a IPs específicos para maior segurança).
- Acesso HTTP na porta 80 de qualquer lugar.

### 7. `aws_db_subnet_group` e `aws_db_instance` - RDS PostgreSQL

- **Subnets do RDS**:

```hcl
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
```

Este bloco cria um grupo de subnets para o RDS PostgreSQL, utilizando as subnets privadas para garantir que o banco de dados esteja protegido.

- **Instância do RDS PostgreSQL**:

```hcl
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
```

Este bloco cria uma instância do RDS PostgreSQL, configurada para não ser acessível publicamente e com Multi-AZ desativado para um ambiente de desenvolvimento.

### 8. `aws_instance` - Instância EC2

```hcl
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
```

## Caso eu queira 2 instancias do EC2?

```hcl
resource "aws_instance" "web" {
  count         = 2
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
    Name = "MyEC2Instance-${count.index + 1}"
  }
}
```