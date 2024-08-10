# Provisionamento de EC2 com Terraform

Este documento descreve como provisionar uma instância EC2 na AWS usando Terraform. A configuração inclui um script `user_data` que automatiza a instalação de dependências e o clonado de um repositório Git.

## Arquivo `main.tf`

O arquivo `main.tf` contém a configuração básica para criar uma instância EC2 e executar um conjunto de comandos de inicialização. 

### Conteúdo do Arquivo

```hcl
provider "aws" {
  region = "sa-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-09523541dfaa61c85" # Substitua pela AMI do Amazon Linux desejada
  instance_type = "t2.micro"              # Tipo da instância

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
              EOF

  tags = {
    Name = "MyEC2Instance"
  }
}
```

### Descrição dos Componentes

1. **Provider AWS**:
   ```hcl
   provider "aws" {
     region = "sa-east-1"
   }
   ```
   Define a região onde a instância EC2 será criada.

2. **Recurso `aws_instance`**:
   ```hcl
   resource "aws_instance" "example" {
     ami           = "ami-09523541dfaa61c85" # Substitua pela AMI do Amazon Linux desejada
     instance_type = "t2.micro"              # Tipo da instância
   ```
   Especifica a AMI e o tipo de instância para a criação.

3. **`user_data`**:
   ```bash
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
   ```
   O `user_data` é um script de inicialização que executa comandos ao iniciar a instância:
   - **Atualiza o sistema**: Garante que todos os pacotes estão atualizados.
   - **Instala Git**: Permite o gerenciamento de código-fonte.
   - **Clona o repositório Git**: Baixa o repositório com o aplicativo Streamlit.
   - **Instala Docker**: Permite a execução de contêineres.
   - **Inicia e habilita Docker**: Garante que o Docker esteja em execução e será iniciado na inicialização.
   - **Adiciona `ec2-user` ao grupo Docker**: Permite ao usuário executar Docker sem `sudo`.
   - **Navega para o diretório clonado**: Posiciona-se no diretório do projeto clonado.

4. **Tags**:
   ```hcl
   tags = {
     Name = "MyEC2Instance"
   }
   ```
   Define tags para identificar e organizar a instância na AWS.

## Como Usar

1. **Inicialize o Terraform**:
   No diretório onde está o arquivo `main.tf`, execute:
   ```sh
   terraform init
   ```

2. **Visualize o Plano**:
   Verifique o que será criado antes de aplicar:
   ```sh
   terraform plan
   ```

3. **Aplique as Mudanças**:
   Crie a instância EC2 e execute o script `user_data`:
   ```sh
   terraform apply
   ```

4. **Verifique a Instância**:
   Após a aplicação, você pode acessar a instância EC2 para garantir que o Git, Docker e o repositório foram configurados corretamente.

Este arquivo Terraform configura uma instância EC2 básica com todas as ferramentas necessárias para desenvolvimento e testes. O uso do `user_data` permite uma configuração automatizada e eficiente da instância durante a criação.

## Criando multiplos ambientes