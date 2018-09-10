class Element {
	int value;

	public Element(int value) {
		this.value = value;
	}

	@Override
	public int hashCode() {
		return value;
	}
}

public class HashMap {

	Element[] buckets;

	public HashMap(int buckets) {
		this.buckets = new Element[buckets];
	}

	public Element put(Element e) {
		int bucket = e.hashCode() % buckets.length;
		Element prev = buckets[bucket];
		buckets[bucket] = e;
		return prev;
	}

	public static void main(String[] args) {
		HashMap map = new HashMap(15);
		map.put(new Element(0));

		VirtualMachine.benchmark_start();

		int n = 200000000;
		for(int i = 0; i < n; i++) {
			map.put(new Element(i));
		}

		Element out = map.put(new Element(0));
		VirtualMachine.benchmark_end();

		if(out == null) {
			VirtualMachine.exit(255);
		} else {
			VirtualMachine.exit(out.value);
		}
	}
}


