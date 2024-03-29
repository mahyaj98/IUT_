import pyaes
import socket
import threading
import json
from datetime import datetime
import rsa
import hashlib


HOST = '127.0.0.1'
PORT = 8888
SECMODE = True

if SECMODE:

    print("[+] Server Running ")
    print("[+] Waiting For Connection...")
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((HOST, PORT))
    s.listen(1)
    conn, addr = s.accept()
    print('[+] Connected by ', addr)
    g = 17959
    p = 6
    b = 673
    A = int(s.recv(100).decode())
    B = (g ** b) % p
    s.send(str(B).encode())

    AESkey = (A ** b) % p

    hashed = hashlib.sha256(AESkey).digest()
    aes = pyaes.AESModeOfOperationCBC(hashed)




else:
    print("[+] Server Running ")
    print("[+] Waiting For Connection...")

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((HOST, PORT))
    s.listen(1)
    conn, addr = s.accept()
    print('[+] Connected by ', addr)

def verify_and_display(recv_dict):
    timestamp = recv_dict['timestamp']
    message = recv_dict['message']
    SET_LEN = 80

    spaces = SET_LEN - len(str(message)) - len('Received : ') - 1
    if spaces > 0:
        space = ' ' * spaces
        sentence = 'Received : ' + str(message) + space + '  ' + timestamp
        print(sentence)


def process_bytes(bytess):
    ret = []
    while (len(bytess) >= 16):
        if (len(bytess) >= 16):
            byts = bytess[:16]
            ret.append(byts)
            bytess = bytess[16:]
        else:
            print("Block Size Mismatch ")
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


class myThread(threading.Thread):
    def __init__(self, id):
        threading.Thread.__init__(self)
        self.threadID = id

    def stop(self):
        self.is_alive = False

    def run(self):
        print("[+] Listening On Thread " + str(self.threadID))
        while 1:
            try:
                data = conn.recv(1024)
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
                        print('Unrecognised Data or Broken PIPE ')
            except ConnectionResetError:
                print('Broken PIPE !')
                exit(0)
                self.stop()


Listening_Thread = myThread(1)
Listening_Thread.daemon = True
Listening_Thread.start()

while 1:
    try:
        sending_data = str(input(""))
    except KeyboardInterrupt:
        conn.close()
        exit(-1)
    if (sending_data == "quit()"):
        Listening_Thread.stop()
        conn.close()
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
        conn.send(bytes(enc_bytes))
    else:
        nonenc_bytes = []
        sending_bytes = process_text(send_json_string)
        for byte in sending_bytes:
            nonenc_bytes += bytes(byte)
        conn.send(bytes(nonenc_bytes))
