# 一 行为参数化





# 二 lambda表达式

## 1. 语法简介

Lambda 表达式是 JDK8 的一个新特性，可以取代接口的匿名内部类，写出更优雅的Java 代码。

如果说匿名内部类实际上是局部内部类的更进一步，简化了局部内部类，那么Lambda就是匿名内部类更进一步，语法上更简洁了，代码更优雅了

1. Lambda表达式仍然是局部内部类，是特殊的局部内部类，仍然定义在局部位置。而且局部内部类的注意事项，也一样存在。
2. Lambda表达式在取代匿名内部类时，不是全部都取代，而是取代接口的匿名内部类，而类的匿名内部类Lambda表达式是不能取代的。
3. Lambda表达式是匿名内部类的更进一步， <font color=red size=5>Lambda表达式得到的不是一个类，而是一个对象，并且是接口的子类对象。</font> 

<br/>

**Lambda语法格式**： 

```java
(形参列表) -> {
 // 方法体
}
```

1. `(形参列表)`表示功能接口中，必须要重写的抽象方法的形参列表
2. `->`由一个`英文横杠 + 英文大于号`字符组成，它是Lambda表达式的运算符，读作`goes to` 
3. `{ //方法体 }`表示功能接口中，必须要重写的抽象方法的方法实现

**因为语法中仅有一套形参列表和方法体，只能重写一个方法。** 而且，这个语法写出来，很明显**Lambda表达式只能重写父接口中的抽象方法，是不能自己新增成员的！** 

<br/>



## 2. 功能接口

Lambda表达式虽然说是取代接口的匿名内部类，但也不是什么接口都能用Lambda表达式创建子类对象。

**Lambda表达式要求的接口中，必须有且仅有一个必须要实现的抽象方法。这种接口在Java中，被称之为"功能接口"。**  

功能接口在语法上，可以使用注解`@FunctionalInterface`标记在接口头上，用于检测一个接口是否是功能接口。

```java
@FunctionalInterface
interface IA{
    void test();
}
```

<font color=red size=4> **功能接口指的是，有且仅有一个必须要子类实现的抽象方法的接口** </font> 

思考两个问题：

1. 功能接口中只能有一个方法吗？ 不是，Java8起，默认方法和静态方法不需要子类实现，功能接口中可以允许有它们存在

2. 功能接口中只能有一个抽象方法吗？ 不是，有极个别比较特殊的抽象方法，可以不需要子类实现

   如：Object类是Java每一个类的父类，所以Object类当中的方法实现就可以作为接口抽象方法的实现

   ```java
   @FunctionalInterface
   interface IA{
     void test();
     boolean equals(Object obj);
   }
   // 接口IA仍然是一个功能方法，因为抽象方法boolean equals(Object obj);可以直接使用Object类中的实现，无需子类实现
   ```



<br/>

## 3. 类型推断

在方法等局部位置，写上述语法后，肯定会报错。原因在于Java是强类型语言，任何变量都有它的数据类型，而直接写Lambda表达式语言，编译器是无从得知它的数据类型的——**这个Lambda表达式创建了接口的子类对象，到底是哪个接口的子类对象呢？**

![image-20220211184533256](vx_images/image-20220211184533256.png)

所以我们需要帮助编译器，明确Lambda表达式所表示的对象的类型，这个过程称之为 **"Lambda表达式的类型推断"**: 

1. **直接用父接口引用接收。**由于Lambda表达式表示的子类对象并没有自己独有的成员，所以直接用父类引用接收完全不会有任何问题。

   <br/>

2. **不用引用接收，但是要直接告诉编译器Lambda表达式是哪个接口的子类对象，语法上有点像强转（但不是）**。

   ```java
   public class LambdaDemo {
       public static void main(String[] args) {
           ((IA) () -> {
               System.out.println("Hello");
           }).show();
       }
   }
   
   interface IA {
       void show();
   }
   ```

   这种方式有点类似于匿名对象，所以必须直接调用方法，不然会编译语法报错。

   <br/>

3. **借助方法完成类型推断（最主要的使用方式）**  

   1. 可以借助方法的返回值数据类型完成类型推断，因为方法的返回值编译器已经知道该返回什么对象
   2. 可以借助方法的形参的数据类型完成类型推荐，因为方法的实参编译器已经知道该传入什么对象



<br/>

## 4. 简化使用

**Lambda表达式的进阶使用**: (Lambda表达式的简化)

<font color=red> **Lambda表达式能够简化的前提是：它是功能接口的子类对象，而功能接口中有且只有一个必须要实现的抽象方法！**  </font> 

- <font color=blue>形参列表</font>：

  - 参数类型可以省略
  - 如果形参列表中的形参只有一个，那么`()`小括号，也是可以省略的。但是如果形参为空则不可省略

- <font color=blue>方法体</font>：

  - **如果方法重写的方法体只有一条语句的话，那么可以省略大括号。（类似于if/for省略大括号）** 

  - **特殊的，如果只有一条语句且这条语句是返回值语句，那么大括号和return可以一起省略** 

    

