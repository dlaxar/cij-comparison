public class MergeSort {

	public static void mergeSort(int[] a) {
		int[] tmp = new int[a.length];
		mergeSortImpl(a, tmp, 0, a.length - 1);
	}


	private static void mergeSortImpl(int[] a, int[] tmp, int left, int right) {
		if(left < right) {
			int center = (left + right) / 2;
			mergeSortImpl(a, tmp, left, center);
			mergeSortImpl(a, tmp, center + 1, right);
			merge(a, tmp, left, center + 1, right);
		}
	}


	private static void merge(int[] a, int[] tmp, int left, int right, int rightEnd) {
		int leftEnd = right - 1;
		int k = left;
		int num = rightEnd - left + 1;

		while(left <= leftEnd && right <= rightEnd)
			if(a[left] <= a[right]) {
				tmp[k++] = a[left++];
			} else
				tmp[k++] = a[right++];

		while(left <= leftEnd)    // Copy rest of first half
			tmp[k++] = a[left++];

		while(right <= rightEnd)  // Copy rest of right half
			tmp[k++] = a[right++];

		// Copy tmp back
		for(int i = 0; i < num; i++, rightEnd--)
			a[rightEnd] = tmp[rightEnd];
	}

	public static int[] random(int seed, int max, int count) {
		int[] result = new int[count];
		for(int i = 0; i < count; ++i) {
			result[i] = randomImpl(seed, max);
			seed = result[i];
		}
		return result;
	}

	private static int randomImpl(int seed, int max) {
		int x = 1103515245 * seed;
		if(x < 0)
			x *= -1;
		return (((x + 12345) % 2147483647)) % (max + 1);
	}

	public static void main(String[] args) {
		int[] a = random(0, 1000000, 20000000);

		VirtualMachine.benchmark_start();
		mergeSort(a);
		VirtualMachine.benchmark_end();
		VirtualMachine.exit(0);
	}
}
