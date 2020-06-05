from Crypto.PublicKey import RSA

key = RSA.importKey(open('rsa256.pub').read())
# print(key.n, key.e)
text = "this is a test."
enc_test = key.encrypt(text.encode(), key)
print(enc_test)


def egcd(a, b):
    x,y,u,v = 0,1,1,0
    while a != 0:
        q, r = b // a, b % a
        m, n = x - u * q, y - v * q
        b,a,x,y,u,v = a,r,u,v,m,n
    return b, x, y
def modinv(e, m):
    g, x, y = egcd(e, m)
    if g != 1:
        return None
    else:
        return x % m
def pqe2rsa(p, q, e):
    from Crypto.PublicKey import RSA
    n = p * q
    phi = (p - 1) * (q - 1)
    d = modinv(e, phi)
    key_params = (n, e, d, p, q)
    #print(d)
    priv_key = RSA.construct(key_params)

    return priv_key

priKey = pqe2rsa(242568351774463961471699551272090238027, 268112559484071113556889702629953763257, 65537)



print(priKey.decrypt(enc_test).decode())