- **Lambda表达式的抽象方法的实现可以直接指向一个已经存在的方法，而不是自己书写实现。这种语法在Java中称之为"方法引用"**  

  ```java
  public class Demo {
      public static void main(String[] args) {
          IA ia = Demo::method;
          System.out.println(ia.add(1.1, 1.2));
      }
  
      public static double method(double a, double b) {
          return a + b;
      }
  }
  
  @FunctionalInterface
  interface IA {
      double add(double a, double b);
  }
  ```



```java
/**
 * @Classname Demo
 * @Description 一些Lambda表达式的简单使用示例
 * @CreateTime 2022/2/12 13:58
 * @CreatedBy itdrizzle
 */
public class Demo {
    public static void main(String[] args) {
        INoReturnNoParam nrnp = () -> System.out.println("无返回值无参数的功能接口");
        nrnp.test();

        INoReturnOneParam nrop = a -> System.out.println("无返回值有一个参数的功能接口, a = " + a);
        nrop.test(11);

        INoReturnTwoParam nrtp = Demo::method;
        nrtp.test(1, 2);

        IHasReturnNoParam hrnp = () -> 111;
        System.out.println("有返回值无参数的功能接口, 方法的返回值为：" + hrnp.test());

        IHasReturnOneParam hrop = a -> a * 2;
        System.out.println("有返回值一个参数的功能接口, a * 2 = " + hrop.method(3));

        IHasReturnTwoParam hrtp = (int a, int b) -> a + b;
        System.out.println("有返回值两个参数的功能接口, 两数之和为：" + hrtp.test(1, 1));
    }

    public static void method(int a, int b){
        System.out.println("无返回值两个参数的功能接口, a = " + a + ", b = " + b);
    }
}

//无返回值无参数的功能接口
@FunctionalInterface
interface INoReturnNoParam {
    void test();
}

//无返回值有一个参数的功能接口
@FunctionalInterface
interface INoReturnOneParam {
    void test(int a);
}

//无返回值两个参数的功能接口
@FunctionalInterface
interface INoReturnTwoParam {
    void test(int a, int b);
}

//有返回值无参数的功能接口
@FunctionalInterface
interface IHasReturnNoParam {
    int test();
}

//有返回值一个参数的功能接口
@FunctionalInterface
interface IHasReturnOneParam {
    int method(int a);
}

//有返回值两个参数的功能接口
@FunctionalInterface
interface IHasReturnTwoParam {
    int test(int a, int b);
}
```

![image-20220212155127508](vx_images/image-20220212155127508.png)



<br/>

## 5. 注意事项

<font color=red> **Lambda表达式没有自身独立的作用域，不能自定义成员，只能和方法共用同一个作用域** </font> 

但`方法引用`的方式例外，毕竟一个独立的方法不可能受此限制



**Lambda表达式的优缺点**：

**优点**：

- 极大得简化了代码，使代码变得更加优雅。

- 函数式编程的代表，可能是未来高端的编程趋势

  Lambda表达式在Stream API中，配合集合类去使用，代码非常优雅和简洁，并且高效，实际开发中十分常用



**缺点**： 

- 过于简单的Lambda表达式，显然可读性很低
- 过于简洁也意味着不容易Debug。（当然idea有专门调试Lambda表达式的功能）
- 语法难度不低，熟练使用需要时间锻炼



<br/>

## 6. 应用示例

按照 **规则** 过滤字符串数组中的元素：

```java
public class FilterDemo {
    public static void main(String[] args) {
        String[] strArr = {"23333", "China666", "people666", "computer", "886"};

        System.out.println("原数组：" + Arrays.toString(strArr));

        // 过滤规则：保留所有以 666 结尾的字符串
        String[] str1 = StringTool.getNewStringArrByFilter(strArr, str -> str.endsWith("666"));
        System.out.println(Arrays.toString(str1));

        // 过滤规则：去除所有末尾为 6 的字符串
        String[] str2 = StringTool.getNewStringArrByFilter(strArr, str -> !str.endsWith("6"));
        System.out.println(Arrays.toString(str2));
    }

    // 功能接口,表示过滤,表示对String数组中元素的过滤规则
    @FunctionalInterface
    interface StringArrFiler {
        boolean accept(String str);
    }

    static class StringTool {
        public static String[] getNewStringArrByFilter(String[] oldArr, StringArrFiler filter) {
            ArrayList<String> list = new ArrayList<>();
            for (String str : oldArr) {
                if (filter.accept(str)) {
                    list.add(str);
                }
            }
            String[] result = new String[list.size()];
            list.toArray(result);
            return result;
        }
    }
}
```

![image-20220212150411737](vx_images/image-20220212150411737.png)



<br/>

## 7. 自然排序

**集合排序**示例：

