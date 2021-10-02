# 数组

数组是相同数据类型的多个数据的容器，这些元素按线性顺序排列。

所谓线性顺序是指除第一个元素外，每一个元素都有唯一的前驱元素；除最后一个 元素外，每一个元素都有唯一的后继元素

```java
int[] arr1;       // java数组
int arr2[];       // C/C++风格
```

## 1. 一维数组

```java
// 数组的创建和初始化：
int[] arr1 = {1,2,3,4,5};
int[] arr2 = new int[100];            //初始值全为0, boolean 则为false , 对象为 null
arr2 = new int[]{12,33,21,43,22,45};  // 初始化一个匿名数组并赋值给 arr2

// 数组的拷贝
int[] nums = arr2;  // nums 和 arr2 指向同一个数组
int[] copiedNums = Arrays.copyOf(arr2, arr2.length);  // 真正的数组拷贝

//  数组的排序
Array.sort(arr2);

// 数组的输出
for (int i = 0; i < nums.length; i++) {
    System.out.print(nums[i] + " ");
}
System.out.println(Arrays.toString(arr2));
```

**数组下标**：对于长度为 n 的数组，下标的范围是 0 ~ n-1



## 2. 二维数组

```java
double[][] balances;
balances = new double[3][4];   // 将 balances 初始化为 0

int[][] magicSquare ={
    	{34, 44, 21, 44}, 
    	{22, 32, 11, 99}, 
    	{54, 33, 29, 84}}; 

System.out.println (Arrays.deepToString(magicSquare));   // 快速打印二维数组
```



## 3. 数组常用算法

```java
/**
 * 排序并查找 对数组{1,3,9,5,6,7,15,4,8}进行排序，然后使用二分查找元素 6 并输出排序后的下标。
 */
public class ArrayDemo {
	public static void main(String[] args) {
		int[] nums = { 1, 3, 9, 5, 6, 7, 15, 4, 8 };

		// Bubble Sort
		for (int i = 0; i < nums.length - 1; i++) {
			for (int j = 0; j < nums.length - i - 1; j++) {
				if (nums[j] > nums[j + 1]) {
					nums[j] = nums[j] ^ nums[j + 1];
					nums[j + 1] = nums[j] ^ nums[j + 1];
					nums[j] = nums[j] ^ nums[j + 1];
				}
			}
		}
		System.out.println("排序后的数组：" + Arrays.toString(nums));

		// 使用二分查找元素 6
		int target = 6;
		int minIndex = 0;
		int maxIndex = nums.length;
		int centreIndex = (minIndex + maxIndex) / 2;
		while (true) {
			if (minIndex > maxIndex) {
				System.out.println("Not found！");
				break;
			}
			if (target < nums[centreIndex]) {
				maxIndex = centreIndex - 1;
			} else if (target > nums[centreIndex]) {
				minIndex = centreIndex + 1;
			} else {
				System.out.println(target + "的下标为：" + centreIndex);
				break;
			}
			centreIndex = (minIndex + maxIndex) / 2;
		}
	}

}
```

