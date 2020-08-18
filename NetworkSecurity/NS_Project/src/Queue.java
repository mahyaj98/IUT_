

import java.util.LinkedList;
import java.util.List;


public class Queue {
  private List lis = new LinkedList();

  public synchronized boolean isEmpty() {
    return lis.isEmpty();
  }

  public synchronized Object get() {
    while(isEmpty()){
      try{
	wait();
      }catch(InterruptedException x){ }
    }
    return lis.remove(0);
  }

  public synchronized void put(Object o) {
    lis.add(o);
    notify();
  }
}
