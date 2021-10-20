# 一 常用类库

## 1. 泛型

Java 泛型（generics）是 JDK 5 中引入的一个新特性, 泛型提供了编译时类型安全检测机制，该机制允许开发者在编译时检测到非法的类型。泛型的本质是参数化类型，也就是说所操作的数据类型被指定为一个参数。在使用/调用时传入具体的类型（类型实参）。

Java采用类型擦除(Type erasure generics)的方式实现泛型。用大白话讲就是这个泛型只存在源码中，编译器将源码编译成字节码之时，就会把泛型『擦除』，所以字节码中并不存在泛型。注意 Java 泛型不支持基本数据类型。

```java
// 泛型类：（在实例化泛型类时，需要指明泛型类中的类型参数，并赋予泛型类属性相应类型的值）
public class ClassName<dataType1,dataType2,…>{
    private dataType1 propertyName1;
	private dataType2 propertyName2;
}

// 定义一个泛型类：
public class ClassName<T>{
    private T data;
    
    public T getData() {
    	return data;
    }
    public void setData(T data) {
    	this.data = data;
    }
}
```

```java
// 泛型接口
public interface IntercaceName<T>{
	T getData();
}

// 实现接口时，可以选择指定泛型类型，也可以选择不指定
// 指定类型 如下：
public class Interface1 implements IntercaceName<String> {
    private String text;
    
    @Override
    public String getData() {
   	 return text;
    }
}

// 不指定类型：
public class Interface1<T> implements IntercaceName<T> {
    private T data;
    
    @Override
    public T getData() {
    	return data;
    }
}
```

```java
// 泛型方法，例如: 
public static <T> List find(Class<T> cs,int userId){
    
}
```

- 是否拥有泛型方法，与其所在的类是不是泛型没有关系
- 如果 static 方法需要使用泛型能力，就必须使其成为泛型方法





**泛型的高级用法**:

1. 限制泛型可用类型

   ```java
   class ClassName<T extends AnyClass>    // AnyClass 指某个接口或类
   ```

   使用泛型限制后，泛型类的类型 必须实现或继承 AnyClass 这个接口或类。

   或者说必须是 AnyClass类的子类 或 AnyClass接口的实现类。

   

   ```java
   // 当没有使用 extends 关键字限制泛型类型时，其实是默认使用 Object 类作为泛型类型/
   public class ClassName<T> {}
   // 等同于：
   public class ClassName<T extends Object> {}
   ```

   

2. 使用类型通配符

- ？表示不确定的 java 类型，通常用于泛型方法的调用代码和形参，不能用于定义类和泛型方法
- T (type) 表示具体的一个java类型，通常用于泛型类和泛型方法的定义
- K V (key value) 分别代表java键值中的Key Value
- E (element) 代表Element



上界通配符` < ? extends E>`：表示参数化的类型可能是所指定的类型，或者是此类型的子类。

- 如果传入的类型不是 E 或者 E 的子类，编译不成功
- 泛型中可以使用 E 的方法，否则需要强转成 E 才能使用

下界通配符 `< ? super E>`：表示参数化的类型可能是所指定的类型，或者是此类型的父类型，直至 Object



在编译之后程序会采取去泛型化的措施。也就是说Java中的泛型，只在编译阶段有效。在编译过程中，正确检验泛型结果后，会将泛型的相关信息擦出，并且在对象进入和离开方法的边界处添加类型检查和类型转换的方法。也就是说，泛型信息不会进入到运行时阶段。



## 2. Objects

在JDK7版本的时候，Java引入了`java.util.Objects`工具类，用于封装一些平时使用频度很高或容易出错的操作，这些操作形成了Objects的各个方法。

```java
public final class Objects {
	
    public static boolean equals(Object a, Object b) {
        return (a == b) || (a != null && a.equals(b));
    }
    
    public static boolean deepEquals(Object a, Object b) {
        if (a == b)
            return true;
        else if (a == null || b == null)
            return false;
        else
            return Arrays.deepEquals0(a, b);
    }
}

```

equals()：有别于`Object.equals()`，这个方法可以避免空指针异常。

deepEquals()：`Object.equals()`用于比较两个对象的引用是否相同，而`deepEquals()`却扩展成了可以支持数组。



## 3. Math

Math 类位于 java.lang 包，封装了常用的数学运算，它的构造方法是 private 的，因此无法创建 Math 类的对象。

-  Math 类中的所有方法都是类方法，可以直接通过类名来调用它们。

- Math 类中包含 $E$ 和 $PI$ 两个静态常量，正如它们名字所暗示的，它们的值分别等于 $e$（自然对数）和  $π$（圆周率）。

```java
// 随机数例子：
Math.random()                         // [0.0，1.0)之间的随机数
Math.random()*100                     // [0.0，100.0)之间的随机数
Math.random()*98 + 2                  // [2.0，100.0)之间的随机数
(int)(Math.random()*98 + 2)           // [2，100)之间的随机整数
    
// 产生随机数还可以借助java.util.Random类
Random random = new Random();    // 以当前时间为默认种子, 可以使用 Random(long seed) 以指定的种子值
int num = random.nextInt(100);   // 生成一个随机的int值，该值介于[0,100)的区间
double d = random.nextDouble();  //产生[0,1)范围的随机小数
```



**(1) 求最大值、最小值和绝对值**

