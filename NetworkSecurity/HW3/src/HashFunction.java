// This class implements a cryptographic hash function.
// To use it, you must first create an HashFunction object:
//
//         HashFunction hf = new HashFunction();
//
// Having created it, you feed it the data you want to hash.  You can feed
// the data in in chunks.  To feed in a byte, use
//
//         byte b = ...
//         hf.update(b);
//
// To feed in an entire array of bytes, use
//
//         byte[] barr = ...
//         hf.update(barr);
//
// To feed in part of an array of bytes, use
//
//         byte[] barr = ...
//         hf.update(barr, int offset, int len);
//
// This feeds in the subarray from barr[offset] to barr[offset+len-1].
// When you've fed in all of the bytes you want to hash, you can get the
// result by calling
//
//         byte[] hashResult = hf.digest();
//
// After calling digest(), the HashFunction object is reset, so you can reuse
// it as if it were a newly created HashFunction object.
// You can also call reset() on a HashFunction if you want to reset it.



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
