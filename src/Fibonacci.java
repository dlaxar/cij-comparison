public class Fibonacci {

	public static int fib(int n) {
		if(n <= 2) {
			return 1;
		}

		return fib(n - 1) + fib(n - 2);
	}

	public static void main(String[] args) {
		// warm up
		fib(0);
		VirtualMachine.benchmark_start();
		int f = fib(42);
		VirtualMachine.benchmark_end();

		VirtualMachine.exit(f);
	}
}