| 方法                                 | 说明                   |
| ------------------------------------ | ---------------------- |
| static int abs(int a)                | 返回 a 的绝对值        |
| static long abs(long a)              | 返回 a 的绝对值        |
| static float abs(float a)            | 返回 a 的绝对值        |
| static double abs(double a)          | 返回 a 的绝对值        |
| static int max(int x,int y)          | 返回 x 和 y 中的最大值 |
| static double max(double x,double y) | 返回 x 和 y 中的最大值 |
| static long max(long x,long y)       | 返回 x 和 y 中的最大值 |
| static float max(float x,float y)    | 返回 x 和 y 中的最大值 |
| static int min(int x,int y)          | 返回 x 和 y 中的最小值 |
| static long min(long x,long y)       | 返回 x 和 y 中的最小值 |
| static double min(double x,double y) | 返回 x 和 y 中的最小值 |
| static float min(float x,float y)    | 返回 x 和 y 中的最小值 |



**(2) 取整方法**

| 方法                           | 说明                                                         |
| ------------------------------ | ------------------------------------------------------------ |
| static double ceil(double a)   | 返回大于或等于 a 的最小整数（向上取整）                      |
| static  double floor(double a) | 返回小于或等于 a 的最大整数（向下取整）                      |
| static double rint(double a)   | 返回最接近 a 的整数值，如果有两个同样接近的整数，则结果取偶数（四舍六入五取偶） |
| static  int round(float a)     | 将原来的数字加上0.5后再向下取整 （四舍五入）                 |
| static long round(double a)    | 将原来的数字加上0.5后再向下取整（长整型 ）                   |

```java
System.out.println(Math.ceil(1.1));    // 2.0
System.out.println(Math.ceil(-1.1));   // -1.0 向上取整

System.out.println(Math.floor(1.1));   // 1.0
System.out.println(Math.floor(-1.1));  // -2.0 向下取整

System.out.println(Math.rint(-1.4));   // -1.0
System.out.println(Math.rint(-1.5));   // -2.0 （四舍六入五取偶）
System.out.println(Math.rint(-2.5));   // -2.0  

System.out.println(Math.round(1.4f));  // 1  (表示”四舍五入”)
System.out.println(Math.round(-1.5f)); // -1 (-1.5 + 0.5 = -1.0 取整为 -1)
System.out.println(Math.round(-1.51)); // -2 (-1.51 + 0.5 = -1.01 向下取整为 -2)
System.out.println(Math.round(-1.6f)); // -2 (-1.6 + 0.5 = -1.1 向下取整为 -2)
```



**(3) 指数运算**

| 方法                                  | 说明                               |
| ------------------------------------- | ---------------------------------- |
| static double exp(double a)           | 返回 e 的 a 次幂                   |
| static  double pow(double a,double b) | 返回以 a 为底数，以 b 为指数的幂值 |
| static double sqrt(double a)          | 返回 a 的平方根                    |
| static  double cbrt(double a)         | 返回 a 的立方根                    |
| static double log(double a)           | 返回 a 的自然对数，即 lna 的值     |
| static  double log10(double a)        | 返回以 10 为底 a 的对数            |



**(4) 三角函数**

| 方法                                    | 说明                                                       |
| --------------------------------------- | ---------------------------------------------------------- |
| static double sin(double a)             | 返回角的三角正弦值，参数以孤度为单位                       |
| static  double cos(double a)            | 返回角的三角余弦值，参数以孤度为单位                       |
| static double asin(double a)            | 返回一个值的反正弦值，参数域在 [-1,1]，值域在 [-PI/2,PI/2] |
| static  double acos(double a)           | 返回一个值的反余弦值，参数域在 [-1,1]，值域在  [0.0,PI]    |
| static double tan(double a)             | 返回角的三角正切值，参数以弧度为单位                       |
| static  double atan(double a)           | 返回一个值的反正切值，值域在  [-PI/2,PI/2]                 |
| static double toDegrees(double  angrad) | 将用孤度表示的角转换为近似相等的用角度表示的角             |
| staticdouble  toRadians(double angdeg)  | 将用角度表示的角转换为近似相等的用弧度表示的角             |



## 4. Arrays

Arrays 类是一个工具类，其中包含了数组操作的很多方法。这个 Arrays 类里均为 static 修饰的方法（static 修饰的方法可以直接通过类名调用）

```java
1. 对数组进行升序排序
Array.sort(Object[] array)
    
// 从元素下标为from,到下标为to-1的元素进行排序    
Arrays.sort(Object[] array, int from, int to)    

2. 为数组元素填充相同的值    
Arrays.fill(Object[] array,Object object)
// 对数组的部分元素填充一个值,从起始位置到结束位置，取头不取尾
Arrays.fill(Object[] array,int from,int to,Object object)    
    
3. 返回数组的字符串形式
Arrays.toString(Object[] array)
// 返回多维数组的字符串形式
Arrays.deepToString(Object[][] arrays)
```



## 5. BigDecimal

BigDecimal 类支持任何精度的浮点数，可以用来精确计算货币值。

- BigDecimal(double val)：实例化时将双精度型转换为 BigDecimal 类型
- BigDecimal(String val)：实例化时将字符串形式转换为 BigDecimal 类型

```java
BigDecimal add(BigDecimal augend)                                     // 加法操作
BigDecimal subtract(BigDecimal subtrahend)                            // 减法操作
BigDecimal multiply(BigDecimal multiplieand)                          // 乘法操作
BigDecimal divide(BigDecimal divisor,int scale,int roundingMode )     // 除法操作
```

