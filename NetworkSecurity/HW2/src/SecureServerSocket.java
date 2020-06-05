import java.net.Socket;
import java.net.ServerSocket;
import java.io.IOException;


public class SecureServerSocket {
  private ServerSocket ss;
  private byte[]       privateKey;

  public SecureServerSocket(int portNum, byte[] myPrivateKey)
                                                      throws IOException {
    ss = new ServerSocket(portNum);
    privateKey = myPrivateKey;
  }

  public SecureSocket accept() throws IOException {
    Socket sock = ss.accept();
    return new SecureSocket(sock, privateKey);
  }
}
