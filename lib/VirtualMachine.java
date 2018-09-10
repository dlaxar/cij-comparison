class VirtualMachine {

	static long time;

	static void benchmark_start() {
		time = System.nanoTime();
	}
	static void benchmark_end() {
		System.out.println(System.nanoTime()-time);
	}

	static void print_double(double d) {
		System.out.println(d);
	}

	static void print_array_int(int[] a) {
		if(a.length == 0) {
			System.out.println("[]");
			return;
		}

		System.out.print("[");
		for(int i = 0; i < a.length - 1; ++i) {
			System.out.print(a[i] + ", ");
		}
		System.out.println(a[a.length - 1] + "]");
	}

	static void exit(int code) {
		System.out.println("Exiting " + code);
		System.exit(code);
	}
}
