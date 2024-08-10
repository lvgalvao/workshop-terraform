# README - Gerenciamento de Múltiplos Recursos com Terraform

## Introdução

Este documento fornece uma visão geral sobre como criar e gerenciar múltiplos recursos em Terraform, utilizando o parâmetro `count` para instâncias EC2 e acessando atributos de recursos de forma apropriada.

## Criando Múltiplas Instâncias EC2

Para criar múltiplas instâncias EC2 com Terraform, você pode usar o parâmetro `count` dentro do bloco de recurso. Este parâmetro define quantas instâncias serão criadas com base na configuração fornecida.

### Exemplo de Configuração

```hcl
# Instância EC2 na subnet pública
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

### Explicação

- **`count = 2`**: Cria duas instâncias EC2 com base na configuração.
- **`count.index`**: Usado para gerar um nome único e diferenciar instâncias.

## Acessando Atributos de Recursos

Quando você cria múltiplas instâncias ou recursos, é necessário acessar atributos específicos de cada instância. Isso é feito usando o índice do `count` ou criando listas de atributos.

### Exemplo de Acesso com Índices

```hcl
output "ec2_public_ip_instance_1" {
  value = aws_instance.web[0].public_ip
}

output "ec2_public_ip_instance_2" {
  value = aws_instance.web[1].public_ip
}

output "ec2_id_instance_1" {
  value = aws_instance.web[0].id
}

output "ec2_id_instance_2" {
  value = aws_instance.web[1].id
}
```

### Exemplo de Acesso com Listas

```hcl
output "ec2_public_ip" {
  value = [for instance in aws_instance.web : instance.public_ip]
}

output "ec2_id" {
  value = [for instance in aws_instance.web : instance.id]
}
```

### Explicação

- **Referência de Índice**: Usando `aws_instance.web[0].public_ip` para acessar o IP da primeira instância.
- **Referência de Lista**: Criando uma lista de IPs públicos para todas as instâncias com `[for instance in aws_instance.web : instance.public_ip]`.

## Conclusão

O uso de `count` permite criar múltiplos recursos com uma configuração comum. Para acessar atributos desses recursos, utilize índices ou crie listas conforme necessário. Essas técnicas ajudam a gerenciar e acessar atributos de recursos de forma eficaz em ambientes de infraestrutura como código.
