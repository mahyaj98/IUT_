from scapy.all import *
import time

start = time.time()
filtered = 0
close = 0
open = 0
for i in range(2, 254):
    ip = "176.101.52." + str(i)
    print(IP)
    src_port = RandShort()
    scan = sr1(IP(dst=ip) / TCP(sport=8080, dport=80, flags="S"), timeout=10)

    if (scan is None):
        filtered += 1
    elif (scan.haslayer(TCP)):
        if (scan.getlayer(TCP).flags == 0x12):
            print(ip, "  is Open")
            open += 1
        elif (scan.getlayer(TCP).flags == 0x14):
            close += 1
    elif (scan.haslayer(ICMP)):
        if (int(scan.getlayer(ICMP).type) == 3 and int(scan.getlayer(ICMP).code) in [1, 2, 3, 9, 10, 13]):
            filtered += 1

print("%s seconds" % (time.time() - start))
print(open, "Open,", close, "Closed,", filtered, "Filtered\n")
