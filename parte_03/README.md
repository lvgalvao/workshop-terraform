# Executando Terraform no Docker

O comando abaixo é usado para executar o Terraform dentro de um contêiner Docker. Esta abordagem é útil quando você deseja isolar seu ambiente Terraform ou evitar a instalação do Terraform diretamente no seu sistema operacional.

```sh
docker run -it -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh
```

Vamos detalhar cada parte desse comando:

## Explicação do Comando

- `docker run`: Inicia um novo contêiner Docker.
- `-it`: As opções `-i` e `-t` combinadas permitem a execução interativa no terminal. `-i` mantém a entrada padrão aberta para o contêiner, e `-t` aloca um terminal TTY.
- `-v $PWD:/app`: Monta o diretório atual do host (representado por `$PWD`, que significa "present working directory") no diretório `/app` dentro do contêiner. Isso permite que o contêiner acesse os arquivos do diretório atual do host.
- `-w /app`: Define o diretório de trabalho dentro do contêiner para `/app`. Isso significa que todos os comandos serão executados nesse diretório.
- `--entrypoint ""`: Substitui o entrypoint padrão do contêiner (que é o comando que é executado por padrão quando o contêiner é iniciado). Aqui, é substituído por uma string vazia para que possamos fornecer nosso próprio comando a ser executado.
- `hashicorp/terraform:light`: Especifica a imagem Docker a ser usada. `hashicorp/terraform:light` é uma versão leve da imagem oficial do Terraform fornecida pela HashiCorp.
- `sh`: O comando `sh` abre um shell dentro do contêiner, permitindo que você execute comandos interativamente.

### Benefícios de Executar Terraform no Docker

1. **Isolamento do Ambiente:**
   - Evita conflitos com outras versões ou configurações do Terraform instaladas no sistema host.
   - Garante que o Terraform seja executado em um ambiente consistente, independentemente do sistema operacional do host.

2. **Facilidade de Configuração:**
   - Não requer instalação do Terraform no sistema host. Tudo é configurado e executado dentro do contêiner Docker.

3. **Portabilidade:**
   - Facilita a portabilidade do ambiente de desenvolvimento. Qualquer máquina que possa executar Docker pode usar essa configuração para rodar Terraform.

4. **Reprodutibilidade:**
   - Garante que o mesmo ambiente de execução seja usado em diferentes máquinas e contextos (desenvolvimento, CI/CD, etc.), reduzindo problemas relacionados a diferenças de ambiente.

#### Passos para Executar Terraform no Docker

1. **Instalar Docker:**
   - Certifique-se de que o Docker está instalado no seu sistema. Siga as instruções de instalação do Docker para seu sistema operacional específico.

2. **Navegar até o Diretório do Projeto:**
   - Abra o terminal e navegue até o diretório onde seus arquivos de configuração do Terraform estão localizados.

3. **Executar o Comando Docker:**
   - Execute o comando Docker mencionado acima para iniciar um contêiner com o Terraform:

     ```sh
     docker run -it -v $PWD:/app -w /app --entrypoint "" hashicorp/terraform:light sh
     ```

4. **Executar Comandos Terraform:**
   - Dentro do contêiner, você pode executar comandos Terraform como `terraform init`, `terraform plan`, `terraform apply`, etc.

     ```sh
     terraform init
     terraform plan
     terraform apply
     ```

### Exemplo de Uso

Suponha que você tenha um arquivo `main.tf` no diretório atual com a configuração do Terraform. Para inicializar e aplicar essa configuração usando Docker, você faria o seguinte:

1. **Inicializar o Terraform:**

   ```sh
   terraform init
   ```

2. **Planejar a Infraestrutura:**

   ```sh
   terraform plan
   ```

3. **Aplicar a Configuração:**

   ```sh
   terraform apply
   ```

Esse processo garante que toda a infraestrutura seja gerenciada de maneira consistente e reprodutível, utilizando a imagem Docker do Terraform.

