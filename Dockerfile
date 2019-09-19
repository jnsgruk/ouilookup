FROM python:3

WORKDIR /usr/src/app

COPY main.py /usr/src/app/main.py
RUN pip install --no-cache-dir flask gunicorn ipwhois

CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "--enable-stdio-inheritance", "--reload", "main:app" ]