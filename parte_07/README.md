# Parte 7: Migração de Projeto da AWS para a Azure

## Objetivo

Nesta seção, vamos demonstrar a migração de uma infraestrutura existente na AWS para a Azure usando Terraform. O objetivo é mostrar como adaptar e reutilizar o código Terraform para suportar diferentes provedores de nuvem, garantindo que a migração seja executada de forma eficiente e segura.

### Passos da Migração

1. **Análise da Infraestrutura Atual na AWS:**
   - Identificar os recursos e serviços atualmente utilizados na AWS.
   - Documentar as configurações específicas e dependências.

2. **Adaptação do Código Terraform:**
   - Modificar o código Terraform para suportar a Azure, utilizando provedores e recursos adequados.
   - Ajustar variáveis e configurações para refletir as melhores práticas na Azure.

3. **Execução da Migração:**
   - Criar um plano de migração utilizando o comando `terraform plan`.
   - Executar a migração utilizando `terraform apply`.
   - Verificar se todos os recursos foram corretamente provisionados na Azure.

4. **Validação da Infraestrutura Migrada:**
   - Testar a infraestrutura migrada para garantir que os serviços estão operando corretamente.
   - Documentar qualquer ajuste necessário pós-migração.