```java
public class SortDemo {
    public static void main(String[] args) {
        List<Student> list = new ArrayList<>();
        list.add(new Student(1L, "张三疯", 68));
        list.add(new Student(2L, "张无忌", 18));
        list.add(new Student(3L, "张翠山", 38));

        for (Student student : list) {
            System.out.println(student);
        }


        // 在java8以前(没有Lambda表达式)对于对象排序，需要实现匿名内部类来做比较
        System.out.println("——————————————按年龄由小到大排序——————————————");
        Collections.sort(list, new Comparator<Student>() {
            @Override
            public int compare(Student o1, Student o2) {
                return o1.getAge().compareTo(o2.getAge());
            }
        });
        for (Student student : list) {
            System.out.println(student);
        }

        // 使用Lambda表达式实现排序
        System.out.println("——————————————按年龄由大到小排序——————————————");
        Collections.sort(list, (o1, o2) -> o2.getAge().compareTo(o1.getAge()));
        for (Student student : list) {
            System.out.println(student);
        }
    }
}
```

![image-20220212154115918](vx_images/image-20220212154115918.png)



<br/><br/>

# 三 Stream流

**什么是流**?

流是Java API, 它允许我们以声明的方式来处理集合数据, 也就是说我们不再需要编写一个实现来操作要处理的数据, 而是类似于数据库那样通过查询语句来表达. (Stream 使用一种类似用 SQL 语句从数据库查询数据的直观方式来提供一种对 Java 集合运算和表达的高阶抽象。)

java中集合类数据处理的一种简化方式

<font color=red size=5>Stream流是JDK1.8引入的一套函数式API、提供了一种对 Java 集合运算和表达的高阶抽象，其管道（pipelining）和内部迭代的特征使其处理集合数据更加简洁和灵活。</font> 

<br/>

**流用来解决什么问题**?

<font color=red size=5>Stream流一般用来处理Java中的集合类数据, 以避免在日常代码书写中对集合数据操作的性能以及代码冗长问题.</font> 



**流有哪些优点**?

1,Stream流是一个集合元素的函数模型，它并不是集合，也不是数据结构，其本身并不存储任何元素.

2,Stream流是在对函数模型进行操作，(在终结触发之前)集合元素并没有真正被处理. 

   只有当终结方法执行的时候，整个模型才会按照指定策略执行操作. (而这得益于Lambda的延迟执行特性.)

3,对集合数据操作的性能优化,解决代码冗长问题.

...

<br/>

**流的思想是什么**?

和Collection操作不同的是Stream操作有两个基础的特征：

- **Pipelining**: 中间操作都会返回流对象本身. 这样多个操作可以串联成一个管道， 如同**流式风格(ﬂuent style)**.
   这样做可以对操作进行优化.

- **内部迭代**: 以前对集合遍历都是通过Iterator或者增强for的方式, 显式的在集合外部进行迭代， 这叫做外部迭代.
   Stream提供了内部迭代的方式，流可以直接调用遍历方法.



<br/>

**<span style="color:red">怎么使用流</span>** ?

使用一个流的时候，通常包括三个基本步：

- 1, 一个数据源, 创建一个流

- 2,一个中间操作, 形成一条流水线

- 3, 一个终止/终端操作, 执行流水线,并生成结果

注意: 每次中间操作原有 Stream 对象不改变,返回一个新的 Stream (可以有多次中间操作),这就允许对其操作可以像链条一样排列,变成一个管道.



<br/>

## 1. 流的创建

> Java 8引入了一套新的类库，位于包java.util.stream下，称为Stream API。这套API操作数据的思路不同于我们之前介绍的容器类API，它们是函数式的，非常简洁、灵活、易读。
>
> Stream接口 类似于一个迭代器，但提供了更为丰富的操作，Stream API的主要操作就定义在该接口中。



Java 8 给Collection接口增加了两个默认方法，它们可以返回一个Stream

```java
// stream()返回的是一个顺序流 (由一个线程执行操作)
default Stream<E> stream() {
    return StreamSupport.stream(spliterator(), false);
}

// parallelStream()返回的是一个并行流 (并行流背后可能有多个线程并行执行)
default Stream<E> parallelStream() {
    return StreamSupport.stream(spliterator(), true);
}
```

> 注意：与普通的并发技术不同，使用并行流不需要显式管理线程，使用方法与顺序流是一样的



<br/>

**创建流的三种方式**：

除了调用集合类的stream方法, 生成一个流外，还可以通过“值” 或 数组来创建Stream流

```java
// 1. 调用集合类的stream方法,生成一个流(最常用/常见)
Collection collection = new ArrayList();
Stream stream = collection.stream();

// 2, 由值创建
Stream<String> zs = Stream.of("zs", "ls", "wu", "zl");

// 3, 由数组创建
String [] strs = {"zs", "ls", "wu"};
Stream<String> stream = Arrays.stream(strs);

```



<br/>



**函数式数据处理**，与传统代码相比，其特点是：

1）没有显式的循环迭代，循环过程被Stream的方法隐藏了。

2）提供了声明式的处理函数，比如filter，它封装了数据过滤的功能，而传统代码是命令式的，需要一步步的操作指令。

3）流畅式接口，方法调用链接在一起，清晰易读。



<br/>

<font color=red>调用中间操作（如：`filter() 或 map()`）不会执行任何实际的操作，它们只是在构建操作的流水线，调用collect才会触发实际的遍历执行，在一次遍历中完成过滤、转换以及收集结果的任务。</font> 

