import java.util.ArrayList; // import the ArrayList class

/*
  Because Java’s arrays are kinda deprecated, I will use ArrayLists in
  this file. However, we will only use them in the manner that we can
  use DSSL2 vectors: aka, like arrays of contiguous block of memory.
*/

// Interface for a FIFO structure
interface IQueue<T> {
	public void enqueue(T elem);
	public T dequeue();
	public boolean isEmpty();
}

// Implements a FIFO structure using a fixed-sized array in a circular fashion.
class RingBuf<T> implements IQueue<T> {

	private ArrayList<T> data; // a continguous block of memory we will use
	private int start; // the index at which the first element of this queue resides
	private int len; // the number of elements in this queue

	public RingBuf(int capacity) throws IllegalArgumentException {
		if (capacity < 0) {
			throw new IllegalArgumentException("Capacity must be greater than zero.");
			}
		else {
			this.data = new ArrayList<T>(capacity);

			// nullizing an ArrayList to the stated capacity. Didn’t have to do this in DSSL2
            for (int i = 0; i < capacity; i++) {
				this.data.add(null);
			}

			this.start = 0;
			this.len = 0;
		}
	}

	public void enqueue(T elem) throws IllegalStateException {
		if (this.len == this.data.size()) {
			throw new IllegalStateException("RingBuf is full, cannot enqueue.");
			}
		else {
			int idx = (this.start + this.len) % this.data.size();
			this.data.set(idx,elem);
			this.len = this.len + 1;
		}
	}

	public T dequeue() throws IllegalStateException {
		if (this.isEmpty()) {
			throw new IllegalStateException("RingBuf is empty, cannot dequeue.");
			}
		else {
			T ret = this.data.get(this.start);
			this.start = (this.start + 1) % this.data.size();
			this.len = this.len - 1;
			return ret;
		}
	}

	public boolean isEmpty() {
		return this.len == 0;
	}

}

public class Main {

	public static void main(String[] args) {
		IQueue<String> sample = new RingBuf<String>(3);
		assert sample.isEmpty();
		sample.enqueue("Cat");
		sample.enqueue("Dog");
		String first = sample.dequeue();
		assert first.equals("Cat");
		sample.enqueue("Fish");
		String second = sample.dequeue();
		assert second.equals("Dog");
		assert sample.isEmpty() == false;
		System.out.printf("All good here!");
	}

}
