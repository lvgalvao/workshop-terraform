# Parte 8: Migração Multi-Cloud com Terraform

## Objetivo

Na última parte do workshop, exploraremos como adaptar um projeto Terraform para ser compatível com múltiplos provedores de nuvem (AWS e Azure). Vamos discutir as diferenças entre os provedores e como ajustar o código para suportar uma infraestrutura multi-cloud.

### Passos para Implementação Multi-Cloud

1. **Análise das Diferenças entre Provedores:**
   - Identificar as principais diferenças nos recursos e configurações entre AWS e Azure.
   - Revisar as documentações específicas dos provedores para entender as limitações e considerações.

Claro! Vou criar um diagrama usando Mermaid que compara os recursos da AWS com os recursos equivalentes da Azure. O diagrama mostrará a arquitetura atual com AWS e a arquitetura planejada com Azure.

### Diagrama Mermaid

```mermaid
graph TD
    subgraph AWS
        VPC_AWS[VPC]
        Subnet_Public_A_AWS[Subnet Pública A]
        Subnet_Public_B_AWS[Subnet Pública B]
        Subnet_Private_A_AWS[Subnet Privada A]
        Subnet_Private_B_AWS[Subnet Privada B]
        IGW_AWS[Internet Gateway]
        RT_Public_AWS[Route Table Pública]
        SG_AWS[Security Group]
        EC2_AWS[EC2 Instance]
        RDS_AWS[RDS PostgreSQL]
    end
    
    subgraph Azure
        RG_AZURE[Resource Group]
        VNET_AZURE[Virtual Network]
        Subnet_Public_A_AZURE[Public Subnet A]
        Subnet_Private_A_AZURE[Private Subnet A]
        NSG_AZURE[Network Security Group]
        VM_AZURE[Virtual Machine]
        SQL_AZURE[SQL Database]
    end

    VPC_AWS -->|Contains| Subnet_Public_A_AWS
    VPC_AWS -->|Contains| Subnet_Public_B_AWS
    VPC_AWS -->|Contains| Subnet_Private_A_AWS
    VPC_AWS -->|Contains| Subnet_Private_B_AWS
    VPC_AWS -->|Contains| IGW_AWS
    VPC_AWS -->|Uses| RT_Public_AWS
    VPC_AWS -->|Uses| SG_AWS
    VPC_AWS -->|Contains| EC2_AWS
    VPC_AWS -->|Contains| RDS_AWS
    
    RG_AZURE -->|Contains| VNET_AZURE
    VNET_AZURE -->|Contains| Subnet_Public_A_AZURE
    VNET_AZURE -->|Contains| Subnet_Private_A_AZURE
    VNET_AZURE -->|Uses| NSG_AZURE
    VNET_AZURE -->|Contains| VM_AZURE
    VNET_AZURE -->|Contains| SQL_AZURE

    Subnet_Public_A_AWS --> IGW_AWS
    Subnet_Public_A_AWS --> RT_Public_AWS
    Subnet_Private_A_AWS --> SG_AWS

    Subnet_Public_A_AZURE -->|Uses| NSG_AZURE
    Subnet_Private_A_AZURE -->|Uses| NSG_AZURE

    EC2_AWS -->|Connects to| RDS_AWS
    VM_AZURE -->|Connects to| SQL_AZURE
```

### Descrição das Equivalências

- **VPC (AWS)** ↔ **Virtual Network (Azure)**
- **Subnet Pública (AWS)** ↔ **Public Subnet (Azure)**
- **Subnet Privada (AWS)** ↔ **Private Subnet (Azure)**
- **Internet Gateway (AWS)** ↔ **Não há um equivalente direto; a funcionalidade é geralmente gerida pelo Route Table e Network Security Group na Azure.**
- **Route Table (AWS)** ↔ **Network Security Group (Azure)**
- **Security Group (AWS)** ↔ **Network Security Group (Azure)**
- **EC2 Instance (AWS)** ↔ **Virtual Machine (Azure)**
- **RDS PostgreSQL (AWS)** ↔ **SQL Database (Azure)**

Esse diagrama ajuda a visualizar as correspondências entre os recursos da AWS e os recursos equivalentes da Azure para facilitar a migração. Se precisar de mais detalhes ou ajustes, é só avisar!

2. **Adaptação do Código Terraform:**
   - Modularizar o código para que possa ser reutilizado com diferentes provedores.
   - Configurar variáveis dinâmicas para permitir fácil alternância entre AWS e Azure.

3. **Teste de Implementação Multi-Cloud:**
   - Executar testes para garantir que a infraestrutura pode ser provisionada em ambos os provedores sem conflitos.
   - Validar a interoperabilidade e redundância entre os ambientes.

4. **Melhores Práticas em Ambientes Multi-Cloud:**
   - Discussão sobre a manutenção e monitoramento de uma infraestrutura multi-cloud.
   - Considerações de segurança e gestão de custos.

## Diagrama de Fluxo (Mermaid)

Aqui está um diagrama de fluxo que ilustra o processo de migração do projeto da AWS para a Azure e a adaptação para uma infraestrutura multi-cloud.

```mermaid
flowchart TD
    A[Início: Infraestrutura na AWS] --> B[Análise dos Recursos AWS]
    B --> C[Adaptação do Código Terraform para Azure]
    C --> D[Execução do Terraform na Azure]
    D --> E[Validação da Infraestrutura na Azure]
    E --> F{Multi-Cloud?}
    F --> |Sim| G[Análise das Diferenças entre AWS e Azure]
    G --> H[Adaptação do Código para Suporte Multi-Cloud]
    H --> I[Teste de Implementação Multi-Cloud]
    I --> J[Validação Final e Documentação]
    F --> |Não| J[Validação Final e Documentação]
    J --> K[Fim]
```

https://github.com/hashicorp/terraform-provider-azurerm/issues/9344

ssh -i ~/.ssh/id_rsa adminuser@104.41.45.245