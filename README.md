# Workshop de Terraform para Profissionais de Dados

Bem-vindo ao **Workshop de Terraform para Profissionais de Dados**! Este projeto faz parte de um workshop prático exclusivo para os alunos da **Escola Jornada de Dados**.

![Imagem](./pics/terraform.jpeg)

## Sobre o Workshop

**Data:** Sábado, 10 de Agosto  
**Horário:** 9:00 da manhã  
**Duração:** 4 horas  
**Público:** Exclusivo para alunos da Jornada de Dados

### Objetivos do Workshop

- Introduzir os conceitos do Terraform.
- Capacitar os alunos a gerenciar e automatizar a infraestrutura de cloud com foco em AWS.
- Demonstrar práticas recomendadas para o uso do Terraform em ambientes de produção.

Obrigado pela atualização! Aqui está a pauta ajustada para o workshop de Terraform, com o horário correto:

### 1. Abertura - O que queremos resolver? (9:00 - 9:30)

![imagem_01](/pics/01.png)

   - **Objetivo**: Introduzir o Terraform, discutindo a importância de automação e a infraestrutura como código (IaC) para engenheiros de dados.
   - **Atividades**:
     - Apresentação dos objetivos do treinamento.
     - Discussão sobre os desafios de gerenciar infraestrutura em nuvem manualmente e como o Terraform pode ajudar.

### 2. Subindo uma aplicação de API sem Terraform na AWS (9:30 - 10:00)

![imagem_02](/pics/02.jpeg)

   - **Objetivo**: Demonstrar o processo manual de deploy de uma aplicação de API na AWS, sem utilizar Terraform.
   - **Atividades**:
     - Configuração manual da infraestrutura (EC2, Security Groups, etc.).
     - Deploy manual da aplicação API.
     - Discussão sobre as limitações desse processo manual.

![imagem_03](/pics/03.png)

### 3. Subindo a mesma aplicação utilizando Terraform e comparações (10:00 - 10:30)
   - **Objetivo**: Mostrar como o Terraform pode automatizar o processo anterior e comparar as duas abordagens.
   - **Atividades**:
     - Criação e execução de um script Terraform para replicar a infraestrutura e aplicação.
     - Comparação dos métodos manual e automatizado.
     - Discussão sobre boas práticas no uso do Terraform.

### 4. Trabalhando com Terraform sem gastar nada utilizando LocalStack (10:30 - 11:00)
   - **Objetivo**: Demonstrar como usar o LocalStack para simular serviços AWS localmente.
   - **Atividades**:
     - Configuração do LocalStack.
     - Execução de scripts Terraform no ambiente simulado.
     - Discussão sobre as limitações e usos práticos do LocalStack.

### Parte 5: Modularização e Configuração de um Dashboard com Porta Liberada Externa e IP Fixo na AWS (11:00 - 11:30)

Demonstrar como modularizar o código Terraform para configurar um dashboard na AWS com acesso externo e IP fixo, garantindo reutilização e manutenção eficiente do código.

1. **Introdução à Modularização do Terraform:**
   - **Criação de Módulos**:
     - **Módulo de EC2**: Contendo a lógica para criar instâncias EC2.
     - **Módulo de Security Groups**: Contendo a lógica para configurar as regras de segurança.
     - **Módulo de EIP (Elastic IP)**: Contendo a lógica para associar um IP fixo à instância EC2.

2. **Configuração do Dashboard na AWS Usando Módulos**:
   - Utilização dos módulos criados para configurar a infraestrutura necessária para o dashboard.
   - Aplicação dos módulos para provisionar a instância EC2, configurar os Security Groups, e associar o IP fixo.

3. **Testes de Acesso Externo**:
   - Validar o acesso externo ao dashboard através do IP fixo configurado.

#### Organograma da Aplicação

