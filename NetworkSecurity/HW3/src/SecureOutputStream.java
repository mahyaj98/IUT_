import java.io.*;
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
        ibuffer[0] = (byte) c;
        HashFunction hash = new HashFunction();
        hash.update(ibuffer,0,1);
        byte[] outPut = new byte[9];
        byte[] hashed = Arrays.copyOfRange(hash.digest(),0,8);
        System.arraycopy(hashed, 0, outPut, 0, 8);
        System.arraycopy(ibuffer, 0, outPut, 8, 1);
        byte[] encrypted = streamCipher.encrypt(outPut,0,0);


        oStream.write(encrypted);
    }
    public void write(byte b[]) throws IOException {
        write(b, 0, b.length);
    }
    public void write(byte b[], int off, int len) throws IOException {
        HashFunction hash = new HashFunction();
        hash.update(b,0, len);
        byte[] outPut = new byte[len + 8];
        byte[] hashed = Arrays.copyOfRange(hash.digest(),0,8);
        System.arraycopy(hashed, 0, outPut, 0, 8);
        System.arraycopy(b, 0, outPut, 8, len);
        byte[] encrypted = streamCipher.encrypt(outPut,0,0);

        oStream.write(encrypted);
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
