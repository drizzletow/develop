# 一 流程控制

1996 年，计算机科学家 Bohm 和 Jacopini 证明了：任何简单或复杂的算法都可以由**顺序结构、分支结构和循环结构**这三种基本 结构组合而成。它们的共同点是都包含一个入口和一个出口，它们的每个代码都有机会被执行，不会出现死循环。

- 顺序结构： 顺序结构是一种基本的控制结构，它按照语句出现的顺序执行操作 
- 分支结构 ：分支结构又被称为选择结构，根据条件成立与否来执行操作
- 循环结构： 循环结构是一种重复结构，如果条件成立，它会重复执行某一循环体，直到出现不满足的条件为止



## 1. if 条件语句

The `if-then` statement is the most basic of all the control flow statements. 

It tells your program to execute a certain section of code *only if* a particular test evaluates to `true`.

```java
int testscore = 76;
char grade;

if (testscore >= 90) {
	grade = 'A';
} else if (testscore >= 80) {
	grade = 'B';
} else if (testscore >= 70) {
	grade = 'C';
} else if (testscore >= 60) {
	grade = 'D';
} else {
	grade = 'F';
}
```



## 2. switch 语句

the `switch` statement can have a number of possible execution paths. 

A `switch` works with the `byte`, `short`, `char`, and `int` primitive data types. 

It also works with *enumerated types* , the [`String`](https://docs.oracle.com/javase/8/docs/api/java/lang/String.html) class, and a few special classes that wrap certain primitive types:

[`Byte`](https://docs.oracle.com/javase/8/docs/api/java/lang/Byte.html), [`Short`](https://docs.oracle.com/javase/8/docs/api/java/lang/Short.html), [`Character`](https://docs.oracle.com/javase/8/docs/api/java/lang/Character.html) and [`Integer`](https://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html)

```java
int month = 8;
String season;
switch (month) {
    case 12: case 1: case 2:  
        season = "Winter";
        break;
    case 3: case 4: case 5:  
        season = "Spring";
        break;
    case 6: case 7: case 8:  
        season = "Summer";
        break;
    case 9: case 10: case 11:  
        season = "Autumn";
        break;
    default: 
        season = "Invalid month";
        break;
}
System.out.println(month + "月：" + season);
```



## 3. while 循环

The `while` statement continually executes a block of statements while a particular condition is `true`. 

Its syntax can be expressed as:

```java
while (expression) {
     statement(s)
}
```



## 4. do-while 循环

`do-while` evaluates its expression at the bottom of the loop instead of the top.

Therefore, the statements within the `do` block are always executed at least once

```java
do {
     statement(s)
} while (expression);
```



## 5. for 循环

The `for` statement provides a compact way to `iterate over`(遍历) a range of values. Programmers often refer to it as the "for loop" because of the way in which it repeatedly loops until a particular condition is satisfied

```java
for (initialization; termination; increment) {
    statement(s)
}
```

- The *initialization* expression initializes the loop; it's executed once, as the loop begins.
- When the *termination* expression evaluates to `false`, the loop terminates.
- The *increment* expression is invoked after each iteration through the loop; it is perfectly acceptable for this expression to increment *or* decrement a value.

```java
for(int i = 1; i < 11; i++){
    System.out.println("Count is: " + i);
}
```



## 6. break和continue

- break的作用是跳出当前循环块（for、while、do while）或程序块（switch）
- continue用于结束循环体中其后语句的执行，并跳回循环程序块的开头执行下一次循环
- break和continue可以配合语句标签使用

```java
label:
for (int i = 1; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        if (j == 9) break label;
    }
}
```



# 二 数组

