
import java.io.FileInputStream;
import java.util.Properties;

import java.io.IOException;


public class Config {
  private static String configFileName = "config.txt";

  private static boolean needInit = true;

  private static Properties props;

  private static void init() {
    needInit = false;
    try{
      FileInputStream fis = new FileInputStream(configFileName);
      if(fis != null){
	props = new Properties();
	props.load(fis);
      }
    }catch(IOException x){
      x.printStackTrace(System.err);
    }
  }
  
  public static String getAsString(String name) {
    if(needInit)    init();
    return props.getProperty(name);
  }

  public static int getAsInt(String name) {
    if(needInit)    init();
    return Integer.parseInt(getAsString(name));
  }
}
