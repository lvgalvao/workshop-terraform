# Use a imagem base Python 3.12.5 com Alpine 3.20
FROM python:3.12.5-slim-bullseye

# Defina o diretório de trabalho no contêiner
WORKDIR /app

# Copie o arquivo de requisitos para o contêiner
COPY requirements.txt .

# Instale as dependências do Python
RUN pip install -r requirements.txt

# Copie o restante da aplicação para o contêiner
COPY . .

# Exponha a porta que a aplicação utilizará
EXPOSE 80

# Comando para rodar a aplicação
CMD ["streamlit", "run", "app.py"]