```mermaid
graph TD
    A[Usuário] --> B[HTTP Request]
    B --> C[EC2 Instance: Dashboard]
    C --> D[(RDS: Banco de Dados)]
    C --> E[Security Groups Configurado via Módulo]
    E --> F[IP Fixo Configurado via Módulo]
```

### Parte 6: Estado do Terraform e Revisão do Código com Uso de Buckets S3 (11:30 - 12:00)

Abordar o gerenciamento de estado no Terraform utilizando um bucket S3, além de revisar o código para garantir sua modularização, reutilização e manutenção eficaz.

#### Atividades

1. **Introdução ao Estado do Terraform:**
   - Explicar a importância do estado no Terraform para o gerenciamento de infraestrutura.
   - Discussão sobre os desafios de gerenciar o estado localmente versus em um backend remoto.

2. **Configuração de Backend Remoto com Bucket S3:**
   - Configuração de um bucket S3 para armazenar o estado do Terraform.
   - Configuração do backend do Terraform para utilizar o bucket S3:
     ```hcl
     terraform {
       backend "s3" {
         bucket = "meu-bucket-terraform"
         key    = "estado/terraform.tfstate"
         region = "us-east-1"
       }
     }
     ```

3. **Revisão do Código Modularizado:**
   - Revisão dos módulos criados na parte anterior (EC2, Security Groups, EIP).
   - Discussão sobre boas práticas na organização do código, garantindo que ele esteja bem estruturado e fácil de manter.
   - Aplicação dos módulos em diferentes cenários para demonstrar sua reutilização.

#### Diagrama de Fluxo do Estado no S3

```mermaid
graph TD
    A[Terraform Apply] --> B[Verificação de Estado]
    B --> C[Bucket S3 com Estado Remoto]
    C --> D[Provisionamento de Infraestrutura]
    D --> E[Atualização do Estado no S3]
    E --> F[Revisão e Manutenção do Código Modularizado]
```

### 7. Case final: Migração do projeto da AWS para a Azure (12:00 - 12:30)
   - **Objetivo**: Demonstrar a migração de uma infraestrutura da AWS para a Azure usando Terraform.
   - **Atividades**:
     - Planejamento da migração e ajustes no código.
     - Execução da migração passo a passo.
     - Validação na Azure.

### 8. Passo a passo: Como migrar projeto em Terraform entre diferentes provedores de nuvem (12:30 - 13:00)
   - **Objetivo**: Adaptar o código Terraform para diferentes provedores de nuvem, focando em AWS e Azure.
   - **Atividades**:
     - Análise das diferenças entre provedores.
     - Ajustes no código para suporte multi-cloud.
     - Discussão sobre os desafios e soluções na migração multi-cloud.

## O que é o Terraform

### O que é Terraform?

Terraform é a ferramenta de infraestrutura como código (IaC) da HashiCorp. Permite definir recursos e infraestrutura em arquivos de configuração declarativos e legíveis por humanos, gerenciando o ciclo de vida da sua infraestrutura. O uso do Terraform oferece várias vantagens sobre a gestão manual da infraestrutura:

- **Gerenciamento Multicloud**: O Terraform pode gerenciar infraestruturas em várias plataformas de cloud.
- **Linguagem de Configuração Legível**: A linguagem de configuração do Terraform ajuda a escrever código de infraestrutura rapidamente.
- **Rastreamento de Estado**: O estado do Terraform permite acompanhar as mudanças nos recursos ao longo dos seus deployments.
- **Controle de Versão**: Você pode cometer suas configurações em sistemas de controle de versão para colaborar de forma segura na infraestrutura.

### Gerencie Qualquer Infraestrutura

Os plugins do Terraform, chamados de providers, permitem que ele interaja com plataformas de cloud e outros serviços através de suas APIs. A HashiCorp e a comunidade Terraform escreveram mais de 1.000 providers para gerenciar recursos na Amazon Web Services (AWS), Azure, Google Cloud Platform (GCP), Kubernetes, Helm, GitHub, Splunk e DataDog, entre outros. Você pode encontrar providers para muitas das plataformas e serviços que já usa no Terraform Registry. Se não encontrar o provider que procura, pode escrever o seu próprio.

