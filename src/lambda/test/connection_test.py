import json
import hashlib
import os
import urllib.request
from return_hash import lambda_handler

lambda_url = os.getenv('LAMBDA_URL')

payload = {
  "text": "Hello Lambda!"
}

data = json.dumps(payload).encode("utf-8")

req = urllib.request.Request(
  LAMBDA_URL,
  data=data,
  headers={"Content-Type": "application/json"},
  method="POST"
)

try:
  with urllib.request.urlopen(req) as res:
    body = res.read().decode("utf-8")
    print("Status code:", res.status)
    print("Response body:", body)

    try:
      result = json.loads(body)
      print("Hashed value:", result.get("hash"))
    except json.JSONDecodeError:
      print("Response is not valid JSON")

except urllib.error.HTTPError as e:
  print("HTTP Error:", e.code, e.reason)
  print(e.read().decode("utf-8"))
except urllib.error.URLError as e:
  print("URL Error:", e.reason)
