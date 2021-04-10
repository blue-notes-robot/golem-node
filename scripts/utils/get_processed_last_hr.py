#!/usr/bin/python3
import json
import sys

try:
    obj = json.load(sys.stdin)
    last = obj.get("last1h", {}).get("Terminated")
    if last is not None:
        print(last)
    else:
        print(0)
except json.decoder.JSONDecodeError:
    print(0)


