import java.net.Socket;
import java.net.ServerSocket;
import java.io.IOException;


public class SecureServerSocket {
  private ServerSocket ss;
  private byte[]       privateKey;
  private byte[]       publicKey;

  public SecureServerSocket(int portNum, byte[] myPrivateKey, byte[] myPublicKey)
                                                      throws IOException {
    ss = new ServerSocket(portNum);
    privateKey = myPrivateKey;
    publicKey = myPublicKey;
  }

  public SecureSocket accept() throws IOException {
    Socket sock = ss.accept();
    return new SecureSocket(sock, privateKey, publicKey);
  }
}
