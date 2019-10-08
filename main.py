#!/usr/bin/env python3

from urllib.request import urlopen

from flask import Flask

app = Flask(__name__)
oui = {}

print("Downloading sanitized OUI from https://linuxnet.ca/ieee/oui.txt...")
file = urlopen("https://linuxnet.ca/ieee/oui.txt")

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


@app.route('/oui/<mac>')
def getVendor(mac):
    try:
        vendor = oui[mac.upper().replace(":", "").replace("-", "")[0:6]]
    except:
        vendor = "Unknown"
    return vendor


if __name__ == "__main__":
    app.run(host="0.0.0.0")
