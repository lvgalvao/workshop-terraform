No Terraform, variáveis são usadas para parametrizar e modularizar suas configurações de infraestrutura, tornando-as mais flexíveis e reutilizáveis. Elas permitem que você defina valores que podem ser usados em vários lugares do seu código Terraform e que podem ser modificados facilmente sem alterar o código principal.

### **Variáveis em Terraform**

#### **Definição de Variáveis**

As variáveis são definidas em arquivos `.tf` usando o bloco `variable`. Um exemplo básico de definição de variável é:

```hcl
variable "instance_type" {
  description = "Tipo de instância EC2 a ser utilizado"
  type        = string
  default     = "t2.micro"
}
```

- **`description`**: Uma breve descrição do que a variável representa.
- **`type`**: O tipo de dado da variável (por exemplo, `string`, `number`, `bool`, `list`, `map`).
- **`default`**: Um valor padrão para a variável (opcional).

#### **Uso de Variáveis**

As variáveis definidas podem ser usadas em recursos e módulos Terraform:

```hcl
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

### **Validadores de Variáveis**

Os validadores de variáveis ajudam a garantir que os valores fornecidos para as variáveis estejam no formato correto e atendam a critérios específicos. Eles são definidos dentro do bloco `validation` dentro da definição da variável.

#### **Exemplo de Validação**

```hcl
variable "image_id" {
  description = "ID da imagem (AMI) a ser usada para a instância."
  type        = string
  default     = "ami-0870650fde0fef2d4"

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "O valor do image_id deve ser um ID de AMI válido, começando com 'ami-'."
  }
}
```

- **`condition`**: Uma expressão que deve ser verdadeira para que o valor da variável seja considerado válido. Pode usar funções e operadores para criar condições complexas.
- **`error_message`**: Mensagem exibida se a condição não for atendida, ajudando a orientar o usuário sobre o que está errado com o valor fornecido.

### **Outros Tipos de Validação**

- **Range de Números**:
  ```hcl
  variable "instance_count" {
    description = "Número de instâncias a serem criadas"
    type        = number
    default     = 1

    validation {
      condition     = var.instance_count > 0
      error_message = "O número de instâncias deve ser maior que 0."
    }
  }
  ```

- **Valores Permitidos**:
  ```hcl
  variable "environment" {
    description = "Ambiente de implantação"
    type        = string
    default     = "development"

    validation {
      condition     = var.environment in ["development", "staging", "production"]
      error_message = "O ambiente deve ser um dos seguintes: development, staging, production."
    }
  }
  ```

### **Uso de Variáveis no Terraform CLI**

As variáveis podem ser fornecidas de várias maneiras:

1. **Arquivos de Variáveis (`.tfvars`)**:
   ```hcl
   instance_type = "t2.large"
   ```

   Arquivo `terraform.tfvars`:
   ```hcl
   instance_type = "t2.large"
   ```

2. **Linha de Comando**:
   ```bash
   terraform apply -var="instance_type=t2.large"
   ```

3. **Variáveis de Ambiente**:
   ```bash
   export TF_VAR_instance_type="t2.large"
   ```

### **Resumo**

- **Variáveis**: Facilitam a parametrização e reutilização de configurações.
- **Validadores**: Garantem que os valores das variáveis atendam a critérios específicos, evitando erros e garantindo a integridade da configuração.

O uso adequado de variáveis e validadores ajuda a criar configurações mais robustas e flexíveis no Terraform, promovendo melhores práticas e reduzindo a probabilidade de erros.