FROM python:3.7.4-slim-buster

COPY requirements.txt /tmp/
RUN pip3 install --quiet -r /tmp/requirements.txt && pip3 install --quiet gunicorn

RUN useradd --create-home oui
WORKDIR /home/oui
USER oui
COPY main.py ./

CMD [ "gunicorn", "--bind", "0.0.0.0:5000", "--enable-stdio-inheritance", "--worker-tmp-dir", "/dev/shm", "--log-file=-", "--reload", "main:app" ]
