package ex2Hanoi;

/**
 * Stack data structure
 * @author joao
 *
 */
public class Stack {
	
	/**
	 * storage array
	 */
	private int[] stack;
	/**
	 * stack pointer
	 */
	private int ptr;
	/**
	 * size of the stack
	 */
	private int size;
	/**
	 * id of the stack
	 */
	private char id;

	/**
	 * Stack class constructor
	 * @param size of the stack
	 */
	public Stack(int size, char id) {
		this.size = size;
		this.stack = new int[size];
		this.ptr = 0;
		this.id = id;
	}
	
	/**
	 * @return true if stack is empty, false otherwise
	 */
	public boolean isEmpty() {
		return ptr == 0;
	}
	
	/**
	 * @return true is stack is full, false otherwise
	 */
	public boolean isFull() {
		return ptr == size;
	}
	
	/**
	 * @param c character to be inserted at the top of the stack
	 */
	public void push(int c) {
		if(isFull()) {
			System.out.println("ERROR: Stack is full");
			return;
		}
		stack[ptr] = c;
		ptr++;
	}
	
	/**
	 * @return and remove item at the top of the stack
	 */
	public int pop() {
		if(isEmpty()) {
			System.out.println("ERROR: Stack is empty");
			return 0;
		}
		ptr--;
		return stack[ptr];
	}

	/**
	 * @return without removing the value at the top of the stack
	 */
	public int peek() {
		if(isEmpty())
			return 0;
		return stack[ptr-1];	
	}
	
	/**
	 * @return id of the stack
	 */
	public char getId() {
		return this.id;
	}
	
	@Override
	public String toString() {
		String s="[";
		for(int i=0; i < size; i++) {
			if(i < ptr)
				s+=stack[i];
			else
				s+="-";
			if(i != size-1)
				s+=" ";
		}
		return s+"]";
	}
	
	
}