像filter和map这种不实际触发执行、用于构建流水线、返回Stream的操作称为 **中间操作（intermediate operation）**，

而像collect这种触发实际执行、返回具体结果的操作称为 **终端操作（terminal operation）**、也可称为终止操作。



<br/>



## 2. 中间操作

### 1) filter/map

filter 方法用于通过设置的条件过滤出元素、即只有符合传入 “规则” 的元素才能通过筛选

map 方法简单说就是对给个对象都执行传给 map 作为的参数的那个方法

```java
// 返回90分以上的学生名称列表
List<String> above90Names = students.stream()
    .filter(t->t.getScore()>90)          // 1）过滤：得到90分以上的学生列表
    .map(Student::getName)               // 2）转换：将学生列表转换为名称列表
    .collect(Collectors.toList());
```

这种组合利用基本函数、声明式实现集合数据处理功能的编程风格，就是 **函数式** 数据处理。

代码更为直观易读了，但你可能会担心它的性能有问题：

filter()和map()都需要对流中的每个元素操作一次，一起使用会不会就需要遍历两次呢？（再次强调）

答案是否定的，只需要一次。实际上，调用filter()和map()都不会执行任何实际的操作，它们只是在构建操作的流水线，调用collect才会触发实际的遍历执行，在一次遍历中完成过滤、转换以及收集结果的任务。



<br/>



### 2) distinct

distinct过滤重复的元素，只留下不重复的元素，返回一个新的Stream，是否重复是根据hashcode和equals方法来比较的，distinct可以与其他函数（如filter、map）结合使用。

> 比如，返回字符串列表中长度小于3的字符串、转换为小写、只保留唯一的，代码可以为：

```java
List<String> list = Arrays.asList(new String[]{"abc", "def", "hello", "Abc"});

List<String> retList = list.stream()
    .filter(s->s.length()<=3).map(String::toLowerCase).distinct()
    .collect(Collectors.toList());

```

distinct与filter和map等是不同的。filter和map都是无状态的，对于流中的每一个元素，处理都是独立的，处理后即交给流水线中的下一个操作；

**distinct不同，它是有状态的，在处理过程中，它需要在内部记录之前出现过的元素，如果已经出现过，即重复元素，它就会过滤掉，不传递给流水线中的下一个操作**。

对于顺序流，内部实现时，distinct操作会使用HashSet记录出现过的元素，如果流是有顺序的，需要保留顺序，会使用LinkedHashSet。



<br/>



### 3) sorted

```java
// sorted方法的两种使用方式
Stream<T> sorted()
Stream<T> sorted(Comparator<? super T> comparator)
```

它们都对流中的元素排序，都返回一个排序后的Stream。

第一个方法假定元素实现了Comparable接口，第二个方法接受一个自定义的Comparator。



```java
// 比如，过滤得到90分以上的学生，然后按分数从高到低排序，分数一样的按名称排序，代码为：
List<Student> list = students.stream().filter( t -> t.getScore() > 90 )
    .sorted(Comparator.comparing(Student::getScore)
            .reversed()
            .thenComparing(Student::getName))
    .collect(Collectors.toList());
```



这里，使用了Comparator的comparing、reversed 和 thenComparing构建了Comparator。

与distinct一样，sorted也是一个有状态的中间操作，在处理过程中，需要在内部记录出现过的元素。

其不同是，每碰到流中的一个元素，distinct都能立即做出处理，要么过滤，要么马上传递给下一个操作；

**sorted需要先排序，为了排序，它需要先在内部数组中保存碰到的每一个元素，到流结尾时再对数组排序，然后再将排序后的元素逐个传递给流水线中的下一个操作**。





<br/>



### 4) skip/limit

```java
// skip跳过流中的n个元素，如果流中元素不足n个，返回一个空流
Stream<T> skip(long n)
    
// limit限制流的长度为maxSize
Stream<T> limit(long maxSize)
```



```java
// 例：将学生列表按照分数排序，返回第3名到第5名，代码为：
List<Student> list = students.stream()
    .sorted(Comparator.comparing(Student::getScore).reversed())
    .skip(2).limit(3)
    .collect(Collectors.toList());
```

skip和limit都是有状态的中间操作。对前n个元素，skip的操作就是过滤，对后面的元素，skip就是传递给流水线中的下一个操作。

limit的一个特点是：它不需要处理流中的所有元素，只要处理的元素个数达到maxSize，后面的元素就不需要处理了，这种可以提前结束的操作称为短路操作。

<br/>

skip和limit只能根据元素数目进行操作，Java 9增加了两个新方法，相当于更为通用的skip和limit：

```java
//通用的skip，在Predicate返回为true的情况下一直进行skip操作，直到某次返回false
default Stream<T> dropWhile(Predicate<? super T> predicate)
    
//通用的limit，在Predicate返回为true的情况下一直接受，直到某次返回false
default Stream<T> takeWhile(Predicate<? super T> predicate)
```





<br/>

### 5) peek

```java
// peek的定义为：
Stream<T> peek(Consumer<? super T> action)
```

