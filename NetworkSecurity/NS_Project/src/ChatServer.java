import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.OutputStream;
import java.lang.reflect.Array;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import java.io.IOException;


public class ChatServer {
  public static final int portNum = Config.getAsInt("ServerPortNum");

  private Set activeSenders = Collections.synchronizedSet(new HashSet());

  public ChatServer(byte[] myPrivateKey, byte[] myPublicKey) {
    try{
      SecureServerSocket ss;
      System.out.println("I am listening on "+Integer.toString(portNum));

      ss = new SecureServerSocket(portNum, myPrivateKey, myPublicKey);
      for(;;){
      	SecureSocket sock = ss.accept();
      	SecureInputStream  in  = sock.getInputStream();
      	SecureOutputStream out = sock.getOutputStream();

      	String username = getAuth(in);

          if(username.equals("SIE"))
        {
              System.out.println("Authentication failed");
              send_error_message(out, "Authentication failed. Please try again later.\n");
              continue;
        }
        if(username.equals("UAE"))
        {
              System.out.println("Username Error");
              send_error_message(out, "This username is already in use. Please try again with a new one or Sign In.\n");

              continue;
        }
        if(username.equals("PSE"))
        {
             System.out.println("Password Error");
             send_error_message(out, "Your password is not strong enough. Please try again with new password\n");
             continue;
        }
        if(username.equals("SUS"))
        {
            System.out.println("Sign Up Successful");
        }

      	System.err.println("Got connection from " + username);
      	SenderThread st = new SenderThread(out);
      	new ReceiverThread(in, st, username);
      }
    }catch(IOException x){
      System.err.println("Dying: IOException");
      x.printStackTrace();
    }
  }
    private void send_error_message(SecureOutputStream out, String E) throws IOException
    {
    ByteArrayOutputStream baos = new ByteArrayOutputStream();
    baos.write(E.getBytes());
    baos.write(1);
    byte[] message = baos.toByteArray();
    out.write(message);
  }

  public static void main(String[] argv){
      RSA rsa = new RSA(2048);
      byte[] myPrivateKey  = rsa.getPrivateKey();
      byte[] myPublicKey  = rsa.getPublicKey();
      new ChatServer(myPrivateKey, myPublicKey);
  }

  private String getAuth(SecureInputStream in) throws IOException {

    try {

        byte[] length = new byte[4];
        int len1 = in.read(length);
        int len = ByteBuffer.wrap(length).getInt();
        byte[] b = new byte[len];
        int len2 = in.read(b);
//      AuthenticationInfo auth = (AuthenticationInfo)o;
        byte[] infoAuth = Arrays.copyOfRange(b, 0, len2);
        String infoAuth_str = new String(infoAuth);
        String[] info_list = infoAuth_str.split(":");
        String username = info_list[0];
        String pass = info_list[1];
        String mode = info_list[2];
        AuthenticationInfo auth = new AuthenticationInfo(username, pass, mode);
        return auth.getUserName();
    }
    catch(IOException x){
      x.printStackTrace();
      return null;
    }
  }

  class SenderThread extends Thread {


    private SecureOutputStream out;

    private Queue        queue;

    SenderThread(SecureOutputStream outStream) {

      out = outStream;
      queue = new Queue();
      activeSenders.add(this);
        start();
    }

    public void queueForSending(byte[] message){
      queue.put(message);
    }

    public void run() {
      try{
      	for(;;){
      	  Object o = queue.get();
      	  byte[] barr = (byte[])o;
      	  out.write(barr);
      	  out.flush();
      	}
      }
      catch(IOException x){
      	x.printStackTrace();
      	try{
      	  out.close();
      	}
        catch(IOException x2){
            x2.printStackTrace();

        }
      }
      activeSenders.remove(this);
    }
  }

  class ReceiverThread extends Thread {

    private SecureInputStream in;

      private SenderThread me;
    private byte[] userNameBytes;

    ReceiverThread(SecureInputStream inStream, SenderThread mySenderThread,

      String name) {
        System.out.println("Server");
      in = inStream;
      me = mySenderThread;
      String augmentedName = "[" + name + "] ";
      userNameBytes = augmentedName.getBytes();
        start();

    }

    public void run() {
      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      for(;;){

      	try{
      	  baos.write(userNameBytes);
      	  int c;
      	  do{
      	    c = in.read();
      	    if(c == -1){
      	      sendToOthers(baos);
      	      return;
      	    }
      	    baos.write(c);
      	  }while(c != '\n');
      	  sendToOthers(baos);
      	}
        catch(IOException x){
      	    System.err.println("Sending to Others");
      	  sendToOthers(baos);
      	  return;
      	}
      }
    }

    private final SenderThread[] stArr = new SenderThread[1];

    private void sendToOthers(ByteArrayOutputStream baos) {


      byte[] message = baos.toByteArray();
      baos.reset();

      SenderThread[] guys = (SenderThread[])(activeSenders.toArray(stArr));
      for(int i=0; i<guys.length; ++i){
      	SenderThread st = guys[i];
      	if(st != me)	st.queueForSending(message);
      }
    }
  }
}
