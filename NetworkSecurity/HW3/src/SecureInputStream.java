import java.io.IOException;
import java.nio.channels.ScatteringByteChannel;
import java.util.Arrays;
import java.io.InputStream;
import java.io.FilterInputStream;

public class SecureInputStream extends InputStream
{
    private byte[] symmetricKey;
    StreamCipher streamCipher;
    InputStream iStream;
    private byte[] ibuffer = new byte[512];
    private boolean closed = false;


    protected SecureInputStream(InputStream in, byte[] Key) {
        symmetricKey = Key;
        streamCipher = new StreamCipher(symmetricKey);
        iStream = in;


    }


    public int read() throws IOException {

        int readin = iStream.read(ibuffer,0,9);
        if (readin == -1)
            return -1;
        byte[] outArray = streamCipher.decrypt(ibuffer, 0, 0);
        HashFunction hash = new HashFunction();
        int len = readin;
        hash.update(outArray,8,len);
        byte[] tmp1 = Arrays.copyOfRange(hash.digest(),0,8);
        byte[] tmp2 = Arrays.copyOfRange(outArray,8, len);
        if(!equals(Arrays.equals(
                tmp1,
                tmp2)))
        {
          throw new RuntimeException();
        }
        else {
           Arrays.copyOfRange(outArray,8,len);
        }

        return ((int) outArray[9]);
    };
    public int read(byte b[]) throws IOException {
        return read(b, 0, b.length);
    }
    public int read(byte b[], int off, int len) throws IOException {
        if (len <= 0) {
            return 0;
        }
        int readin = iStream.read(ibuffer);
        if (readin == -1) {
            return -1;
        }
        if (b != null) {
            byte[] outPut = new byte[readin];
            System.arraycopy(ibuffer, 0, outPut, off, readin);
            byte[] outArray = streamCipher.decrypt(outPut, 0, 0);
            HashFunction hash = new HashFunction();
            hash.update(outArray,8,readin - 8);
            byte[] tmp1 = Arrays.copyOfRange(hash.digest(),0,8);
            byte[] tmp2 = Arrays.copyOfRange(outArray,0, 8);
        if(!equals(Arrays.equals(
                tmp1,
                tmp2)))
        {
          throw new RuntimeException();
        }
        else {
           Arrays.copyOfRange(outArray,8,readin);
        }
            b = outArray;
        }

        return len;
    }


    public void close() throws IOException {
        if (closed) {
            return;
        }
        closed = true;
        iStream.close();
    }
}
