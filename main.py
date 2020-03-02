#!/usr/bin/env python3

import atexit
from urllib.request import urlopen

from apscheduler.schedulers.background import BackgroundScheduler
from flask import Flask

app = Flask(__name__)
oui = {}


def update():
    """Downloads the latest version of the OUI list and places in memory."""
    print("Downloading sanitized OUI from https://linuxnet.ca/ieee/oui.txt...")
    url = "https://linuxnet.ca/ieee/oui.txt"
    if url.lower().startswith("http"):
        file = urlopen(url)
    else:
        raise ValueError from None

    counter = 0
    for line in file:
        line = line.decode()
        if "base 16" in line:
            parts = line.split("\t")
            prefix = parts[0].split()[0]
            vendor = parts[-1].strip()
            oui[prefix] = vendor
            counter += 1

    print("Added/Updated " + str(counter) + " OUI vendors")


@app.route('/<mac>')
def getVendor(mac):
    """Looks up the vendor of a specified MAC address."""
    try:
        vendor = oui[mac.upper().replace(":", "").replace("-", "")[0:6]]
    except KeyError:
        vendor = "Unknown"
    return vendor


update()
scheduler = BackgroundScheduler()
scheduler.add_job(func=update, trigger="interval", hours=24)
scheduler.start()
atexit.register(scheduler.shutdown)

if __name__ == "__main__":
    app.run(host="0.0.0.0")