### Vantagens de Armazenar o Estado do Terraform no S3

Armazenar o estado do Terraform em um bucket S3 oferece várias vantagens em comparação ao armazenamento local. Aqui estão alguns dos principais benefícios:

#### 1. **Colaboração**

- **Acesso Compartilhado:**
  - O estado armazenado no S3 pode ser acessado por múltiplos usuários e equipes, permitindo a colaboração eficiente no gerenciamento da infraestrutura.
  - Facilita o trabalho em equipe, onde diferentes membros podem aplicar mudanças e atualizações na infraestrutura de forma coordenada.

- **Bloqueio de Estado (State Locking):**
  - Quando combinado com o DynamoDB, o S3 permite o bloqueio do estado, prevenindo condições de corrida onde múltiplos usuários tentam modificar o estado simultaneamente.
  - Garante que apenas um processo do Terraform possa modificar o estado de cada vez, evitando inconsistências.

#### 2. **Persistência e Recuperação**

- **Backup Automático:**
  - O S3 oferece alta durabilidade e replicação de dados, garantindo que o estado do Terraform esteja seguro e disponível.
  - Facilita a recuperação em caso de falhas ou perda de dados, já que o estado pode ser restaurado a partir do S3.

- **Versão de Arquivos:**
  - O S3 suporta versionamento de arquivos, permitindo que você rastreie e restaure versões anteriores do estado do Terraform.
  - Importante para auditar mudanças e reverter para um estado anterior em caso de erro.

#### 3. **Escalabilidade e Desempenho**

- **Escalabilidade:**
  - O S3 é altamente escalável e pode lidar com grandes volumes de dados e requisições, suportando projetos Terraform de qualquer tamanho.
  - Adequado para ambientes de produção onde a infraestrutura pode crescer significativamente.

- **Desempenho:**
  - O S3 é otimizado para alta performance, garantindo acesso rápido e eficiente ao estado do Terraform.
  - Minimiza o tempo necessário para ler e escrever o estado durante operações do Terraform.

#### 4. **Segurança**

- **Controle de Acesso:**
  - O S3 permite a configuração de políticas de controle de acesso (IAM policies), garantindo que apenas usuários autorizados possam acessar e modificar o estado do Terraform.
  - Suporte para criptografia de dados em repouso e em trânsito, protegendo a confidencialidade e integridade do estado.

- **Auditoria:**
  - Com o AWS CloudTrail, você pode monitorar e registrar todas as atividades relacionadas ao acesso e modificação do estado no S3.
  - Facilita a auditoria de mudanças e o cumprimento de requisitos de conformidade.

#### Configuração do Backend S3 no Terraform

Aqui está um exemplo de como configurar o backend S3 para armazenar o estado do Terraform:

```hcl
terraform {
  backend "s3" {
    bucket         = "meu-bucket-terraform"
    key            = "caminho/para/estado/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true  # Ativa a criptografia
    dynamodb_table = "tabela-de-bloqueio-terraform"  # Requerido para state locking
  }
}
```

#### Passos para Configuração

1. **Criar um Bucket S3:**
   - Crie um bucket no S3 onde o estado será armazenado.
   - Habilite o versionamento no bucket para rastrear mudanças no estado.

2. **Configurar DynamoDB para State Locking:**
   - Crie uma tabela DynamoDB que o Terraform usará para bloquear o estado durante operações.
   - Configure o nome da tabela no backend S3 conforme mostrado no exemplo.

3. **Definir o Backend no Arquivo de Configuração:**
   - Adicione a configuração do backend S3 no arquivo de configuração do Terraform (`main.tf` ou equivalente).

4. **Inicializar o Backend:**
   - Execute `terraform init` para inicializar a configuração e migrar o estado local para o S3.

   ```sh
   terraform init
   ```

Ao seguir esses passos, você garante que o estado do Terraform seja armazenado de forma segura e colaborativa no S3, aproveitando todos os benefícios mencionados acima.

### Outputs e Data Sources no Terraform