它返回的流与之前的流是一样的，没有变化，但它提供了一个Consumer，会将流中的每一个元素传给该Consumer。这个方法的主要目的是支持调试，可以使用该方法观察在流水线中流转的元素，比如：

```java
List<String> above90Names = students.stream().filter(t->t.getScore()>90)
    .peek(System.out::println)
    .map(Student::getName)
    .collect(Collectors.toList());
```



<br/>

### 6) mapTo

为避免装箱/拆箱，提高性能，Stream还有如下返回 **基本类型特定流** 的方法：

```java
DoubleStream mapToDouble(ToDoubleFunction<? super T> mapper)
IntStream mapToInt(ToIntFunction<? super T> mapper)
LongStream mapToLong(ToLongFunction<? super T> mapper)
```

DoubleStream/IntStream/LongStream是基本类型特定的流，有一些专门的更为高效的方法。

比如，求学生列表的分数总和，代码为：

```java
double sum = students.stream().mapToDouble(Student::getScore).sum();
```





<br/>



### 7) flatMap

flatMap的定义为：

```java
<R> Stream<R> flatMap(Function<? super T, ? extends Stream<? extends R>> mapper)
```

它接受一个函数mapper，对流中的每一个元素，mapper会将该元素转换为一个流Stream，然后把新生成流的每一个元素传递给下一个操作。比如：

```java
List<String> lines = Arrays.asList(new String[]{"hello abc", "java  stream"});
List<String> words = lines.stream()
    .flatMap(line -> Arrays.stream(line.split("\\s+")))
    .collect(Collectors.toList());
System.out.println(words);
```

这里的mapper将一行字符串按空白符分隔为了一个单词流，Arrays.stream可以将一个数组转换为一个流，输出为：

```java
[hello, abc, java, stream]
```





<br/>



## 3. 终端操作

中间操作不触发实际的执行，返回值是Stream，而终端操作触发执行，返回一个具体的值，除了collect, Stream API的终端操作还有max、min、count、allMatch、anyMatch、noneMatch、findFirst、findAny、forEach、toArray、reduce等

<br/>

### 1) max/min

```java
Optional<T> max(Comparator<? super T> comparator)
Optional<T> min(Comparator<? super T> comparator)
```



```java
// max使用示例： （这里，假定students不为空）
Student student = students.stream()
    .max(Comparator.comparing(Student::getScore).reversed())
    .get();

```



注意 `max/min`  返回流中的最大值/最小值，它们的返回值类型是 `Optional<T>` ，而不是 `T`。

`java.util.Optional` 是Java 8引入的一个新类，它是一个泛型容器类，内部只有一个类型为T的单一变量value，可能为null，也可能不为null。

<br/>

**Optional有什么用呢**？

<span style="color: red">它用于准确地传递程序的语义，它清楚地表明，其代表的值可能为null，程序员应该进行适当的处理</span>。

Optional定义了一些方法，比如：

```java
public boolean isPresent()                         //value不为null时返回true
public T get()                                     //返回实际的值，如果为null，抛出异常NoSuchElementException   
public T orElse(T other)                           //如果value不为null，返回value，否则返回other
public static<T> Optional<T> empty()               //构建一个空的Optional, value为null
public static <T> Optional<T> of(T value)          //构建一个非空的Optional, 参数value不能为null  
public static <T> Optional<T> ofNullable(T value)  //构建一个Optional，参数value可以为null，也可以不为null
```



<br/>



### 2) count

count很简单，就是返回流中元素的个数。

比如，统计大于90分的学生个数，代码为：

```java
long above90Count = students.stream()
    .filter(t->t.getScore()>90)
    .count();
```





<br/>

### 3) Match

`allMatch/anyMatch/noneMatch` 这几个函数都接受一个谓词Predicate，返回一个boolean值，用于判定流中的元素是否满足一定的条件。它们的区别是：

❑ allMatch：只有在流中所有元素都满足条件的情况下才返回true。

❑ anyMatch：只要流中有一个元素满足条件就返回true。

❑ noneMatch：只有流中所有元素都不满足条件才返回true。如果流为空，那么这几个函数的返回值都是true。

<br/>

比如，判断是不是所有学生都及格了（不小于60分），代码可以为：

```java
boolean allPass = students.stream().allMatch(t->t.getScore()>=60);
```

这几个操作都是短路操作，不一定需要处理所有元素就能得出结果，比如，对于all-Match，只要有一个元素不满足条件，就能返回false。



<br/>



### 4) find

```java
Optional<T> findFirst()  // findFirst返回第一个元素
Optional<T> findAny()    // findAny返回任一元素
```

它们的返回类型都是Optional，如果流为空，返回Optional.empty()

随便找一个不及格的学生，代码可以为：

```java
Optional<Student> student = students.stream()
    .filter(t->t.getScore()<60)
    .findAny();

if(student.isPresent()){
    //处理不及格的学生
}
```



<br/>



### 5) forEach

```java
void forEach(Consumer<? super T> action)
void forEachOrdered(Consumer<? super T> action)
```

