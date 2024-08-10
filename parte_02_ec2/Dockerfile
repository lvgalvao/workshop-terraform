FROM python:3.9-slim

RUN pip install --no-cache-dir streamlit

COPY ./app.py /app/app.py

WORKDIR /app

ENTRYPOINT ["streamlit", "run"]
CMD ["app.py"]
