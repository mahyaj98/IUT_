
import java.math.BigInteger;
import java.security.SecureRandom;

public class RSA {
    private BigInteger n, d, e;
    private int bitlen = 1024;
    static int eValue = 65537;


    public RSA(){;}
    public RSA(int bits) {
        bitlen = bits;
        SecureRandom random = new SecureRandom();
        BigInteger p = new BigInteger(bitlen, 100, random);
        BigInteger q = new BigInteger(bitlen, 100, random);
        n = p.multiply(q);
        BigInteger m = (p.subtract(BigInteger.ONE)).multiply(q
                .subtract(BigInteger.ONE));
        e = new BigInteger(Integer.toString(eValue));
        while (m.gcd(e).intValue() > 1) {
            e = e.add(new BigInteger("2"));
        }
        d = e.modInverse(m);
    }

    public byte[] encryptMessage(byte[] message, byte[] pubKey) {
        String pub_key = new String(pubKey);
        String[] extr_key = pub_key.split(":");
        BigInteger puKey = new BigInteger(extr_key[0]);
        BigInteger mod = new BigInteger(extr_key[1]);

        return (new BigInteger(message)).modPow(puKey, mod).toByteArray();
    }
    public byte[] decryptMessage(byte[] message,  byte[] priKey) {
        String pri_key = new String(priKey);
        String[] extr_key = pri_key.split(":");
        BigInteger prKey = new BigInteger(extr_key[0]);
        BigInteger mod = new BigInteger(extr_key[1]);

        return  (new BigInteger(message)).modPow(prKey, mod).toByteArray();
    }

    public byte[] getPublicKey(){
        String key = e.toString() + ":" + n.toString();
        return key.getBytes();
    }
    public byte[] getPrivateKey(){
        String key = d.toString() + ":" + n.toString();
        return key.getBytes();
    }

    public byte[] signMessage(byte[] message, byte[] priKey){return encryptMessage(message,priKey);}
    public byte[] verifyMessage(byte[] message, byte[] pubKey){return decryptMessage(message,pubKey);}
}
