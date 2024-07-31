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
└── main.tf
```

- **app.py**: Arquivo de aplicação Streamlit.
- **Dockerfile**: Dockerfile para criar a imagem Docker personalizada.
- **main.tf**: Arquivo de configuração do Terraform.

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
  host = "unix:///var/run/docker.sock"
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

## Passos para Executar o Projeto

### 1. Inicialize o Terraform

```bash
terraform init
```

### 2. Crie um Plano de Execução

```bash
terraform plan
```

### 3. Aplique o Plano

```bash
terraform apply
```

### 4. Verifique a Aplicação

Abra um navegador e vá para `http://localhost:8501`. Você deve ver a aplicação Streamlit.

### 5. Destrua a Infraestrutura (se necessário)

```bash
terraform destroy
```

## Notas Adicionais

- Certifique-se de que o Docker está instalado e rodando no seu sistema.
- Certifique-se de que os arquivos `app.py` e `Dockerfile` estão no mesmo diretório onde você está executando o Terraform.
- Verifique a construção da imagem Docker com `docker images` para ver se a imagem `mystreamlitapp` foi construída corretamente.
- Verifique os containers em execução com `docker ps` para ver quais containers estão em execução e verifique se há um container chamado `streamlit_app_<random_suffix>`.

## Autor

Desenvolvido por Luciano Vasconcelos