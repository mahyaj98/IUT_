import java.io.PrintStream;
import java.security.SecureRandom;
import java.util.Random;


public class Util {
  public static void indent(PrintStream out, int levels) {
    for(int i=0; i<levels; ++i)    out.print("  ");
  }

  private static final Random rand = new SecureRandom();

  public static byte[] getRandomByteArray(int num) {
    byte[] ret = new byte[num];
    rand.nextBytes(ret);
    return ret;
  }
}
