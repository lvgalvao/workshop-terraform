# Projeto Terraform com Docker e Streamlit

Este projeto demonstra como usar o Terraform para provisionar um container Docker rodando uma aplicação Streamlit. O exemplo inclui a definição de uma aplicação Streamlit mínima, a criação de uma imagem Docker personalizada e o uso do Terraform para gerenciar o container.

## Pré-requisitos

- [Docker](https://www.docker.com/get-started)
- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install)

## Estrutura do Projeto

```
.
├── app.py
├── Dockerfile
├── main.tf
└── terraform.tfvars (opcional)
```

- **app.py**: Arquivo de aplicação Streamlit.
- **Dockerfile**: Dockerfile para criar a imagem Docker personalizada.
- **main.tf**: Arquivo de configuração do Terraform.
- **terraform.tfvars** (opcional): Arquivo para definir variáveis específicas do ambiente.

## Conteúdo dos Arquivos

### app.py

```python
import streamlit as st

st.title("Hello, Streamlit!")
st.write("This is a simple Streamlit application.")
```

### Dockerfile

```Dockerfile
FROM python:3.9

RUN pip install streamlit

COPY ./app.py /app/app.py

WORKDIR /app

ENTRYPOINT ["streamlit", "run"]
CMD ["app.py"]
```

### main.tf

```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

variable "docker_host" {
  description = "Docker host path"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "docker_image" "streamlit" {
  name         = "mystreamlitapp:latest"
  build {
    context = "."
  }
  keep_locally = false
}

resource "docker_container" "streamlit" {
  image = docker_image.streamlit.image_id
  name  = "streamlit_app_${random_string.suffix.result}"
  ports {
    internal = 8501
    external = 8501
  }
}

output "container_id" {
  value = docker_container.streamlit.id
}

output "container_name" {
  value = docker_container.streamlit.name
}
```

### terraform.tfvars (opcional)

```hcl
docker_host = "unix:///Users/lucianogalvao/.docker/run/docker.sock"
```

## Passos para Executar o Projeto

### Executando sem Alterar o Caminho do Docker

Por padrão, o Terraform usará o caminho do Docker host definido como `unix:///var/run/docker.sock`.

#### 1. Inicialize o Terraform

```bash
terraform init
```

#### 2. Crie um Plano de Execução

```bash
terraform plan
```

#### 3. Aplique o Plano

```bash
terraform apply
```

#### 4. Verifique a Aplicação

Abra um navegador e vá para `http://localhost:8501`. Você deve ver a aplicação Streamlit.

#### 5. Destrua a Infraestrutura (se necessário)

```bash
terraform destroy
```

### Executando com o Caminho do Docker Personalizado

Se precisar definir um caminho específico para o Docker host, você pode usar o arquivo `terraform.tfvars`.

### 0. Crie a imagem docker

```bash
docker build -t mystreamlitapp . 
```

#### 1. Defina o Caminho do Docker Host

Crie um arquivo `terraform.tfvars` no mesmo diretório que o `main.tf` com o seguinte conteúdo:

**terraform.tfvars**
```hcl
docker_host = "unix:///Users/lucianogalvao/.docker/run/docker.sock"
```

#### 2. Inicialize o Terraform

```bash
terraform init
```

#### 3. Crie um Plano de Execução

```bash
terraform plan -var-file="terraform.tfvars"
```

#### 4. Aplique o Plano

```bash
terraform apply -var-file="terraform.tfvars"
```

#### 5. Verifique a Aplicação

Abra um navegador e vá para `http://localhost:8501`. Você deve ver a aplicação Streamlit.

#### 6. Destrua a Infraestrutura (se necessário)

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Notas Adicionais

- Certifique-se de que o Docker está instalado e rodando no seu sistema.
- Certifique-se de que os arquivos `app.py` e `Dockerfile` estão no mesmo diretório onde você está executando o Terraform.
- Verifique a construção da imagem Docker com `docker images` para ver se a imagem `mystreamlitapp` foi construída corretamente.
- Verifique os containers em execução com `docker ps` para ver quais containers estão em execução e verifique se há um container chamado `streamlit_app_<random_suffix>`.

## Autor

Desenvolvido por Luciano Galvão