import java.io.IOException;
import java.lang.reflect.Array;
import java.nio.ByteBuffer;
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
    private int start = 0;


    protected SecureInputStream(InputStream in, byte[] Key) {
        symmetricKey = Key;
        streamCipher = new StreamCipher(symmetricKey);
        iStream = in;


    }


    public int read() throws IOException {
        byte[] b = new byte[1024];
        int iS = read(b,0,1);
        int return_val = new Byte(b[0]).intValue();
        return  return_val;

    };
    public int read(byte b[]) throws IOException {
        return read(b, 0, b.length);
    }
    public int read(byte b[], int off, int len) throws IOException {
        if (len <= 0) {
            return 0;
        }


        for (int i = 0; i < len; i++) {
            byte[] t = new byte[8];
            int is = iStream.read(t,0,8);

            byte[] outArray = streamCipher.decrypt(t, 0, 0);
            HashFunction hash = new HashFunction();
            hash.update(outArray,7,1);
            byte[] tmp1 = Arrays.copyOfRange(hash.digest(),0,7);
            byte[] tmp2 = Arrays.copyOfRange(outArray,0, 7);
            if(!Arrays.equals(tmp1,tmp2))
            {
                throw new RuntimeException();
            }
            else {
                System.arraycopy(outArray,7,b,i,1);
            }
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
