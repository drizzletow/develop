
# 一 数组(array)

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

**冒泡排序（Bubble Sort）**：

- 比较相邻的元素。如果第一个比第二个大，就交换他们两个
- 对每一对相邻元素做同样的工作，从开始第一对到结尾的最后一对。在这一点，最后的元素应该会是最大的数
- 针对所有的元素重复以上的步骤，除了最后一个
- 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较

升序排列的口诀: N个数字来排队、 两两相比小靠前、外层 循环length-1、 内层循环length-i-1

降序排序的口诀: N个数字来排队、 两两相比大靠前、 外层 循环length-1、 内层循环length-i-1



**二分查找（Binary Search）：**

二分查找也称折半查找，它是一种效率较高的查找方法。但是，二分查找要求数组数据必须采用顺 序存储结构有序排列

- 首先，假设数组中元素是按升序排列，将数组中间位置的数据与查找数据比较，如果两者相等，则查找成功；否则利用 中间位置记录将数组分成前、后两个子数组，如果中间位置数据大于查找数据，则进一步查找前子数组，否则进一步查 找后子数组
- 重复以上过程，直到找到满足条件的数据，则表示查找成功， 直到子数组不存在为止，表示查找不成功



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

		// 使用 Binary Search 查找元素 6
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



<br/>



# 二 字符串

## 1. String类

 String类位于 java.lang 包中，在 Java 中每个双引号定义的字符串都是一个 String 类的对象。

**String对象不可变**：对象一旦被创建后，对象所有的状态及属性在其生命周期内不会发生任何变化，不可变的原因与本质：

![image-20220216190454092](vx_images/image-20220216190454092.png)





1. String 类的构造方法：

   ```java
   String()                        // 初始化一个新创建的 String对象，表示一个空字符序列   
   String(String original)         // 初始化一个新创建的 String对象，新创建的字符串是该参数字符串的副本
   String(char[] value)            // 分配一个新的字符串，将参数中的字符数组元素全部复制变为字符串
   String(char[] value,int offset,int count)  //offset是数组第一个字符的索引，count指定子数组的长度
   ```

2. String和int的相互转换

   ```java
   // String 字符串转整型 int 有以下两种方式：
   Integer.parseInt(str)
   Integer.valueOf(str).intValue()
       
   // int转换为String
   String s = String.valueOf(i);
   String s = Integer.toString(i);
   String s = "" + i;
   ```

3. String常用方法

   - length() ：获取字符串的长度

   - toLowerCase() ：将字符串中的所有字符全部转换成小写，而非字母的字符不受影响

   - toUpperCase() ：将字符串中的所有字符全部转换成大写，而非字母的字符不受影响

   - trim() ：去掉字符串中的首尾空格

   - substring(int beginIndex) ：提取从索引位置开始至结尾处的字符串部分

   - substring(int beginIndex，int endIndex) ：截取  [beginIndex，endIndex) 索引的字符串

     

4. String分割字符串

   ```java
   str.split(String sign)
   str.split(String sign,int limit)
   ```

   - sign 为指定的分割符，可以是任意字符串。

   - limit 表示分割后生成的字符串的限制个数，如果不指定，则表示不限制，直到将整个目标字符串完全分割为止。

   - 如果用“.”作为分隔的话，必须写成`String.split("\\.")`，这样才能正确的分隔开，不能用`String.split(".")`。

   - 如果用“|”作为分隔的话，必须写成`String.split("\\|")`，这样才能正确的分隔开，不能用`String.split("|")`。

   - 如果在一个字符串中有多个分隔符，可以用 `|` 作为连字符，比如：`"acount=? and uu =? or n=?"`，需要把三个都分隔出来，可以用`String.split("and|or")`。

     

5. 字符串查找

   - `indexOf() `方法用于返回字符（串）在指定字符串中首次出现的索引位置，如果能找到，则返回索引值，否则返回 -1
   - `lastIndexOf() `方法用于返回字符（串）在指定字符串中最后一次出现的索引位置，如果能找到则返回索引值，否则返回 -1
   - `charAt() `方法可以在字符串内根据指定的索引查找字符（字符串本质上是字符数组，因此它也有索引，索引从零开始）



6. 字符串的替换

   ```java
   replace(String oldChar, String newChar)         // 将目标字符串中的指定字符（串）替换成新的字符（串）
   replaceFirst(String regex, String replacement)  // 将目标字符串中匹配某正则表达式的第一个子字符串替换成新的字符串
   replaceAll(String regex, String replacement)    // 将目标字符串中匹配某正则表达式的所有子字符串替换成新的字符串
   ```

   

7. 字符串比较

   - `equals()` 方法将逐个地比较两个字符串的每个字符是否相同

     如果两个字符串具有相同的字符和长度，它返回 true，否则返回 false。( 区分大小写 )

   - `equalsIgnoreCase()` 方法的作用和语法与 equals() 方法完全相同，但是**不区分大小写**

   - `equals()` 方法和 `==` 运算符：

     - `==`运算符比较两个对象引用看它们是否引用相同的实例
     - equals() 原本也是比较引用是否相同，但String类重写了该方法，故而直接比较字符串对象中的字符

   - `compareTo() `方法用于按字典顺序比较两个字符串的大小，该比较是基于字符串各个字符的 Unicode 值

   ```java
   String str1 = new String("hello");
   String str2 = new String("hello");
   
   System.out.println(str1.equals(str2));    // true
   System.out.println(str1 == str2);         // false
   
   System.out.println("a".compareTo("A"));   // 32 ( 表示a在A之后32个字符序列 )
   ```

   

