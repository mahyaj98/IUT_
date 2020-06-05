import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.IOException;


public class ChatClient {
  public ChatClient(String username, String password, String mode,
		    String serverHost, int serverPort,
		    byte[] clientPrivateKey, byte[] serverPublicKey)
                                                         throws IOException {

    SecureSocket sock = new SecureSocket(serverHost, serverPort,
            clientPrivateKey, serverPublicKey);

    OutputStream out = sock.getOutputStream();
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
    String username = "Mahya1"; //argv[1];
    String password = "9*"; //argv[2];
    String hostname = (argv.length<=2) ? "localhost" : "3636";//argv[3];
    try{
      new ChatClient(username, password, mode,hostname, ChatServer.portNum, null, null);
    }catch(IOException x){
      x.printStackTrace();
    }
  }

  private void sendAuth(String username, String password, String mode ,OutputStream out) throws IOException {
    // create an AuthInfo object to authenticate the local user,
    // and send the AuthInfo to the server

    AuthenticationInfo auth = new AuthenticationInfo(username, password, mode);
    ObjectOutputStream oos = new ObjectOutputStream(out);
    oos.writeObject(auth);
    oos.flush();
  }

  class ReceiverThread extends Thread {
    // gather incoming messages, and display them

    private InputStream in;

    ReceiverThread(InputStream inStream) {
      in = inStream;
      start();
    }

    public void run() {
      try{
      	ByteArrayOutputStream baos;  // queues up stuff until carriage-return
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
      catch(IOException x){ }
    }

    private void spew(ByteArrayOutputStream baos) throws IOException {
      byte[] message = baos.toByteArray();
      baos.reset();
      System.out.write(message);
    }
  }
}
