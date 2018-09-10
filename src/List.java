class Iterator {

	Element ptr;

	public Iterator(Element ptr) {
		this.ptr = ptr;
	}

	boolean hasNext() {
		return ptr != null;
	}

	Element next() {
		Element ret = ptr;
		ptr = ptr.next;
		return ret;
	}
}

class Element {
	Element next;
	int value;

	public Element(int value) {
		this.value = value;
	}

	boolean hasNext() {
		return next != null;
	}
}

public class List {

	Element root;

	Iterator iterator() {
		return new Iterator(root);
	}

	void add(Element e) {
		if(root == null) {
			root = e;
			return;
		}

		Iterator it = iterator();

		Element tail = null;
		while(it.hasNext()) {
			tail = it.next();
		}

		tail.next = e;
	}

	int size() {
		int size = 0;
		Iterator it = iterator();
		while(it.hasNext()) {
			it.next();
			size++;
		}

		return size;
	}


	public static void main(String[] args) {
		List list = new List();
		list.add(new Element(-1));

		VirtualMachine.benchmark_start();
		int n = 30000;
		for(int i = 0; i < n; i++) {
			list.add(new Element(i));
		}

		VirtualMachine.benchmark_end();
		VirtualMachine.exit(list.size());
	}
}
