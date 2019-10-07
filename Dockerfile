FROM alpine:latest

WORKDIR /usr/src/app

COPY main.py /usr/src/app/main.py
RUN apk add --update --no-cache python3 py3-pip && pip3 install --no-cache-dir flask gunicorn ipwhois	

CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "--enable-stdio-inheritance", "--reload", "main:app" ]
