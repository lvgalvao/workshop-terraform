#!/bin/bash
# Atualizar os pacotes do sistema
sudo apt update -y

# Instalar o Git e o Docker
sudo apt install git docker.io -y

# Iniciar e habilitar o Docker
sudo usermod -aG docker adminuser

# Adicionar o usuário ao grupo Docker
sudo reboot

# (Opcional) Após reiniciar a sessão, verifique o status do Docker e inicie/habilite o serviço se necessário
sudo systemctl start docker
sudo systemctl enable docker

# Clonar o repositório
sudo git clone --branch azure https://github.com/lvgalvao/migration /home/ubuntu/migration

# Mudar para o diretório do repositório
cd /home/ubuntu/migration

# Construir a imagem Docker
sudo docker build -t fastapi-app .

# Configurar variáveis de ambiente para o banco de dados
export DATABASE_URL="mssql+pyodbc://${db_username}:${db_password}@${db_address}:1433/example-db?driver=ODBC+Driver+17+for+SQL+Server"

# Executar o contêiner Docker com a variável de ambiente configurada
sudo docker run -p 80:80 \
  -e DATABASE_URL="mssql+pyodbc://${db_username}:${db_password}@${db_address}:1433/example-db?driver=ODBC+Driver+17+for+SQL+Server" fastapi-app
