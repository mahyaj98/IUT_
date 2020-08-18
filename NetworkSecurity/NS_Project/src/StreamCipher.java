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

        return Decrypted;

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