它们都接受一个Consumer，对流中的每一个元素，传递元素给Consumer。

区别在于：在并行流中，forEach不保证处理的顺序，而forEachOrdered会保证按照流中元素的出现顺序进行处理。



比如，逐行打印大于90分的学生，代码可以为：

```java
students.stream()
    .filter(t->t.getScore()>90)
    .forEach(System.out::println);
```





<br/>



### 6) toArray

toArray将流转换为数组，有两个方法：

```java
Object[] toArray()
<A> A[] toArray(IntFunction<A[]> generator)
```

不带参数的toArray返回的数组类型为Object[]，这通常不是期望的结果，如果希望得到正确类型的数组，需要传递一个类型为IntFunction的generator。IntFunction的定义为：

```java
public interface IntFunction<R> {
    R apply(int value);
}
```

generator接受的参数是流的元素个数，它应该返回对应大小的正确类型的数组。



比如，获取90分以上的学生数组，代码可以为：

```java
Student[] above90Arr = students.stream()
    .filter(t->t.getScore()>90)
    .toArray(Student[]::new);
```

Student[]::new就是一个类型为IntFunction<Student[]>的generator。



<br/>



### 7) reduce

reduce代表归约或者叫折叠，它是max/min/count的更为通用的函数，将流中的元素归约为一个值。有三个reduce函数：

```java
Optional<T> reduce(BinaryOperator<T> accumulator);
T reduce(T identity, BinaryOperator<T> accumulator);
<U> U reduce(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner);
```

第一个和第二个reduce函数的返回类型只能是流中元素的类型，而第三个reduce函数更为通用，它的归约类型可以自定义，另外，它多了一个combiner参数。combiner用在并行流中，用于合并子线程的结果。

<br/>

例，使用reduce函数求分数最高的学生，代码可以为：

```java
Student topStudent = students.stream()
    .reduce((accu, t) -> {
        if(accu.getScore() >= t.getScore()) {
            return accu;
        } else {
            return t;
        }
	})
    .get();
```



<br/>



## 4. collect

```java
<R, A> R collect(Collector<? super T, A, R> collector)
```

collect方法接受一个收集器collector接口作为参数，类型是Collector



### 1) Collector

Collector接口的定义：

```java
public interface Collector<T, A, R> {
    Supplier<A> supplier();
    BiConsumer<A, T> accumulator();
    BinaryOperator<A> combiner();
    Function<A, R> finisher();
    Set<Characteristics> characteristics();
}
```

在顺序流中，collect方法与这些接口方法的交互大概是这样的：

```java
//首先调用工厂方法supplier创建一个存放处理状态的容器container，类型为A
A container = collector.supplier().get();

//对流中的每一个元素t，调用累加器accumulator，参数为累计状态container和当前元素t
for(T t : data)
    collector.accumulator().accept(container, t);

//最后调用finisher对累计状态container进行可能的调整，类型转换(A转换为R)，返回结果
return collector.finisher().apply(container);
```

combiner只在并行流中有用，用于合并部分结果。

characteristics用于标示收集器的特征，Collector接口的调用者可以利用这些特征进行一些优化。

Characteristics是一个枚举，有三个值：CONCURRENT、UNORDERED和IDENTITY_FINISH

<br/>

Collectors.toList()具体是什么呢？看下代码：

```java
public static <T> Collector<T, ? , List<T>> toList() {
    return new CollectorImpl<>( 
        (Supplier<List<T>>) ArrayList::new, 
        List::add,
        (left, right) -> { left.addAll(right); return left; }, 
        CH_ID
    );
}
```

它的实现类是CollectorImpl，这是Collectors内部的一个私有类，实现很简单，主要就是定义了两个构造方法，接受函数式参数并赋值给内部变量。

对toList来说：

1）supplier的实现是ArrayList::new，也就是创建一个ArrayList作为容器。

2）accumulator的实现是List::add，也就是将碰到的每一个元素加到列表中。

3）第三个参数是combiner，表示合并结果。

4）第四个参数CH_ID是一个静态变量，只有一个特征IDENTITY_FINISH，表示finisher没有什么事情可以做，就是把累计状态container直接返回。

<br/>

也就是说，collect(Collectors.toList())背后的伪代码如下所示：

```java
List<T> container = new ArrayList<>();
for(T t : data)
    container.add(t);
return container;
```



<br/>



### 2) 容器收集器

与toList类似的容器收集器还有toSet、toCollection、toMap等



1. `toSet` ：toSet的使用与toList类似，只是它可以排重。toList背后的容器是ArrayList, toSet背后的容器是HashSet，

   其代码为：

   ```java
   public static <T> Collector<T, ? , Set<T>> toSet() {
       return new CollectorImpl<>(
           (Supplier<Set<T>>) HashSet::new, 
           Set::add,
           (left, right) ->{ left.addAll(right); return left; },
           CH_UNORDERED_ID
       );
   }
   ```

   `CH_UNORDERED_ID` 是一个静态变量，它的特征有两个：

   一个是IDENTITY_FINISH，表示返回结果即为Supplier创建的HashSet；

   另一个是UNORDERED，表示收集器不会保留顺序，这也容易理解，因为背后容器是HashSet。

