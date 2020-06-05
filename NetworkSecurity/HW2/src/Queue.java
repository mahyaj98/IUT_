// This file implements a queue data structure.  The queue follows a
// first-in-first-out discipline.  There is no upper bound on the number of 
// items that can be in a queue.
//
// To create a new queue, do this:
//
//          Queue q = new Queue();
//
// To add an item (which must be an Object, or a subclass of Object)
// to the queue, do this:
//
//          q.put(item);
//
// To remove the oldest item from the queue, do this:
//
//          Object o = q.get();
//
// Note that if the queue is empty, calls to get will block the calling thread,
// until something is put into the queue.


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
