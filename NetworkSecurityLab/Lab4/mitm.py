import socket
import threading
import hashlib
import pyaes
import json


HOST_me = '127.0.0.2'
PORT = 8888
print("[+] MITM Running ")
print("[+] Waiting For Connection...")
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST_me, PORT))
s.listen(1)
conn, addr = s.accept()
print('[+] Connected by ', addr)
HOST = '127.0.0.1'
s1 = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s1.connect((HOST, PORT))

g = 17959
p = 6

A = int(s.recv(100).decode())

z = 783
Z = (g ** z) % p
s1.send(str(Z).encode())
B = int(s1.recv(100).decode())

s.send(str(Z).encode())

AZ = (A ** z) % p
BZ = (B ** z ) % p

hashedAZ = hashlib.sha256(AZ).digest()
aesAZ = pyaes.AESModeOfOperationCBC(hashedAZ)

hashedBZ = hashlib.sha256(BZ).digest()
aesBZ = pyaes.AESModeOfOperationCBC(hashedBZ)

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

class AZB(threading.Thread):
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
                        decrypted = aesAZ.decrypt(dat)
                        for ch in decrypted:
                            if (chr(ch) != '~'):
                                mess += str(chr(ch))
                    try:
                        data_recv = json.loads(mess)
                        print("Data from client to server")
                        verify_and_display(data_recv)
                        sending_bytes = process_text_to_text(data_recv)
                        enc_bytes = []
                        for byte in sending_bytes:
                            ciphertext = aesBZ.encrypt(byte)
                            enc_bytes += bytes(ciphertext)
                        s1.send(bytes(enc_bytes))
                    except:
                        print('Unrecognised Data or Broken PIPE ')
            except ConnectionResetError:
                print('Broken PIPE !')
                exit(0)
                self.stop()

class BZA(threading.Thread):
    def __init__(self, id):
        threading.Thread.__init__(self)
        self.threadID = id

    def stop(self):
        self.is_alive = False

    def run(self):
        print("[+] Listening On Thread " + str(self.threadID))
        while 1:
            try:
                data = s1.recv(1024)
                if (data != ""):
                    mess = ''
                    processed_data = process_bytes(data)
                    for dat in processed_data:
                        decrypted = aesBZ.decrypt(dat)
                        for ch in decrypted:
                            if (chr(ch) != '~'):
                                mess += str(chr(ch))
                    try:
                        data_recv = json.loads(mess)
                        print("Data from client to server")
                        verify_and_display(data_recv)
                        sending_bytes = process_text_to_text(data_recv)
                        enc_bytes = []
                        for byte in sending_bytes:
                            ciphertext = aesAZ.encrypt(byte)
                            enc_bytes += bytes(ciphertext)
                        conn.send(bytes(enc_bytes))
                    except:
                        print('Unrecognised Data or Broken PIPE ')
            except ConnectionResetError:
                print('Broken PIPE !')
                exit(0)
                self.stop()

AZBTH = AZB(1)
AZBTH.daemon = True
AZBTH.start()

BZATH = BZA(2)
BZATH.daemon = True
BZATH.start()


