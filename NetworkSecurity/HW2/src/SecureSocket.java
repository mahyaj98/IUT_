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


public class SecureSocket {
  private Socket       sock;
  private InputStream  in;
  private OutputStream out;

  public SecureSocket(String hostname, int port,
                      byte[] clientPrivateKey, byte[] serverPublicKey)
                         throws IOException, UnknownHostException {
    // this constructor is called by a client who wants to make a secure
    // socket connection to a server

    sock = new Socket(hostname, port);

    byte[] symmetricKey = keyExchange(clientPrivateKey, serverPublicKey, false);

    setupStreams(sock, symmetricKey, false);
  }

  public SecureSocket(Socket s, byte[] myPrivateKey) throws IOException {
    // don't call this yourself
    // this is meant to be called by SecureServerSocket

    sock = s;

    byte[] symmetricKey = keyExchange(myPrivateKey, null, true);

    setupStreams(sock, symmetricKey, true);
  }

  private byte[] keyExchange(byte[] myPrivateKey, 
			     byte[] hisPublicKey,  // null if I am server
			     boolean iAmClient ) throws IOException {
    // Assignment 4: replace this with a secure key-exchange algorithm

    // This is hopelessly insecure; it's just here as a placeholder.
    InputStream instream = sock.getInputStream();
    OutputStream outstream = sock.getOutputStream();
    byte[] outbytes = Util.getRandomByteArray(4);
    outstream.write(outbytes, 0, outbytes.length);
    outstream.flush();
    byte[] inbytes = new byte[4];
    int num = instream.read(inbytes, 0, inbytes.length);
    if(num != inbytes.length)    throw new RuntimeException();
    HashFunction hash = new HashFunction();
    if(iAmClient){
      hash.update(outbytes);
      hash.update(inbytes);
    }else{
      hash.update(inbytes);
      hash.update(outbytes);
    }
    return hash.digest();
  }

  private void setupStreams(Socket ssock, 
			    byte[] symmetricKey, boolean iAmClient ) 
                                   throws IOException {
    // Assignment 2: replace this with something that creates streams that
    //               use crypto in a way that makes them secure

    // This is hopelessly insecure; streams are totally unprotected from
    // eavesdropping or tampering.
    in = sock.getInputStream();
    out = sock.getOutputStream();
  }

  public InputStream getInputStream() throws IOException {
    return in;
  }

  public OutputStream getOutputStream() throws IOException {
    return out;
  }

  public void close() throws IOException {
    in.close();
    out.close();
    sock.close();
  }
}
