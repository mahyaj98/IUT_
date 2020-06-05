import javax.swing.*;
import java.io.Serializable;
import java.util.HashMap;
import java.io.*;

public class AuthenticationInfo implements Serializable {

  private String username;
  private  String password;
  private String Mode;
  private HashMap<String, String> map = new HashMap<String, String> ();

  public AuthenticationInfo(String name, String pass, String mode) {
    username = name;
    password = pass;
    Mode = mode;
    String filePath = "passwd.txt";
    String line;
    BufferedReader reader = null;
    try {
      reader = new BufferedReader(new FileReader(filePath));
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    try {
      while ((line = reader.readLine()) != null) {
        String[] parts = line.split(":", 2);
        if (parts.length >= 2) {
          String key = parts[0];
          String value = parts[1];
          map.put(key, value);
        }
      }
      reader.close();
    }catch (IOException io)
    {
      io.printStackTrace();
    }
  }

  public boolean checkStrength(String pass)
  {
    if( pass.length() < 8 )
      return true;
    if( ! pass.matches("(?=.*[0-9]).*") )
      return true;
    if( ! pass.matches("(?=.*[a-z]).*") )
      return true;
    if( ! pass.matches("(?=.*[A-Z]).*") )
      return true;
    if( ! pass.matches("(?=.*[~!@#$%^&*()_-]).*") )
      return true;
    return false;
  }
  public boolean isValid() {



    if (map.containsKey(username) && map.get(username).equals(password))
    {
      return true;
    }
    return false;
  }
  public String getUserName() {
    if (Mode.equals("In"))
    {
      return isValid() ? username : "SIE";
    }
    System.out.println("Signing Up");
    if(map.containsKey(username))
    {
      return "UAE";
    }
    if(checkStrength(password)) {
      return "PSE";
    }
    File file = new File("passwd.txt");
    FileWriter fr = null;
    try {
      fr = new FileWriter(file, true);
    } catch (IOException e) {
      e.printStackTrace();
    }
    BufferedWriter br = new BufferedWriter(fr);
    try {
      br.write(username+":"+password+"\n");
    } catch (IOException e) {
      e.printStackTrace();
    }

    try {
      br.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
    try {
      fr.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
    return "SUS";

  }
}
