# Use a standard python image to do all of the build/dependency install
FROM python:3.7.4-slim-buster as build
# Copy the requirements file
COPY requirements.txt /tmp/
# Install python dependencies
RUN pip3 install --quiet -r /tmp/requirements.txt && pip3 install --quiet gunicorn
# Create a system user with uid 1000, no login shell and set homedir to /app
RUN groupadd -r app && useradd -u 1000 -r -g app -m -d /app -s /sbin/nologin app && chmod 755 /app

# Create the actual image from a distroless base
FROM gcr.io/distroless/python3-debian10
# Copy in the python binaries/deps
COPY --from=build /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages
COPY --from=build /usr/local/bin/gunicorn /usr/local/bin/gunicorn
# Copy the passwd/shadow file - no useradd/groupadd in distroless images
COPY --from=build /etc/passwd /etc/shadow /etc/
# Copy the application into the container
COPY --from=build /app /app
# Set the workdir and switch user
WORKDIR /app
USER app
COPY main.py ./
# Expose port 5000
EXPOSE 5000
# Setup the Python environment
ENV PYTHONPATH=/usr/local/lib/python3.7/site-packages
ENV PYTHONUNBUFFERED=true
CMD [ "/usr/local/bin/gunicorn", "--bind", "0.0.0.0:5000", "--enable-stdio-inheritance", "--worker-tmp-dir", "/dev/shm", "--log-file=-", "--reload", "main:app" ]
