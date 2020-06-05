import java.util.Arrays;

public class StreamCipher{
    private int blockLength;

    private BlockCipher blockCipher;
    private byte[] Key;

    public StreamCipher(byte[] key) {
        blockCipher = new BlockCipher(key);
        blockLength = blockCipher.BlockSize;
        Key = key;
    }
    public byte[] decrypt(byte[] inArr, int inOffset, int outOffset) {

        byte[] C = new byte[blockLength];
        byte[] Decrypted = new byte[inArr.length];

        for(int i = 0 ; i < (inArr.length / blockLength); i++){
            byte[] test = Arrays.copyOfRange(inArr, i * blockLength, i * blockLength + blockLength );
            blockCipher.decrypt(test, 0, C, 0);

            System.arraycopy(C,0, Decrypted, i * blockLength, blockLength);
        }
        int len__ = Decrypted.length;
        while (true)
        {
            if( len__ != 0 && Decrypted[len__ - 1] == 0)
            {
                len__ -= 1;
            }
            else {
                break;
            }
        }
        byte[] dec_unpadded = new byte[len__];
        System.arraycopy(Decrypted,0,dec_unpadded,0,len__);
        return dec_unpadded;

    }
    private byte[] xor(byte[] inArr1, byte[] inArr2){
        byte[] outArr = new byte[inArr1.length];
        for(int i =0; i < outArr.length; i++){
            outArr[i] = (byte) (((int)inArr1[i] ^ (int)inArr2[i]) & 0xff );
        }
        return outArr;
    }
    public byte[] encrypt(byte[] inArr, int inOffset, int outOffset) {

        byte[] inArrayPadded;
        if (inArr.length % blockLength != 0)
        {
            inArrayPadded = new byte[blockLength * (inArr.length / blockLength + 1)];
        }
        else
        {
            inArrayPadded = new byte[blockLength * (inArr.length / blockLength)];
        }
        for(int i = 0; i < inArr.length; i++){
            inArrayPadded[i] = inArr[i];
        }
        byte[] C = new byte[blockLength];
        byte[] Encrypted = new byte[inArrayPadded.length];
        for(int i = 0 ; i < (inArrayPadded.length / blockLength); i++){
            byte[] not_enc = Arrays.copyOfRange(inArrayPadded, i * blockLength, i * blockLength + blockLength);
            blockCipher.encrypt(not_enc, 0, C, 0);
            System.arraycopy(C,0, Encrypted, i * blockLength, blockLength);
        }
        return Encrypted;
    }



}
