from Crypto.PublicKey import RSA
import json

key = RSA.importKey(open('private.pem').read())
pubKey = key.publickey()
with open("public.pem", "w") as f:
    print("{}".format(pubKey.exportKey()).encode(), file=f)

json_file = open('db.json')
data = json.load(json_file)
encrypted = []

for item in data:
    tmp = {"Student#": None, "Name": None}
    tmp["Student#"] = item["Student#"]
    tmp["Name"] = pubKey.encrypt(item["Name"].encode(), pubKey)
    encrypted.append(tmp)
print(encrypted)

with open("EncDB.json", "wb") as f:
    json.dump(f, encrypted)


json_file = open('EncDB.json')
encrypted = json.load(json_file)