8. 字符串拼接

   String 字符串虽然是不可变字符串，但也可以进行拼接只是会产生一个新的对象。String 字符串拼接可以使用“+”运算符或 String 的 concat(String str) 方法。“+”运算符优势是可以连接任何类型数据拼接成为字符串，而 concat 方法只能拼接 String 类型字符串。

   ```java
   String str = "hello ";
   System.out.println(str + 99);                // hello 99
   System.out.println(str.concat("world"));     // hello world
   ```

   String被声明为 final class，是不可变字符串。因为它的不可变性，所以拼接字符串时候会产生很多无用的中间对象，如果频繁的进行这样的操作对性能有所影响。用+的方式效率最差，concat由于是内部机制实现，比+的方式好了不少（每次调用contact()方法就是一次数组的拷贝）虽然在内存中是处理都是原子性操作，速度非常快，但是，最后的return语句会创建一个**新String对象**，限制了concat方法的速度。

   

   **需要进行大量字符串拼接时，一定要使用StringBuffer或StringBuilder的append方法**：

   StringBuffer和StringBuilder的append方法都继承自AbstractStringBuilder，整个逻辑都只做**字符数组**的加长，拷贝，到最后也不会创建新的String对象，所以速度很快，完成拼接处理后在程序中用strBuffer.toString()来得到最终的字符串



## 2. StringBuilder

Java 提供了 String 类来创建和操作字符串。String 类是不可变类，即一旦一个 String 对象被创建以后，包含在这个对象中的字符序列是不可改变的，直至这个对象被销毁。因此Java 提供了两个可变字符串类 StringBuffer 和 StringBuilder，中文翻译为“字符串缓冲区”。StringBuilder 类是 JDK 1.5 新增的类，它也代表可变字符串对象。



实际上，StringBuilder 和 StringBuffer 功能基本相似，方法也差不多。不同的是，StringBuffer 是线程安全的，而 StringBuilder 则没有实现线程安全功能，所以性能略高。因此在通常情况下，如果需要创建一个内容可变的字符串对象，则应该优先考虑使用 StringBuilder 类。

![image-20211012010548734](vx_images/image-20211012010548734.png)

- 操作少量的数据使用 String
- 单线程操作大量数据使用 StringBuilder
- 多线程操作大量数据使用 StringBuffer

```java
// 使用 StringBuilder 拼接字符串, 反转字符串
StringBuilder stringBuilder = new StringBuilder();
stringBuilder.append("hello");
stringBuilder.append(" world");
System.out.println(stringBuilder.toString());            // hello world
System.out.println(stringBuilder.reverse().toString());  // dlrow olleh
```





## 3. 字符串常量池

由于String类型描述的字符串内容是常量不可改变，因此Java虚拟机将首次出现的字符串放入常量池中，若后续代码中出现了相同字符串内容则直接使用池中已有的字符串对象而无需申请内存及创建对象，从而提高了性能。

**String直接赋值和使用new的区别**：

- 直接赋值： 可能创建一个或者不创建对象
- 使用new： 可能创建一个或者两个对象，但一定会在heap（堆）中创建一个String对象

```java
public static void main(String[] args) {
    String name1 = "tom";
    String name2 = "tom";

    String str1 = new String("hello");
    String str2 = new String("hello");

    System.out.println(str1.equals(str2));   // true
    System.out.println(str1 == str2);        // false （String中"=="比较引用地址，equals比较具体值）

    String str3 = "hello";
    String str4 = str1.intern();
    System.out.println(str3 == str4);        // true
}
```

<img src="vx_images/image-20211013001617925.png" alt="image-20211013001617925" style="zoom: 67%;" />

上例中的对象创建解释：

- name1：先检查` “tom”`在常量池中是否存在，不存在 → 创建 `“tom”`对象放入常量池，并将name1指向该地址
- name2：由于`“tom”`已存在于常量池中，name2直接指向该地址



- str1：new关键字一定会在heap中创建`"hello"`，同时会检查常量池中是否存在该对象，不存在 → 则在常量池中创建该对象

- str2：同样会在heap中创建`"hello"`，检查到常量池中是已存在该对象后结束

- str3：由于`"hello"`已存在于常量池中，str3直接指向该地址

- str4：检查常量池已存在这个对象，直接返回其引用

  

`intern()`：如果常量池中已经包含了这个String对象，那么直接返回这个对象。否则，就向常量中添加这个对象，并返回对它的引用

（注意这里从jdk1.7起，**复制的是该对象的引用**，参照）如下示例：

```java
public class Demo {
    public static void main(String[] args) {
        String s = new String("aaa");
        String s1 = s.intern();
        System.out.println(s == s1);   // false

        String str1 = new String("abc");
        String str2 = new String("ddd");
        String str3 = str1 + str2;
        System.out.println(str3 == str3.intern()); // jdk1.7起为true，之前为false
    }
}
```

![image-20220216140357748](vx_images/image-20220216140357748.png)

注：通过new创建一个String对象时，会在创建的同时检查字符串常量池中是否存在该对象，不存在则加入该对象，此处没什么疑问，

关键在于：

- 该例中的字符串进行拼接时，并不会像new一个对象那样进行上述操作（即不会将‘abcddd’加入到常量池），此时 `str3` 指向一个堆中的对象，而当一个堆中的对象调用 `intern()` 方法时，从jdk1.7起由于方法区实现的改变，常量池转移到了堆中，成为了堆的一部分，而此处也不再是将该对象再加入常量池然后返回其引用，而是在常量池中加入其在堆中的引用， `intern()` 返回的也是该引用



**==与equals方法有什么区别**：

- == ,对于基本数据类型而言,比较的是内容,对于引用数据类型而言,比较的是引用变量,即所指向的地址
- equals方法是Object的方法,默认是比较2个对象的地址,若要比较内容,应当重写父类方法



