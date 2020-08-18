import java.io.*;
import java.lang.reflect.Array;
import java.nio.ByteBuffer;
import java.util.Arrays;

public class SecureOutputStream extends OutputStream
{

    private byte[] symmetricKey;
    StreamCipher streamCipher;
    OutputStream oStream;
    private byte[] ibuffer = new byte[1];
    private byte[] obuffer;
    private boolean closed = false;


    public SecureOutputStream(OutputStream out, byte[] key) {


        symmetricKey = key;
        streamCipher = new StreamCipher(symmetricKey);
        oStream = out;


    }

    public void write(int c) throws IOException {
        byte[] input = ByteBuffer.allocate(4).putInt(c).array();

        write(input,0,4);

    }
    public void write(byte b[]) throws IOException {
        write(b, 0, b.length);
    }
    public void write(byte b[], int off, int len) throws IOException {

        for (int i = 0; i < len; i++) {
            HashFunction hash = new HashFunction();
            hash.update(b[i]);

            byte[] outPut = new byte[8];
            byte[] hashed = Arrays.copyOfRange(hash.digest(), 0, 7);
            System.arraycopy(hashed, 0, outPut, 0, 7);
            System.arraycopy(b, i, outPut, 7, 1);
            byte[] encrypted = streamCipher.encrypt(outPut, 0, 0);
            oStream.write(encrypted);


        }
    }
    public void flush() throws IOException {
        if (obuffer != null) {
            oStream.write(obuffer);
            obuffer = null;
        }
        oStream.flush();
    }
    public void close() throws IOException {
        if (closed) {
            return;
        }
        closed = true;
        try {
            flush();
        } catch (IOException ignored) {}
        oStream.close();
    }
}
