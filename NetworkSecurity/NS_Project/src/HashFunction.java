


import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


public class HashFunction {
  private MessageDigest dig;

  public HashFunction() {
    try{
      dig = MessageDigest.getInstance("SHA");
    }catch(NoSuchAlgorithmException x) {
      x.printStackTrace();
      dig = null;
    }
  }

  public void update(byte b) {
    dig.update(b);
  }

  public void update(byte[] arr) {
    dig.update(arr);
  }

  public void update(byte[] arr, int offset, int len) {
    dig.update(arr, offset, len);
  }

  public byte[] digest() {
    byte[] ret = dig.digest();
    dig.reset();
    return ret;
  }

  public void reset() {
    dig.reset();
  }
}
