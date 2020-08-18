import java.io.ByteArrayOutputStream;
import java.io.IOException;


public class ChatClient {
  public ChatClient(String username, String password, String mode,
		    String serverHost, int serverPort,
		    byte[] clientPrivateKey, byte[] clientPublicKey)
                                                         throws IOException {

    SecureSocket sock = new SecureSocket(serverHost, serverPort,
            clientPrivateKey, clientPublicKey, username);

    SecureOutputStream out = sock.getOutputStream();

    sendAuth(username, password, mode, out);

    new ReceiverThread(sock.getInputStream());

    for(;;){
      int c = System.in.read();
      if(c == -1)    break;
      out.write(c);
      if(c == '\n')    out.flush();
    }

    out.close();
  }

  public static void main(String[] argv){
    String mode = "In"; //argv[0];
    String username = "Mahya";//argv[1];
    String password = "mA*129901123";//argv[2];
    String hostname = (argv.length<=2) ? "localhost" : argv[3];
    RSA rsa = new RSA(2048);
    byte[] clientPrivateKey = rsa.getPrivateKey();
    byte[] clientPublicKey = rsa.getPublicKey();

      try{
      new ChatClient(username, password, mode, hostname, ChatServer.portNum, clientPrivateKey, clientPublicKey);
    }catch(IOException x){
      x.printStackTrace();
    }
  }

  private void sendAuth(String username, String password, String mode, SecureOutputStream out) throws IOException {

    String sendInfo = username + ":" + password + ":" +mode;
    byte[] info_byte = sendInfo.getBytes();
    out.write(info_byte.length);
    out.flush();
    out.write(sendInfo.getBytes());
    out.flush();

  }

  class ReceiverThread extends Thread {

    private SecureInputStream in;

    ReceiverThread(SecureInputStream inStream) {
      in = inStream;
      start();
    }

    public void run() {
      try{
      	ByteArrayOutputStream baos;
      	baos = new ByteArrayOutputStream();
      	for(;;){
      	  int c = in.read();
      	  if(c == -1){
      	    spew(baos);
      	    break;
      	  }
          baos.write(c);
      	  if(c == '\n')    spew(baos);
      	}
      }
      catch(IOException x){
          x.printStackTrace();

      }
    }

    private void spew(ByteArrayOutputStream baos) throws IOException {
      byte[] message = baos.toByteArray();
      baos.reset();
      System.out.write(message);
    }
  }
}
