import pyaes
import socket
import threading
import hashlib
import json
import os
from datetime import datetime
import rsa

print("[+] Client Running ")
HOST = "127.0.0.1"
PORT = 8888
SECMODE = True

try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST, PORT))
except ConnectionError:
    print('Could Not Connect !')
    exit(-1)

if SECMODE:
    pubkey = s.recv(2000)
    n = int(pubkey.decode())
    pubKey = rsa.PublicKey(n, 65537)
    print("Recieved Public Key ", pubkey)
    key = os.urandom(32)
    print("Session key generated ",key)
    encrypted_aes_key = rsa.encrypt(key, pubKey)
    print("Encrypted session key ", encrypted_aes_key)
    s.send(encrypted_aes_key)
    hashed = hashlib.sha256(key).digest()
    aes = pyaes.AESModeOfOperationCBC(hashed)


def process_bytes(bytess):
    ret = []
    while (len(bytess) >= 16):
        byts = bytess[:16]
        ret.append(byts)
        bytess = bytess[16:]
    return ret

def process_text(data):
    streams = []
    while (len(data)>0):
        if(len(data)>=16):
            stream = data[:16]
            data = data[16:]
        else:
            stream = data + ("~"*(16-len(data)))
            data = ''
        stream_bytes = [ ord(c) for c in stream]
        streams.append(stream_bytes)
    return streams

def process_text_to_text(data):
    streams = []
    while (len(data) > 0):
        if (len(data) >= 16):
            stream = data[:16]
            data = data[16:]
        else:
            stream = data + ("~" * (16 - len(data)))
            data = ''
        streams.append(stream)
    return streams


def verify_and_display(recv_dict):
    timestamp = recv_dict['timestamp']
    message = recv_dict['message']
    SET_LEN = 80
    spaces = SET_LEN - len(str(message)) - len('Received : ') - 1
    if spaces > 0:
        space = ' ' * spaces
        sentence = 'Received : ' + str(message) + space + '  ' + timestamp
        print(sentence)


class myThread(threading.Thread):
    def __init__(self, id):
        threading.Thread.__init__(self)
        self.threadID = id

    def stop(self):
        self.is_alive = False

    def run(self):
        while 1:
            try:
                data = s.recv(1024)
                if (data != ""):
                    mess = ''
                    processed_data = process_bytes(data)
                    for dat in processed_data:
                        if SECMODE:
                            decrypted = aes.decrypt(dat)
                            for ch in decrypted:
                                if (chr(ch) != '~'):
                                    mess += str(chr(ch))
                        else:
                            for ch in dat:
                                if (chr(ch) != '~'):
                                    mess += str(chr(ch))
                    try:
                        data_recv = json.loads(mess)
                        verify_and_display(data_recv)
                    except:
                        #print('Unrecognised Data or Broken PIPE ')
                        pass
            except ConnectionResetError:
                #print('Broken PIPE!')
                pass


Listening_Thread = myThread(1)
Listening_Thread.daemon = True
Listening_Thread.start()

while 1:
    try:
        sending_data = str(input(""))
    except KeyboardInterrupt:
        s.close()
        exit(-1)
    if (sending_data == "quit()"):
        Listening_Thread.stop()
        s.close()
        exit()
    timestamp = str(datetime.now())[11:19]
    send_data = {
        "timestamp": timestamp,
        "message": sending_data,
    }
    send_json_string = json.dumps(send_data)

    if SECMODE:
        sending_bytes = process_text_to_text(send_json_string)
        enc_bytes = []
        for byte in sending_bytes:
            ciphertext = aes.encrypt(byte)
            enc_bytes += bytes(ciphertext)
        s.send(bytes(enc_bytes))
    else:
        sending_bytes = process_text(send_json_string)
        nonenc_bytes = []
        for byte in sending_bytes:
            nonenc_bytes += byte
        s.send(bytes(nonenc_bytes))