from Crypto.PublicKey import RSA
import json

key = RSA.importKey(open('public.pem').read())

json_file = open('EncDB.json')
Enc = json.load(json_file)

while 1:
    name = input()
    found = False
    for item in Enc:
        if item['Name'] == name:
            print("This student has a student # of ", item["Student#"])
            found = True
    if found == False:
        print("This student does not exist.")