### Padronize seu Fluxo de Trabalho de Deployment

Os providers definem unidades individuais de infraestrutura, como instâncias de computação ou redes privadas, como recursos. Você pode compor recursos de diferentes providers em configurações reutilizáveis chamadas módulos e gerenciá-los com uma linguagem e fluxo de trabalho consistentes.

A linguagem de configuração do Terraform é declarativa, o que significa que descreve o estado final desejado para sua infraestrutura, em contraste com linguagens de programação procedurais que exigem instruções passo a passo para realizar tarefas. Os providers do Terraform calculam automaticamente as dependências entre recursos para criá-los ou destruí-los na ordem correta.

### Fluxo de Trabalho de Deployment do Terraform

Para implantar infraestrutura com o Terraform:

1. **Escopo**: Identifique a infraestrutura para o seu projeto.
2. **Autor**: Escreva a configuração para sua infraestrutura.
3. **Inicialize**: Instale os plugins que o Terraform precisa para gerenciar a infraestrutura.
4. **Planeje**: Veja uma prévia das mudanças que o Terraform fará para corresponder à sua configuração.
5. **Aplique**: Realize as mudanças planejadas.

### Rastreie sua Infraestrutura

O Terraform acompanha sua infraestrutura real em um arquivo de estado, que atua como uma fonte de verdade para seu ambiente. O Terraform usa o arquivo de estado para determinar as mudanças a serem feitas na sua infraestrutura para que ela corresponda à sua configuração.

### Colabore

O Terraform permite que você colabore na sua infraestrutura com seus backends de estado remoto. Quando você usa o HCP Terraform (gratuito para até cinco usuários), pode compartilhar seu estado com segurança com sua equipe, fornecer um ambiente estável para o Terraform operar e prevenir condições de corrida quando várias pessoas fazem mudanças na configuração ao mesmo tempo.

Você também pode conectar o HCP Terraform a sistemas de controle de versão (VCS) como GitHub, GitLab e outros, permitindo que ele proponha automaticamente mudanças na infraestrutura quando você comete mudanças na configuração para o VCS. Isso permite gerenciar mudanças na sua infraestrutura através do controle de versão, assim como faria com código de aplicação.

### Arquitetura Terraform

```mermaid
graph TD;
    subgraph Arquivos_Locais
        A[main.tf]
        C[variables.tf]
        D[outputs.tf]
        E[terraform.tfstate]
    end

    subgraph Cloud
        G[AWS API]
        H[Infraestrutura AWS]
        F[Backend Remoto]
    end

    subgraph Terraform_CLI
        B[Binário do Terraform]
    end

    Arquivos_Locais --> |define recursos, variáveis e outputs| B
    E --> |armazena estado| B
    B --> |consulta estado| G
    G --> |retorna estado| B
    B --> |gerencia| H
    B --> |armazena estado| F
```

### Descrição da Estrutura

1. **Arquivos Locais**:
    - `main.tf`: Define os recursos que serão gerenciados pelo Terraform.
    - `variables.tf`: Define as variáveis que podem ser usadas em `main.tf` e outros arquivos.
    - `outputs.tf`: Define os outputs que serão retornados após a aplicação das configurações.
    - `terraform.tfstate`: Armazena o estado atual da infraestrutura gerenciada pelo Terraform.

2. **Terraform CLI**:
    - Binário do Terraform que lê os arquivos `.tf`, aplica as configurações e gerencia o estado.

3. **Cloud**:
    - `AWS API`: Interface de programação de aplicativos que o Terraform usa para consultar o estado atual da infraestrutura na AWS.
    - `AWS Infrastructure`: Representa a infraestrutura na AWS gerenciada pelo Terraform.
    - `Remote Backend`: Pode ser usado para armazenar o estado do Terraform remotamente (ex.: S3, Azure Blob Storage, etc.).