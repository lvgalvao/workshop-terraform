# README - Alteração do Tamanho da Instância PostgreSQL com Terraform

## Introdução

Este documento descreve como alterar o tamanho da instância do PostgreSQL em uma configuração Terraform. A alteração do tamanho pode ser necessária para atender a novas demandas de desempenho ou armazenamento.

## Atualizando o Tamanho da Instância PostgreSQL

Para alterar o tamanho da instância PostgreSQL, você deve modificar o atributo `instance_class` no recurso `aws_db_instance` da configuração Terraform. Além disso, é possível ajustar o armazenamento alocado se necessário.

### Passos para Atualizar o Tamanho da Instância

1. **Localize o Recurso PostgreSQL**

   Encontre o recurso `aws_db_instance` em sua configuração Terraform. Aqui está um exemplo de configuração inicial:

   ```hcl
   # RDS PostgreSQL com Multi-AZ Desativado
   resource "aws_db_instance" "postgres" {
     engine            = "postgres"
     engine_version    = "16.3"
     instance_class    = "db.t3.micro"  # Classe de instância inicial
     allocated_storage = 20  # Armazenamento inicial
     db_name           = var.db_name
     username          = var.db_username
     password          = var.db_password
     publicly_accessible = false
     multi_az          = false
     vpc_security_group_ids = [aws_security_group.allow_ec2_rds.id]
     db_subnet_group_name = aws_db_subnet_group.postgres.name
     skip_final_snapshot = true

     tags = {
       Name = "PostgresDBInstance"
     }
   }
   ```

2. **Atualize a Classe de Instância**

   Modifique o atributo `instance_class` para refletir o novo tamanho desejado. Por exemplo, para aumentar o tamanho, você pode usar `"db.t3.medium"`:

   ```hcl
   instance_class = "db.t3.medium"  # Atualize para o tamanho desejado
   ```

3. **Ajuste o Armazenamento Alocado (Opcional)**

   Se necessário, ajuste o valor de `allocated_storage` para a nova quantidade de armazenamento desejada:

   ```hcl
   allocated_storage = 100  # Atualize para o novo tamanho de armazenamento
   ```

4. **Aplique as Alterações**

   Após atualizar a configuração, aplique as mudanças usando o comando:

   ```bash
   terraform apply
   ```

   Terraform identificará as mudanças e aplicará as atualizações necessárias na instância do PostgreSQL.

## Considerações Adicionais

- **Manutenção e Impacto**:
  - Alterar o tamanho da instância pode causar um breve período de manutenção. Planeje essas mudanças fora do horário de pico para minimizar o impacto.

- **Verificar Tamanhos Disponíveis**:
  - Consulte a documentação da AWS para garantir que a classe de instância selecionada está disponível na região e atende aos seus requisitos.

- **Ajustes de Performance**:
  - Selecione uma classe de instância que atenda às suas necessidades de desempenho e capacidade. Instâncias maiores oferecem mais recursos, mas também podem aumentar os custos.

- **Monitoramento e Escalabilidade**:
  - Após a atualização, monitore o desempenho da instância e ajuste conforme necessário para otimizar a operação do banco de dados.

## Conclusão

Alterar o tamanho da instância PostgreSQL com Terraform é um processo simples que envolve atualizar a configuração e aplicar as mudanças. Seguindo os passos descritos, você pode ajustar o tamanho da instância para atender às suas necessidades de desempenho e armazenamento.