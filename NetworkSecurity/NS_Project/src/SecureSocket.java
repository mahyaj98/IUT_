// This file implements a secure (encrypted) version of the Socket class.
// (Actually, it is insecure as written, and students will fix the insecurities
// as part of their homework.)
//
// This class is meant to work in tandem with the SecureServerSocket class.
// The idea is that if you have a program that uses java.net.Socket and
// java.net.ServerSocket, you can make that program secure by replacing 
// java.net.Socket by this class, and java.net.ServerSocket by 
// SecureServerSocket.
//
// Like the ordinary Socket interface, this one differentiates between the
// client and server sides of a connection.  A server waits for connections
// on a SecureServerSocket, and a client uses this class to connect to a 
// server.
// 
// A client makes a connection like this:
//        String          serverHostname = ...
//        int             serverPort = ...
//        byte[]          myPrivateKey = ...
//        byte[]          serverPublicKey = ...
//        SecureSocket sock;
//        sock = new SecureSocket(serverHostname, serverPort,
//                                   myPrivateKey, serverPublicKey);
// 
// The keys are in a key-exchange protocol (which students will write), to
// establish a shared secret key that both the client and server know.
//
// Having created a SecureSocket, a program can get an associated
// InputStream (for receiving data that arrives on the socket) and an
// associated OutputStream (for sending data on the socket):
//
//         InputStream inStream = sock.getInputStream();
//         OutputStream outStream = sock.getOutputStream();


import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.io.IOException;
import java.net.UnknownHostException;
import java.util.Arrays;
import java.util.Base64;


public class SecureSocket {
    private Socket       sock;
    private byte[] symmetricKey;
    private boolean iAmClient;
    private SecureInputStream  in;
    private SecureOutputStream out;


  public SecureSocket(String hostname, int port,
                      byte[] clientPrivateKey, byte[] clientPublicKey, String username)
                         throws IOException, UnknownHostException {

    sock = new Socket(hostname, port);
    iAmClient = true;
    symmetricKey = keyExchange(clientPrivateKey, clientPublicKey);
    setupStreams();
  }

  public SecureSocket(Socket s, byte[] myPrivateKey, byte[] myPublicKey) throws IOException {


    sock = s;
    iAmClient = false;
    symmetricKey = keyExchange(myPrivateKey, myPublicKey);
    setupStreams();


  }

  private byte[] keyExchange(byte[] myPrivateKey, byte[] myPublicKey) throws IOException {

    InputStream instream = sock.getInputStream();
    OutputStream outstream = sock.getOutputStream();
    RSA rsa = new RSA();


    if(iAmClient)
    {
        outstream.write(myPublicKey,0,myPublicKey.length);
        outstream.flush();

        //---
        byte[] b = new byte[3000];
        int read = instream.read(b);
        byte[] otherPubKey = Arrays.copyOfRange(b,0,read);
        //---
        byte[] k1 = Util.getRandomByteArray(4);
        byte[] NC =  Util.getRandomByteArray(4);
        byte[] toenc = new byte[8];
        System.arraycopy(k1,0,toenc,0,4);
        System.arraycopy(NC,0,toenc,4,4);
        byte[] toenc_b64 = Base64.getEncoder().encode(toenc);
        byte[] enc1 = rsa.encryptMessage(toenc_b64,otherPubKey);

        outstream.write(enc1,0,enc1.length);
        outstream.flush();
        //---
        byte[] b2 = new byte[3000];
        int read2 = instream.read(b2);
        byte[] servEnc = Arrays.copyOfRange(b2,0,read2);
        byte[] dec_serv_b64 = rsa.decryptMessage(servEnc, myPrivateKey);
        byte[] dec_serv = Base64.getDecoder().decode(dec_serv_b64);
        byte[] k2 = Arrays.copyOfRange(dec_serv, 0, 4);
        byte[] NS = Arrays.copyOfRange(dec_serv, 4, 8);
        byte[] NC_rec = Arrays.copyOfRange(dec_serv, 8, 12);

        if(!Arrays.equals(NC,NC_rec)){
          throw new RuntimeException();
        }

        //---
        byte[] key = new byte[k1.length + k2.length];
        System.arraycopy(k1, 0, key, 0, k1.length);
        System.arraycopy(k2, 0, key, k1.length, k2.length);
        StreamCipher st = new StreamCipher(key);
        byte [] NS_enc = st.encrypt(NS,0,0);
        outstream.write(NS_enc,0,NS_enc.length);
        outstream.flush();
        //---

        return key;
    }
    else {
        byte[] b = new byte[3000];
        int read = instream.read(b);
        byte[] otherPubKey = Arrays.copyOfRange(b,0,read);
        //---
        outstream.write(myPublicKey,0,myPublicKey.length);
        outstream.flush();
        //---
        byte[] b2 = new byte[3000];
        int read2 = instream.read(b2);

        byte[] enc_recv = Arrays.copyOfRange(b2,0,read2);
        byte[] dec_recv_b64 = rsa.decryptMessage(enc_recv,myPrivateKey);
        byte[] dec_recv = Base64.getDecoder().decode(dec_recv_b64);
        byte[] k1 = Arrays.copyOfRange(dec_recv,0,4);
        byte[] NC = Arrays.copyOfRange(dec_recv,4,8);
        //---
        byte[] k2 = Util.getRandomByteArray(4);
        byte[] NS =  Util.getRandomByteArray(4);

        byte[] toencenc = new byte[12];
        System.arraycopy(k2,0,toencenc,0,4);
        System.arraycopy(NS,0,toencenc,4,4);
        System.arraycopy(NC,0, toencenc,8, 4);
        byte[] toencenc_b64 = Base64.getEncoder().encode(toencenc);
        byte[] enc1 = rsa.encryptMessage(toencenc_b64, otherPubKey);
        outstream.write(enc1,0,enc1.length);
        outstream.flush();
        //---
        byte[] b3 = new byte[3000];
        int read3 = instream.read(b3);
        byte[] resp = Arrays.copyOfRange(b3,0,read3);
        byte[] key = new byte[k1.length + k2.length];
        System.arraycopy(k1, 0, key, 0, k1.length);
        System.arraycopy(k2, 0, key, k1.length, k2.length);
        StreamCipher st = new StreamCipher(key);
        byte[] NS_rec = st.decrypt(resp,0,0);
        byte[] NS_rec_ = Arrays.copyOfRange(NS_rec,0,4);
        if(!Arrays.equals(NS,NS_rec_)){
          throw new RuntimeException();
        }
        //---

        return key;
    }
  }

  private void setupStreams() throws IOException {

    in = new SecureInputStream(sock.getInputStream(), symmetricKey);
    out = new SecureOutputStream(sock.getOutputStream(), symmetricKey);

  }

  public SecureInputStream getInputStream() throws IOException {
    return in;
  }

  public SecureOutputStream getOutputStream() throws IOException {

    return out;
  }

  public void close() throws IOException {
    in.close();
    out.close();
    sock.close();
  }
}