No Terraform, `outputs` e `data sources` são dois conceitos importantes que ajudam a gerenciar e utilizar a infraestrutura de forma mais eficiente. Vamos entender cada um deles com base nos exemplos fornecidos.

#### Outputs

Os `outputs` no Terraform são usados para exportar valores de uma configuração para que possam ser facilmente acessados por outros módulos ou exibidos ao usuário após a execução do Terraform. Eles são definidos no arquivo `output.tf` e podem ser usados para retornar informações importantes sobre os recursos criados.

**Exemplo de Output:**

```hcl
output "ip_address" {
  value = aws_instance.web.public_ip
}
```

**Descrição:**
- **Nome do Output:** `ip_address` – Este é o identificador do output, que pode ser referenciado em outros lugares.
- **Valor do Output:** `aws_instance.web.public_ip` – Este é o valor que será exportado. No exemplo, estamos exportando o endereço IP público da instância EC2 chamada `web`.

**Benefícios dos Outputs:**
- **Facilidade de Acesso:** Outputs tornam fácil acessar informações importantes, como endereços IP, URLs, IDs de recursos, etc.
- **Reutilização:** Outputs podem ser referenciados em outras configurações do Terraform, facilitando a reutilização de valores.
- **Automatização:** Outputs podem ser usados em scripts ou integrações para automatizar tarefas após a criação da infraestrutura.

#### Data Sources

Os `data sources` permitem que o Terraform leia e utilize informações sobre recursos existentes que não são gerenciados pelo Terraform ou que foram criados por outros meios. Eles são definidos no arquivo de configuração e podem ser usados para buscar dados que podem ser referenciados em recursos gerenciados pelo Terraform.

**Exemplo de Data Source:**

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Ubuntu
}
```

**Descrição:**
- **Data Source:** `aws_ami` – Este data source é usado para buscar informações sobre uma Amazon Machine Image (AMI) existente.
- **Nome do Data Source:** `ubuntu` – Identificador do data source.
- **Parâmetros:**
  - **most_recent:** Define que o AMI mais recente deve ser selecionado.
  - **filter:** Aplica filtros para selecionar o AMI baseado em seu nome. No exemplo, ele busca AMIs que correspondem ao padrão `"ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"`.
  - **owners:** Define o proprietário do AMI. No exemplo, `099720109477` é o ID do proprietário das AMIs oficiais do Ubuntu.

**Benefícios dos Data Sources:**
- **Integração:** Permite integrar recursos existentes que não são gerenciados pelo Terraform.
- **Atualização Dinâmica:** Facilita o uso de informações dinâmicas, como buscar o AMI mais recente, sem a necessidade de atualização manual.
- **Flexibilidade:** Data sources oferecem flexibilidade ao permitir que você use dados externos em sua configuração do Terraform.

#### Exemplo Completo com Resource Referenciando Data Source

**Arquivo `ec2.tf`:**

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Ubuntu
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
```

**Descrição:**
- **Data Source:** `aws_ami.ubuntu` – Busca o AMI mais recente do Ubuntu 20.04.
- **Resource:** `aws_instance.web` – Cria uma instância EC2 usando o AMI obtido pelo data source.
  - **ami:** Refere-se ao ID do AMI obtido pelo data source `data.aws_ami.ubuntu.id`.
  - **instance_type:** Define o tipo da instância como `t2.micro`.
  - **tags:** Adiciona uma tag `Name` com valor `HelloWorld`.

#### Resumo:

- **Outputs:** Exportam valores de uma configuração para fácil acesso e reutilização. No exemplo, o endereço IP público da instância EC2 é exportado.
- **Data Sources:** Permitem buscar e usar informações sobre recursos existentes. No exemplo, busca o AMI mais recente do Ubuntu 20.04 e o usa para criar uma instância EC2.

Utilizar `outputs` e `data sources` de forma eficaz pode tornar suas configurações do Terraform mais flexíveis, reutilizáveis e integradas com recursos existentes na sua infraestrutura.