FROM python:3.9

RUN pip install streamlit

COPY ./app.py /app/app.py

WORKDIR /app

ENTRYPOINT ["streamlit", "run"]
CMD ["app.py"]