| 模式名称                    | 说明                                                         |
| --------------------------- | ------------------------------------------------------------ |
| BigDecimal.ROUND_UP         | 商的最后一位如果大于 0，则向前进位，正负数都如此             |
| BigDecimal.ROUND_DOWN       | 商的最后一位无论是什么数字都省略                             |
| BigDecimal.ROUND_CEILING    | 商如果是正数，按照 ROUND_UP 模式处理；如果是负数，按照 ROUND_DOWN 模式处理 |
| BigDecimal.ROUND_FLOOR      | 与 ROUND_CELING 模式相反，商如果是正数，按照 ROUND_DOWN 模式处理； 如果是负数，按照 ROUND_UP 模式处理 |
| BigDecimal.ROUND_HALF_ DOWN | 对商进行五舍六入操作。如果商最后一位小于等于 5，则做舍弃操作，否则对最后 一位进行进位操作 |
| BigDecimal.ROUND_HALF_UP    | 对商进行四舍五入操作。如果商最后一位小于 5，则做舍弃操作，否则对最后一位 进行进位操作 |
| BigDecimal.ROUND_HALF_EVEN  | 如果商的倒数第二位是奇数，则按照 ROUND_HALF_UP 处理；如果是偶数，则按 照 ROUND_HALF_DOWN 处理 |



## 6. Date

Date 类表示系统特定的时间戳，可以精确到毫秒。Date 对象表示时间的默认顺序是星期、月、日、小时、分、秒、年。

Date 类有如下两个构造方法。

- Date()：此种形式表示分配 Date 对象并初始化此对象，以表示分配它的时间（精确到毫秒），使用该构造方法创建的对象可以获取本地的当前时间。
- Date(long date)：此种形式表示从 GMT 时间（格林尼治时间）1970 年 1 月 1 日 0 时 0 分 0 秒开始经过参数 date 指定的毫秒数。

```java
System.out.println(new Date());   // Tue Oct 12 20:08:43 CST 2021
System.out.println(new Date(0));  // Thu Jan 01 08:00:00 CST 1970
```

Date 类带 long 类型参数的构造方法获取的是距离 GMT 指定毫秒数的时间，而 GMT（格林尼治标准时间）与 CST（中央标准时间）相差 8 小时，也就是说 `1970 年 1 月 1 日 00:00:00 GMT` 与 `1970 年 1 月 1 日 08:00:00 CST` 表示的是同一时间。



Date类中的常用方法：

| 方法                            | 描述                                                         |
| ------------------------------- | ------------------------------------------------------------ |
| boolean after(Date when)        | 判断此日期是否在指定日期之后                                 |
| boolean  before(Date when)      | 判断此日期是否在指定日期之前                                 |
| int compareTo(Date anotherDate) | 比较两个日期的顺序                                           |
| boolean  equals(Object obj)     | 比较两个日期的相等性                                         |
| long getTime()                  | 返回自 1970 年 1 月 1 日 00:00:00 GMT 以来，此 Date 对象表示的毫秒数 |
| String  toString()              | 把此 Date 对象转换为以下形式的 String:  dow mon dd hh:mm:ss zzz yyyy |



## 7. DateFormat

DateFormat 是日期/时间格式化子类的抽象类，它以与语言无关的方式格式化并解析日期或时间，在创建 DateFormat 对象时不能使用 new 关键字，而应该使用 DateFormat 类中的静态方法 getDateInstance()

```java
DateFormat df = DateFormat.getDatelnstance();
```

| 方法                                                         | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| String format(Date date)                                     | 将 Date 格式化日期/时间字符串                                |
| Calendar getCalendar()                                       | 获取与此日期/时间格式相关联的日历                            |
| static DateFormat getDateInstance()                          | 获取具有默认格式化风格和默认语言环境的日期格式               |
| static DateFormat getDateInstance(int style)                 | 获取具有指定格式化风格和默认语言环境的日期格式               |
| static DateFormat getDateInstance(int style, Locale locale)  | 获取具有指定格式化风格和指定语言环境的日期格式               |
| static DateFormat getDateTimeInstance()                      | 获取具有默认格式化风格和默认语言环境的日期/时间 格式         |
| static DateFormat getDateTimeInstance(int dateStyle,int timeStyle) | 获取具有指定日期/时间格式化风格和默认语言环境的 日期/时间格式 |
| static DateFormat getDateTimeInstance(int dateStyle,int timeStyle,Locale locale) | 获取具有指定日期/时间格式化风格和指定语言环境的 日期/时间格式 |
| static DateFormat getTimeInstance()                          | 获取具有默认格式化风格和默认语言环境的时间格式               |
| static DateFormat getTimeInstance(int style)                 | 获取具有指定格式化风格和默认语言环境的时间格式               |
| static DateFormat getTimeInstance(int style, Locale locale)  | 获取具有指定格式化风格和指定语言环境的时间格式               |
| void setCalendar(Calendar newCalendar)                       | 为此格式设置日历                                             |
| Date parse(String source)                                    | 将给定的字符串解析成日期/时间                                |

格式化样式主要通过 DateFormat 常量设置。将不同的常量传入到上表所示的方法中，以控制结果的长度。DateFormat 类的常量如下：

- SHORT：完全为数字，如 12.5.10 或 5:30pm。
- MEDIUM：较长，如 May 10，2021。
- LONG：更长，如 May 12，2021 或 11:15:32am。
- FULL：是完全指定，如 Tuesday、May 10、2021 AD 或 11:15:42am CST。

```java
DateFormat dateInstance = DateFormat.getDateInstance(DateFormat.FULL, Locale.CHINA);
DateFormat timeInstance = DateFormat.getTimeInstance(DateFormat.FULL, Locale.CHINA);

String date = dateInstance.format(new Date());
String time = timeInstance.format(new Date());

System.out.println(date);  // 2021年10月12日 星期二
System.out.println(time);  // 下午08时42分36秒 CST
```



如果使用 DateFormat 类格式化日期/时间并不能满足要求，那么就需要使用 DateFormat 类的子类——SimpleDateFormat。