​		<br/>

2. `toCollection`： toCollection是一个通用的容器收集器，可以用于任何Collection接口的实现类，它接受一个工厂方法Supplier作为参数，具体代码为：

   ```java
   public static <T, C extends Collection<T>> Collector<T, ? , C> toCollection(Supplier<C>collectionFactory) {
       return new CollectorImpl<>(
           collectionFactory, 
           Collection<T>::add,
           (r1, r2) -> { r1.addAll(r2); return r1; },
           CH_ID);
   }
   ```

   比如，如果希望排重但又希望保留出现的顺序，可以使用LinkedHashSet,Collector可以这么创建：

   ```java
   Collectors.toCollection(LinkedHashSet::new)
   ```

​		<br/>

3. `toMap`： toMap将元素流转换为一个Map，Map有键和值两部分，toMap至少需要两个函数参数，一个将元素转换为键，另一个将元素转换为值，其基本定义为：

   ```java
   public static <T, K, U> Collector<T, ? , Map<K, U>> toMap(
       Function<? super T, ? extends K> keyMapper,
       Function<? super T, ? extends U> valueMapper)
   ```

   返回结果为Map<K, U>, keyMapper将元素转换为键，valueMapper将元素转换为值。

   比如，将学生流转换为学生名称和分数的Map，代码可以为：

   ```java
   Map<String, Double> nameScoreMap = students.stream().collect(
       Collectors.toMap(Student::getName, Student::getScore)
   );
   ```

   这里，Student::getName是keyMapper, Student::getScore是valueMapper。

   

   <br/>

   实践中，经常需要将一个对象列表按主键转换为一个Map，以便以后按照主键进行快速查找，

   比如，假定Student的主键是id，希望转换学生流为学生id和学生对象的Map，代码可以为：

   ```java
   Map<String, Student> byIdMap = students.stream().collect(
       Collectors.toMap(Student::getId, t -> t)
   );
   ```

   t->t是valueMapper，表示值就是元素本身。这个函数用得比较多，接口Function定义了一个静态函数identity表示它。

   也就是说，上面的代码可以替换为：

   ```java
   Map<String, Student> byIdMap = students.stream().collect(
   	Collectors.toMap(Student::getId, Function.identity())
   );
   ```

   注意：上面的toMap假定元素的键不能重复，如果有重复的，会抛出异常

   

   <br/>

   ```java
   // 抛出异常的例子
   Map<String, Integer> strLenMap = Stream.of("abc", "hello", "abc").collect(
       Collectors.toMap(Function.identity(), t->t.length())
   );
   ```

   希望得到字符串与其长度的Map，但由于包含重复字符串"abc"，程序会抛出异常。这种情况下，我们希望的是程序忽略后面重复出现的元素，这时，可以使用另一个toMap函数：

   ```java
   Map<String, Integer> strLenMap = Stream.of("abc", "hello", "abc").collect(
       Collectors.toMap(Function.identity(), t->t.length(), (oldValue, value)->value)
   );
   ```

   相比前面的toMap，它接受一个额外的参数mergeFunction，它用于处理冲突，在收集一个新元素时，如果新元素的键已经存在了，系统会将新元素的值与键对应的旧值一起传递给mergeFunction得到一个值，然后用这个值给键赋值

   



<br/>



### 3) 字符串收集器

除了将元素流收集到容器中，另一个常见的操作是收集为一个字符串。

比如，获取所有的学生名称，用逗号连接起来，传统上代码看上去像这样：

```java
StringBuilder sb = new StringBuilder();
for(Student t : students){
    if(sb.length()>0){
        sb.append(", ");
    }
    sb.append(t.getName());
}
return sb.toString();
```

针对这种常见的需求，Collectors提供了joining收集器（joining的内部利用了StringBuilder），比如：

```java
public static Collector<CharSequence, ? , String> joining()
public static Collector<CharSequence, ? , String> joining(
    CharSequence delimiter, CharSequence prefix, CharSequence suffix)
```

第一个就是简单地把元素连接起来，第二个支持一个分隔符，还可以给整个结果字符串加前缀和后缀，比如：

```java
String result = Stream.of("abc", "java", "hello").collect(Collectors.joining(", ", "[", "]"));
System.out.println(result);

// 输出：[abc, java, hello]
```



<br/>



### 4) Stream分组

分组类似于数据库查询语言SQL中的group by语句，它将元素流中的每个元素分到一个组，可以针对分组再进行处理和收集。

```java
Map<String, List<Student>> groups = students.stream()
    .collect(Collectors.groupingBy(Student::getGrade));
System.out.println(groups);
```

学生会分为两组：第一组键为"1"，分组学生包括"zhangsan""wangwu"和"sunqi"；第二组键为"2"，分组学生包括"lisi" "zhaoliu"。

这段代码基本等同于如下代码：

```java
Map<String, List<Student>> groups = new HashMap<>();

for(Student t : students) {
    String key = t.getGrade();
    List<Student> container = groups.get(key);
    if(container == null) {
        container = new ArrayList<>();
        groups.put(key, container);
    }
    container.add(t);
}
```



