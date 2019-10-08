## OUI Lookup Docker Image

A simple server tool that performs OUI lookups against MAC addresses.

```bash
$ git clone https://github.com/jnsgruk/ouilookup
$ cd ouilookup
$ docker build -t jnsgruk/ouilookup:latest .
$ docker run --name oui -d -p 5000:5000 jnsgruk/ouilookup:latest 

# Wait a few seconds for the OUI list to download...

$ curl http://localhost:5000/00:00:00:00:00:00
```