SimpleDateFormat 类主要有如下 3 种构造方法：

- SimpleDateFormat()：用默认的格式和默认的语言环境构造 SimpleDateFormat。
- SimpleDateFormat(String pattern)：用指定的格式和默认的语言环境构造 SimpleDateF ormat。
- SimpleDateFormat(String pattern, Locale locale)：用指定的格式和指定的语言环境构造 SimpleDateF ormat。




SimpleDateFormat 自定义格式中常用的字母及含义：

| 字母 | 含义                                                         | 示例                                                         |
| ---- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| y    | 年份。一般用 yy 表示两位年份，yyyy 表示 4 位年份             | 使用 yy 表示的年扮，如 11； 使用 yyyy 表示的年份，如 2021    |
| M    | 月份。一般用 MM 表示月份，如果使用 MMM，则会 根据语言环境显示不同语言的月份 | 使用 MM 表示的月份，如 05； 使用 MMM 表示月份，在 Locale.CHINA 语言环境下，如“十月”；在 Locale.US 语言环境下，如 Oct |
| d    | 月份中的天数。一般用 dd 表示天数                             | 使用 dd 表示的天数，如 10                                    |
| D    | 年份中的天数。表示当天是当年的第几天， 用 D 表示             | 使用 D 表示的年份中的天数，如 295                            |
| E    | 星期几。用 E 表示，会根据语言环境的不同， 显示不 同语言的星期几 | 使用 E 表示星期几，在 Locale.CHINA 语 言环境下，如“星期四”；在 Locale.US 语 言环境下，如 Thu |
| H    | 一天中的小时数（0~23)。一般用 HH 表示小时数                  | 使用 HH 表示的小时数，如 18                                  |
| h    | 一天中的小时数（1~12)。一般使用 hh 表示小时数                | 使用 hh 表示的小时数，如 10 (注意 10 有 可能是 10 点，也可能是 22 点） |
| m    | 分钟数。一般使用 mm 表示分钟数                               | 使用 mm 表示的分钟数，如 29                                  |
| s    | 秒数。一般使用 ss 表示秒数                                   | 使用 ss 表示的秒数，如 38                                    |
| S    | 毫秒数。一般使用 SSS 表示毫秒数                              | 使用 SSS 表示的毫秒数，如 156                                |

```java
// Date对象转换成时间字符串
SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日 E HH:mm:ss");
System.out.println(sdf.format(new Date()));  // 2021年10月12日 星期二 20:36:58

// 字符串转换成时间Date对象
SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
Date date = null;
try {
    date = simpleDateFormat.parse("2021-10-1");
}catch (ParseException e) {
    e.printStackTrace();
} 
System.out.println(date);  // Wed Oct 13 00:00:00 CST 2021
```



## 8. Calender

Calendar 类是一个抽象类，因此创建 Calendar 对象不能使用 new 关键字，它提供了一个 getInstance() 方法来获得 Calendar类的对象。getInstance() 方法返回一个 Calendar 对象，其日历字段已由当前日期和时间初始化。

```java
Calendar c = Calendar.getInstance();
```

| 方法                                                         | 描述                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| void add(int field, int amount)                              | 根据日历的规则，为给定的日历字段 field 添加或减去指定的时间量 amount |
| boolean after(Object when)                                   | 判断此 Calendar 表示的时间是否在指定时间 when 之后，并返回判断结果 |
| boolean before(Object when)                                  | 判断此 Calendar 表示的时间是否在指定时间 when 之前，并返回判断结果 |
| void clear()                                                 | 清空 Calendar 中的日期时间值                                 |
| int compareTo(Calendar anotherCalendar)                      | 比较两个 Calendar 对象表示的时间值（从格林威治时间 1970 年 01 月 01 日 00 时 00 分 00 秒至现在的毫秒偏移量），大则返回 1，小则返回 -1，相等返回 0 |
| int get(int field)                                           | 返回指定日历字段的值                                         |
| int getActualMaximum(int field)                              | 返回指定日历字段可能拥有的最大值                             |
| int getActualMinimum(int field)                              | 返回指定日历字段可能拥有的最小值                             |
| int getFirstDayOfWeek()                                      | 获取一星期的第一天。根据不同的国家地区，返回不同的值         |
| static Calendar getInstance()                                | 使用默认时区和语言坏境获得一个日历                           |
| static Calendar getInstance(TimeZone zone)                   | 使用指定时区和默认语言环境获得一个日历                       |
| static Calendar getInstance(TimeZone zone, Locale aLocale)   | 使用指定时区和语言环境获得一个日历                           |
| Date getTime()                                               | 返回一个表示此 Calendar 时间值（从格林威治时间 1970 年 01 月 01 日 00 时 00 分 00 秒至现在的毫秒偏移量）的 Date 对象 |
| long getTimeInMillis()                                       | 返回此 Calendar 的时间值，以毫秒为单位                       |
| void set(int field, int value)                               | 为指定的日历字段设置给定值                                   |
| void set(int year, int month, int date)                      | 设置日历字段 YEAR、MONTH 和 DAY_OF_MONTH 的值                |
| void set(int year, int month, int date, int hourOfDay, int minute, int second) | 设置字段 YEAR、MONTH、DAY_OF_MONTH、HOUR、 MINUTE 和 SECOND 的值 |
| void setFirstDayOfWeek(int value)                            | 设置一星期的第一天是哪一天                                   |
| void setTimeInMillis(long millis)                            | 用给定的 long 值设置此 Calendar 的当前时间值                 |

Calendar 对象可以调用 set() 方法将日历翻到任何一个时间，当参数 year 取负数时表示公元前。Calendar 对象调用 get() 方法可以获取有关年、月、日等时间信息，参数 field 的有效值由 Calendar 静态常量指定。

Calendar 类中定义了许多常量，分别表示不同的意义。

- Calendar.YEAR：年份。
- Calendar.MONTH：月份。
- Calendar.DATE：日期。
- Calendar.DAY_OF_MONTH：日期，和上面的字段意义完全相同。
- Calendar.HOUR：12小时制的小时。
- Calendar.HOUR_OF_DAY：24 小时制的小时。
- Calendar.MINUTE：分钟。
- Calendar.SECOND：秒。
- Calendar.DAY_OF_WEEK：星期几。



```java
Calendar calendar = Calendar.getInstance();   // 如果不设置时间，则默认为当前时间
calendar.setTime(new Date());                 // 将系统当前时间赋值给 Calendar 对象

calendar.getTime();                           // 获取当前时间
int year = calendar.get(Calendar.YEAR);       // 获取当前年份
int month = calendar.get(Calendar.MONTH) + 1; // 获取当前月份（月份从 0 开始，所以加 1）
int day = calendar.get(Calendar.DATE);        // 获取日

int week = calendar.get(Calendar.DAY_OF_WEEK) - 1;    // 获取今天星期几（以星期日为第一天）
int hour = calendar.get(Calendar.HOUR_OF_DAY);        // 获取当前小时数（24 小时制）
int minute = calendar.get(Calendar.MINUTE);           // 获取当前分钟
int second = calendar.get(Calendar.SECOND);           // 获取当前秒数
int millisecond = calendar.get(Calendar.MILLISECOND); // 获取毫秒数

int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);                 // 获取今天是本月第几天
int dayOfWeekInMonth = calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH);   // 获取今天是本月第几周
int many = calendar.get(Calendar.DAY_OF_YEAR);                        // 获取今天是今年第几天

Calendar c = Calendar.getInstance();
c.set(2021, 11, 11);                     // 设置年月日，时分秒将默认采用当前值
```



## 9. System

1. 获取系统当前毫秒值 `public static long currentTimeMillis()`

   ```java
   System.out.println(System.currentTimeMillis());    // 1634043714170
   System.out.println(new Date().getTime());          // 1634043714170
   ```

2. 结束正在运行的Java程序 `public staitc void exit(int status)`

   ```java
   System.exit(0);
   ```

3. 运行JVM中的垃圾回收器，完成内存中垃圾的清除 `public static void gc()`

   ```java
    System.gc();    
   ```

4. 确定当前的系统属性 `public static getProperties()`

   ```java
   System.out.println(System.getProperties());
   ```

5. System类方法复制数组

   ```java
   public static native void arraycopy(Object src, int srcPos, Object dest, int destPos,int length);
   ```

   - Object src：要复制的原数组；
   - Int srcPos：数组源的起始索引；
   - Object dest：复制后的目标数组；
   - int destPos：目标数组起始索引；
   - int length，指定复制的长度；

   ```java
   public static void main(String[] args) {
       int[] arr1 = {1, 2, 3, 4, 5, 6};
       int[] arr2 = {8, 9, 10};
   
       System.arraycopy(arr1, 2, arr2, 0, 2);
       System.out.println(Arrays.toString(arr2));   // [3, 4, 10]
   }
   ```



## 10. String

 String类位于 java.lang 包中，在 Java 中每个双引号定义的字符串都是一个 String 类的对象。

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



## 11. StringBuilder

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



## 11. String常量池

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



# 二 Java集合

为了保存数量不确定的数据，以及保存具有映射关系的数据（也被称为关联数组），Java提供了集合类。集合类主要负责保存、盛装其他数据，因此集合类也被称为容器类。

- 集合类和数组不一样，数组元素既可以是基本类型的值，也可以是对象（实际上保存的是对象的引用变量），

- 而集合里只能保存对象（实际上只是保存对象的引用变量）

  

Java 集合类型分为 Collection 和 Map，它们是 Java 集合的根接口，下图为Collection 和 Map 的子接口及其常用实现类：

![image-20211014103244479](vx_images/image-20211014103244479.png)

Java集合接口的作用：

| 接口名称   | 作  用                                                       |
| ---------- | ------------------------------------------------------------ |
| Iterator   | 集合的输出接口，主要用于遍历输出（即迭代访问）Collection 集合中的元素，Iterator 对象被称之为迭代器。迭代器接口是集合接口的父接口，实现类实现 Collection 时就必须实现 Iterator 接口。 |
| Collection | 是 List、Set 和 Queue 的父接口，是存放一组单值的最大接口。所谓的单值是指集合中的每个元素都是一个对象。一般很少直接使用此接口直接操作。 |
| Queue      | Queue 是 Java 提供的队列实现，有点类似于 List。              |
| Dueue      | 是 Queue 的一个子接口，为双向队列。                          |
| List       | 是最常用的接口。是有序集合，允许有相同的元素。使用 List 能够精确地控制每个元素插入的位置，用户能够使用索引（元素在 List 中的位置，类似于数组下标）来访问 List 中的元素，与数组类似。 |
| Set        | 不能包含重复的元素。                                         |
| Map        | 是存放一对值的最大接口，即接口中的每个元素都是一对，以 `key➡value` 的形式保存。 |

Collection中定义了单列集合(List和Set)通用的一些方法， 这些方法可用于操作所有的单列集合。方法如下： 

```java
public boolean add(E e)       // 把给定的对象添加到当前集合中 。 
public void clear()           // 清空集合中所有的元素。
public boolean remove(E e)    // 把给定的对象在当前集合中删除。 
public boolean contains(E e)  // 判断当前集合中是否包含给定的对象。 
public boolean isEmpty()      // 判断当前集合是否为空。 
public int size()             // 返回集合中元素的个数。 
public Object[] toArray()     // 把集合中的元素，存储到数组中。
```



Java集合实现类的作用：

| Class      | description                                                  |
| ---------- | ------------------------------------------------------------ |
| ArrayList  | 底层是数组结构实现，查询快、增删慢                           |
| LinkedList | 底层是链表结构实现，查询慢、增删快                           |
| Vector     | 相对于ArrayList来说，它是线程安全的，同时提供了指定扩容增量的构造方法 |
| HashSet    | 底层数据结构是哈希表, 无序，不包含重复元素（为优化査询速度而设计） |
| HsahMap    | 按哈希算法来存取键对象                                       |



## 1. ArrayList

ArrayList 类实现了可变数组的大小，存储在内的数据称为元素。它还提供了快速基于索引访问元素的方式，对尾部成员的增加和删除支持较好。

- ArrayList的默认构造函数会初始化一个空数组，第一次添加元素时才扩容至10（JDK8 中改为这种懒加载模式？）
- 建议开发中如果能知道数组大小，预先指定大小避免多次扩容、 复制数据



ArrayList类的常用方法：

| 方法名称                                    | 说明                                                         |
| ------------------------------------------- | ------------------------------------------------------------ |
| public boolean add(E e)                     | 添加过程中会自动扩容，返回结果一定为true                     |
| E get(int index)                            | 获取此集合中指定索引位置的元素，E 为集合中元素的数据类型     |
| int index(Object o)                         | 返回此集合中第一次出现指定元素的索引，如果此集合不包含该元 素，则返回 -1 |
| int lastIndexOf(Object o)                   | 返回此集合中最后一次出现指定元素的索引，如果此集合不包含该 元素，则返回 -1 |
| E set(int index, Eelement)                  | 将此集合中指定索引位置的元素修改为 element 参数指定的对象。 此方法返回此集合中指定索引位置的原元素 |
| List<E> subList(int fromlndex, int tolndex) | 返回一个新的集合，新集合中包含 fromlndex 和 tolndex 索引之间 的所有元素。包含 fromlndex 处的元素，不包含 tolndex 索引处的 元素 |

```java
public class ListDemo {
    public static void main(String[] args) {
        List list = new ArrayList();
        list.add("Java");
        list.add("c/c++");
        list.add("swift");

        System.out.println(list.size());                   //3
        System.out.println(list);                          //[Java, c/c++, swift]
		// 遍历列表
        for (int i = 0; i < list.size(); i++) {
            System.out.print(list.get(i)+" ");             //Java c/c++ swift
        }
        System.out.println("\n");

        System.out.println(list.remove(1));                // c/c++  移除并返回其值
        System.out.println(list.remove("Java"));           // true   返回是否执行成功的布尔值
        System.out.println(list);                          // [swift]
    }
}
```



## 2. LinkedList

LinkedList 类采用链表结构保存对象，这种结构的优点是便于向集合中插入或者删除元素。需要频繁向集合中插入和删除元素时，使用 LinkedList 类比 ArrayList 类效果高，但是 LinkedList 类随机访问元素的速度则相对较慢。这里的随机访问是指检索集合中特定索引位置的元素。



LinkedList 类除了包含 Collection 接口和 List 接口中的所有方法之外，还特别提供了下面的方法：

| 方法名称           | 说明                         |
| ------------------ | ---------------------------- |
| void addFirst(E e) | 将指定元素添加到此集合的开头 |
| void addLast(E e)  | 将指定元素添加到此集合的末尾 |
| E getFirst()       | 返回此集合的第一个元素       |
| E getLast()        | 返回此集合的最后一个元素     |
| E removeFirst()    | 删除此集合中的第一个元素     |
| E removeLast()     | 删除此集合中的最后一个元素   |



## 3. Vector

Vector 类实现了一个动态数组。和 ArrayList 很相似，但是两者是不同的：

- Vector 是同步访问的（线程安全的）
- Vector 还包含了许多传统的方法，这些方法不属于集合框架。



Vector 类的4种构造方法：

```java
Vector()                    // 默认大小为 10
Vector(int size)            // 指定大小
Vector(int size,int incr)   // 指定大小，并且增量用 incr 指定（增量表示每次增加的元素数目）
Vector(Collection c)        // 创建一个包含集合的Vector
```

当Vector容量不足以容纳全部元素时，Vector的容量会增加。**若容量增加系数 >0，则将容量的值增加“容量增加系数”；否则，将容量大小增加一倍。**



## 4. HashSet

Set 集合类似于一个罐子，程序可以依次把多个对象“丢进”Set 集合，而 Set 集合通常不能记住元素的添加顺序。也就是说 

- Set 集合中的对象不按特定的方式排序，只是简单地把对象加入集合。

- Set 集合中不能包含重复的对象，并且最多只允许包含一个 null 元素。

Set 实现了 Collection 接口，它主要有两个常用的实现类：HashSet 类和 TreeSet类。

- HashSet 是 Set 接口的典型实现，大多数时候使用 Set 集合时就是使用这个实现类。
- HashSet 是按照 Hash 算法来存储集合中的元素。因此具有很好的**存取和查找**性能。

```java
public class SetDemo {
    public static void main(String[] args) {
        Set set = new HashSet();
		// 向集合添加元素,（集合元素是无序且唯一的，插入等同于add）
        set.add("yellow");
        set.add("red");
        set.add("black");
        set.add("white");

        System.out.println(set);               //[red, white, yellow, black]
		// 使用迭代器遍历
        Iterator it = set.iterator();
        while (it.hasNext()){
            System.out.print(it.next()+" ");   //red white yellow black
        }
    }
}
```

当向 HashSet 集合中存入一个元素时：

- HashSet 会调用该对象的 hashCode() 方法来得到该对象的 hashCode 值
- 然后根据该 hashCode 值决定该对象在 HashSet 中的存储位置
- 如果有两个元素通过 equals() 方法比较返回的结果为 true，但它们的 hashCode 不相等，HashSet 将会把它们存储在不同的位置，依然可以添加成功。



## 5. TreeSet

TreeSet 类同时实现了 Set 接口和 SortedSet 接口。SortedSet 接口是 Set 接口的子接口，可以实现对集合进行自然排序，因此使用 TreeSet 类实现的 Set 接口默认情况下是自然排序的，这里的自然排序指的是升序排序。

- **TreeSet 只能对实现了 Comparable 接口的类对象进行排序**，因为 Comparable 接口中有一个 `compareTo(Object o)` 方法用于比较两个对象的大小。例如 `a.compareTo(b)`：

  - 如果 a 和 b 相等，则该方法返回 0；

  - 如果 a 大于 b，则该方法返回大于 0 的值；

  - 如果 a 小于 b，则该方法返回小于 0 的值。

- 在使用自然排序时只能向 TreeSet 集合中添加相同数据类型的对象，否则会抛出 ClassCastException 异常。

  

Comparable接口类对象的比较方式：

| 类                                                           | 比较方式                                  |
| ------------------------------------------------------------ | ----------------------------------------- |
| BigDecimal、Biglnteger、 Byte、Double、Float、Integer、Long 及 Short | 按数字大小比较                            |
| Character                                                    | 按字符的 Unicode 值的数字大小比较         |
| String                                                       | 按字符串中字符的 Unicode 值的数字大小比较 |



TreeSet 类除了实现 Collection 接口的所有方法之外，还提供了下列方法：

| 方法名称                                       | 说明                                                         |
| ---------------------------------------------- | ------------------------------------------------------------ |
| E first()                                      | 返回此集合中的第一个元素。其中，E 表示集合中元素的数据类型   |
| E last()                                       | 返回此集合中的最后一个元素                                   |
| E poolFirst()                                  | 获取并移除此集合中的第一个元素                               |
| E poolLast()                                   | 获取并移除此集合中的最后一个元素                             |
| SortedSet<E> subSet(E fromElement,E toElement) | 返回一个新的集合，新集合包含原集合中 fromElement 对象与 toElement 对象之间的所有对象。包含 fromElement 对象，不包含 toElement 对象 |
| SortedSet<E> headSet<E toElement〉             | 返回一个新的集合，新集合包含原集合中 toElement 对象之前的所有对象。 不包含 toElement 对象 |
| SortedSet<E> tailSet(E fromElement)            | 返回一个新的集合，新集合包含原集合中 fromElement 对象之后的所有对 象。包含 fromElement 对象 |



## 6. Iterator

Iterator（迭代器）是一个接口，它的作用就是遍历容器的所有元素，也是Java 集合框架的成员

- Collection 和 Map 系列集合主要用于盛装其他对象
- Iterator 则主要用于遍历（即迭代访问）Collection 集合中的元素

Iterator 接口隐藏了各种 Collection 实现类的底层细节，向应用程序提供了遍历 Collection 集合元素的统一编程接口。Iterator 接口里定义了如下 4 个方法：

```java
boolean hasNext()  // 如果被迭代的集合元素还没有被遍历完，则返回 true。
Object next()      // 返回集合里的下一个元素。
void remove()      // 删除集合里上一次 next 方法返回的元素。
void forEachRemaining(Consumer action) //这是Java8为Iterator新增的默认方法，该方法可使用Lambda表达式来遍历集合元素
```

- Iterator 仅用于遍历集合，必须通过一个可以被迭代的集合创建 Iterator 对象
- 当使用 Iterator 迭代访问 Collection 集合元素时，Collection 集合里的元素不能被改变，只能通过 Iterator 的 remove() 方法删除上一次 next() 方法返回的集合元素，否则将会引发“java.util.ConcurrentModificationException”异常。
- Iterator 迭代器采用的是快速失败（fail-fast）机制，一旦在迭代过程中检测到该集合已经被修改（通常是程序中的其他线程修改），程序立即引发 ConcurrentModificationException 异常，而不是显示修改后的结果，这样可以避免共享资源而引发的潜在问题。

```java
public class IteratorTest {
    public static void main(String[] args) {
        HashSet<String> hashSet = new HashSet<>();
        hashSet.add("hello");
        hashSet.add("hashSet");
        hashSet.add("Set");
        System.out.println(hashSet);  // [Set, hashSet, hello]

        Iterator<String> iterator = hashSet.iterator();
        while(iterator.hasNext()){
            String s = iterator.next();
            if("Set".equals(s)){
                // hashSet.remove(s);  //java.util.ConcurrentModificationException
                iterator.remove();
            }
        }
        System.out.println(hashSet);  // [hashSet, hello]
    }
}
```



## 7. foreach

除了使用 Iterator 接口迭代访问 Collection 集合里的元素，jdk1.5 还提供的 foreach 循环迭代访问集合元素，而且更加便捷。

- 与使用 Iterator 接口迭代访问集合元素类似的是，foreach 循环中的迭代变量也不是集合元素本身，系统只是依次把集合元素的值赋给迭代变量，因此在 foreach 循环中修改迭代变量的值也没有任何实际意义。
- 它的内部原理其实也是Iterator迭代器，所以在遍历的过程中，不能对集合中的元素进行增删操作，否则将引发异常。

```java
public class ForeachTest {
    public static void main(String[] args) {
        Set<String> hashSet = new HashSet<>();
        hashSet.add("hello");
        hashSet.add("hashSet");
        hashSet.add("Set");

        for (String str : hashSet) {
            System.out.println(str);
        }
    }
}
```



## 8. Comparable

实现此接口的`compareTo()`方法的对象列表（和数组）可以通过Collections.sort（和Arrays.sort）进行自动排序

```java
public class Student implements Comparable<Student> {
    private String name;
    private int age;
    private double score;
    /**
     * @DESCRIPTION 重写compareTo方法
     */
    @Override
    public int compareTo(Student obj) {
        if (this.score < obj.score){
            return 1;
        }else if(this.score > obj.score){
            return -1;
        }else{
            if(this.age < obj.age){
                return 1;
            }else if(this.age > obj.age){
                return -1;
            }else {
                return 0;
            }
        }
    }
}
```





## 9. Comparator

可以将Comparator 传递给sort方法（如Collections.sort 或 Arrays.sort），从而允许在排序顺序上实现精确控制

```java
public class SortDemo {
    public static void main(String[] args) {
        ArrayList<Student> list = new ArrayList<>();
        list.add(new Student("贾宝玉", 14, 88.5));
        list.add(new Student("林黛玉", 13, 90.5));
        list.add(new Student("史湘云", 13, 85));
        list.add(new Student("甄宝玉", 16, 85));
        list.add(new Student("薛宝钗", 15, 91));
        System.out.println("排序前：" + list);

        // 类实现类Comparable接口的排序方式
        // Collections.sort(list);

        // Comparator接口的排序方式
        Collections.sort(list, new Comparator<Student>() {
            @Override
            public int compare(Student o1, Student o2) {
                if (o1.getScore() < o2.getScore()) {
                    return 1;
                } else if (o1.getScore() > o2.getScore()) {
                    return -1;
                } else {
                    if (o1.getAge() < o2.getAge()) {
                        return 1;
                    } else if (o1.getAge() > o2.getAge()) {
                        return -1;
                    } else {
                        return 0;
                    }
                }
            }
        });
        System.out.println("排序后：" + list);
    }
}
```

![image-20211017154231946](vx_images/image-20211017154231946.png)



## 10. HashMap

Map 是一种键-值对（key-value）集合，Map 集合中的每一个元素都包含一个键（key）对象和一个值（value）对象。用于保存具有映射关系的数据。

- key 和 value 都可以是任何引用类型的数据
- Map 接口主要有两个实现类：HashMap 类和 TreeMap 类。其中，HashMap 类按哈希算法来存取键对象，而 TreeMap 类可以对键对象进行排序。

Map接口的常用方法：

| 方法名称                                 | 说明                                                         |
| ---------------------------------------- | ------------------------------------------------------------ |
| void clear()                             | 删除该 Map 对象中的所有 key-value 对。                       |
| boolean containsKey(Object key)          | 查询 Map 中是否包含指定的 key，如果包含则返回 true。         |
| boolean containsValue(Object value)      | 查询 Map 中是否包含一个或多个 value，如果包含则返回 true。   |
| V get(Object key)                        | 返回 Map 集合中指定键对象所对应的值。V 表示值的数据类型      |
| V put(K key, V value)                    | 向 Map 集合中添加键-值对，如果当前 Map 中已有一个与该 key 相等的 key-value 对，则新的 key-value 对会覆盖原来的 key-value 对。 |
| void putAll(Map m)                       | 将指定 Map 中的 key-value 对复制到本 Map 中。                |
| V remove(Object key)                     | 从 Map 集合中删除 key 对应的键-值对，返回 key 对应的 value，如果该 key 不存在，则返回 null |
| boolean remove(Object key, Object value) | 这是 Java8 新增的方法，删除指定 key、value 所对应的 key-value 对。如果从该 Map 中成功地删除该 key-value 对，该方法返回 true，否则返回 false。 |
| Set entrySet()                           | 返回 Map 集合中所有键-值对的 Set 集合，此 Set 集合中元素的数据类型为 Map.Entry |
| Set keySet()                             | 返回 Map 集合中所有键对象的 Set 集合                         |
| boolean isEmpty()                        | 查询该 Map 是否为空（即不包含任何 key-value 对），如果为空则返回 true。 |
| int size()                               | 返回该 Map 里 key-value 对的个数                             |
| Collection values()                      | 返回该 Map 里所有 value 组成的 Collection                    |

```java
public class MapDemo {
    public static void main(String[] args) {
        Map<String, String> animal = new HashMap<String, String>();
        animal.put("cat", "小猫");
        animal.put("dog", "小狗");
        animal.put("pig", "小猪");

        // 遍历（迭代器）
		// 1. 输出 value的值
        Iterator<String> it = animal.values().iterator();
        while (it.hasNext()) {
            System.out.print(it.next() + " ");
        }
        System.out.println("\n——————————————————————————————————————————");

		// 2. 通过 entrySet 方法打印 key 和 value 的值
        Set<Map.Entry<String,String>> entrySet = animal.entrySet();
        for(Map.Entry<String,String> entry:entrySet){
            System.out.print(entry.getKey()+"-");
            System.out.println(entry.getValue());
        }
        System.out.println("\n——————————————————————————————————————————");

		// 查找（根据 key查找值）
        String search = "cat";
        Set<String> keySet = animal.keySet();
        for(String key:keySet){
            if(search.equals(key)){
                System.out.println("OK! "+key+"-"+animal.get(key));
                break;
            }
        }
    }
}
```