<br/>

**分组计数、找最大/最小元素**：

```java
// 统计每个年级的学生个数
Map<String, Long> gradeCountMap = students.stream().collect(
    groupingBy(Student::getGrade, counting())
);
```



```java
// 统计一个单词流中每个单词的个数，按出现顺序排序
Map<String, Long> wordCountMap = Stream.of("hello", "world", "abc", "hello").collect(
    groupingBy(Function.identity(), LinkedHashMap::new, counting())
);
```



```java
// 获取每个年级分数最高的一个学生
Map<String, Optional<Student>> topStudentMap = students.stream().collect(
    groupingBy(Student::getGrade, maxBy(Comparator.comparing(Student::getScore)))
);
```

需要注意的是，这个分组收集结果是 `Optional<Student>`，而不是Student，这是因为maxBy处理的流可能是空流。

为了直接得到Student，可以使用Collectors的另一个收集器 `collectingAndThen`，在得到`Optional<Student>`后调用Optional的get方法，如下所示：

```java
Map<String, Student> topStudentMap = students.stream().collect(
    groupingBy( 
        Student::getGrade, 
        collectingAndThen( maxBy(Comparator.comparing(Student::getScore)), Optional::get)
    )
);
```



<br/>



**分组数值统计**：

除了基本的分组计数，还经常需要进行一些分组数值统计，比如求学生分数的和、平均分、最高分、最低分等、针对int、long和double类型，Collectors提供了专门的收集器，比如：

```java
//求平均值，int和long也有类似方法
public static <T> Collector<T, ? , Double> averagingDouble(ToDoubleFunction<? super T> mapper)
    
//求和，long和double也有类似方法
public static <T> Collector<T, ? , Integer> summingInt(ToIntFunction<? super T> mapper)
    
//求多种汇总信息，int和double也有类似方法
//LongSummaryStatistics包括个数、最大值、最小值、和、平均值等多种信息
public static <T> Collector<T, ? , LongSummaryStatistics> summarizingLong(ToLongFunction<? super T> mapper)
```



```java
// 例：按年级统计学生分数信息
Map<String, DoubleSummaryStatistics> gradeScoreStat = students.stream().collect(
    groupingBy(Student::getGrade, summarizingDouble(Student::getScore))
);
```

输出（包含个数、最大值、最小值、和、平均值等多种信息）：

```java
{1=DoubleSummaryStatistics{count=3, sum=200.000000, min=50.000000, average=66.666667, max=91.000000}, 2=DoubleSummaryStatistics{count=2, sum=167.000000, min=78.000000, average=83.500000, max=89.000000}}

```



<br/>



**分组内的map**：

对于每个分组内的元素，我们感兴趣的可能不是元素本身，而是它的某部分信息。在Stream API中，Stream有map方法，可以将元素进行转换，Collectors也为分组元素提供了函数mapping.

交给下游收集器downstream的不再是元素本身，而是应用转换函数mapper之后的结果。

```java
// 对学生按年级分组，得到学生名称列表
Map<String, List<String>> gradeNameMap = students.stream().collect(
    groupingBy(Student::getGrade, mapping(Student::getName, toList()))
);
System.out.println(gradeNameMap);
```

```java
控制台输出结果：
{1=[zhangsan, wangwu, sunqi], 2=[lisi, zhaoliu]}
```

<br/>

```java
// 将学生按年级分组，分组内的学生按照分数由高到低进行排序
Map<String, List<Student>> gradeStudentMap = students.stream().collect(
    groupingBy(
        Student::getGrade, 
        collectingAndSort(toList(),Comparator.comparing(Student::getScore).reversed())
    )
);
```

<br/>

```java
// 将学生按年级分组，分组后，每个分组只保留前两名的学生
Map<String, List<Student>> gradeStudentMap = students.stream()
    .sorted(Comparator.comparing(Student::getScore).reversed())
    .collect(
    	groupingBy(Student::getGrade, collectingAndSkipLimit(toList(), 0, 2)
    )
);
```



<br/>



## 5. 函数式思维

函数式数据处理思维：使用Stream API处理数据集合，与直接使用容器类API处理数据的思路是完全不一样的。

<font color=red size=5>流定义了很多数据处理的基本函数，对于一个具体的数据处理问题，解决的主要思路就是组合利用这些基本函数，以声明式的方式简洁地实现期望的功能，这种函数式数据处理的思维，相比直接利用容器类API的命令式思维，思考的层次更高</font> 

<br/>

Stream API的这种思路也不是新发明，它与数据库查询语言SQL是很像的，都是声明式地操作集合数据，很多函数都能在SQL中找到对应，比如filter对应SQL的where, sorted对应order by等。SQL一般都支持分组（group by）功能，当然StreamAPI也支持。



Stream API也与各种基于Unix系统的管道命令类似。Unix有很多命令，大部分命令只是专注于完成一件事情，但可以通过管道的方式将多个命令链接起来，完成一些复杂的功能



