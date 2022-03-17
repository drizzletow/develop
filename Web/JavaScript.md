# 一 JavaScript基础

HTML 中的脚本必须位于 \<script> 与 \</script> 标签之间、脚本可被放置在 HTML 页面的 \<body> 和 \<head> 部分中

## 1. 变量和常量
**1. 变量**
&emsp; JavaScript变量不需要声明数据类型，其类型在赋值的那一刻被初始化，变量名长度不受限制，区分大小写
&emsp; JavaScript中支持同时为多个变量赋值：
```javascript
var x=5;
var y=6;
var z=x+y;
var lastname="Doe", age=30, job="carpenter";   //一次声明多个变量
```

<br/>

**2. 常量** 

- 关键字为  const  (es6)
```javascript
const PI = 3.14;  //不可以修改值     
```

<br/>

## 2. 输入和输出

- **输入 ：**  promp( ) 弹出输入框
```javascript
<script>
   var str = window.prompt("请输入您的姓名：");
   alert(str);
</script>
```

<br/>

- **输出：** JavaScript 可以通过不同的方式来输出数据：

> 使用 window.alert() 弹出警告框。
> 使用 document.write() 方法将内容写到 HTML 文档中。
> 使用 innerHTML 写入到 HTML 元素。
> 使用 console.log() 写入到浏览器的控制台。

```javascript
window.alert("错误提示");

<p id="demo">我的第一个段落</p>
<script>
document.getElementById("demo").innerHTML = "段落已修改。";  //网页显示内容为：段落已修改。
</script>

<button onclick="myFunction()">点我</button>
<script>
function myFunction() {
    document.write(Date());  //显示时间
}
</script>

/*
如果您的浏览器支持调试，你可以使用 console.log() 方法在浏览器中显示 JavaScript 值。
浏览器中使用 F12 来启用调试模式， 在调试窗口中点击 "Console" 菜单。 */
console.log(6);
```

<br/>




## 3. 常用数据类型
|      类型       |                                            说明                                            |
| --------------- | ------------------------------------------------------------------------------------------ |
| 值类型(基本类型) | 包含：数字(Number)、布尔(Boolean)、对空（Null）、未定义（Undefined）、Symbol、字符串（String） |
| 引用数据类型     | 包含：对象(Object)、数组(Array)、函数(Function)                                              |
```javascript
var x;               // x 为 undefined
var x = 5;           // 现在 x 为数字
var x = "John";      // 现在 x 为字符串（JavaScript 拥有动态类型。这意味着相同的变量可用作不同的类型）

//当声明新变量时，可以使用关键词 "new" 来声明其类型：
var carname=new String;
var x= new Number;
var y= new Boolean;
var cars= new Array;
var person= new Object;
```

<br/>

**基本数据类型**： 

**（1）数字(Number)**
- JavaScript 只有一种数字类型。数字可以带小数点，也可以不带。 极大或极小的数字可以通过科学（指数）计数法来书写：
- 所有 JavaScript 数字均为 64 位，JavaScript 不是类型语言。与许多其他编程语言不同，JavaScript 不定义不同类型的数字，比如整数、短、长、浮点等等。
- 如果前缀为 0，则 JavaScript 会把数值常量解释为八进制数，如果前缀为 0 和 "x"，则解释为十六进制数。
默认情况下，JavaScript 数字为十进制显示。但是你可以使用 toString() 方法 输出16进制、8进制、2进制。
- 无穷大（Infinity）：当数字运算结果超过了JavaScript所能表示的数字上限（溢出），结果为一个特殊的无穷大（infinity）值，在JavaScript中以Infinity表示。
- NaN - 非数字值：NaN 属性是代表非数字值的特殊值。该属性用于指示某个值不是数字。可以把 Number 对象设置为该值，来指示其不是数字值。
你可以使用 isNaN() 全局函数来判断一个值是否是 NaN 值。除以0是无穷大，无穷大是一个数字:
- 数字可以是数字或者对象：数字可以私有数据进行初始化，就像 x = 123; JavaScript 数字对象初始化数据， var y = new Number(123);

```javascript
var x1=34.00;      //使用小数点来写
var x2=34;         //不使用小数点来写
var y=123e5;       // 12300000
var z=123e-5;      // 0.00123

var y = 0377;
var z = 0xFF;
var myNumber=128;
myNumber.toString(16);   // 返回 80
myNumber.toString(8);    // 返回 200
myNumber.toString(2);    // 返回 10000000

var x = 1000 / "Apple";
isNaN(x); // 返回 true
var y = 100 / "1000";
isNaN(y); // 返回 false
var x = 1000 / 0;
isNaN(x); // 返回 false

var x = 123;
var y = new Number(123);
typeof(x) // 返回 Number
typeof(y) // 返回 Object
(x === y) // 为 false，因为 x 是一个数字，y 是一个对象

Number.parseFloat()	   //将字符串转换成浮点数，和全局方法 parseFloat() 作用一致。
Number.parseInt()	   //将字符串转换成整型数字，和全局方法 parseInt() 作用一致。
Number.isFinite()	   //判断传递的参数是否为有限数字。
Number.isInteger()	   //判断传递的参数是否为整数。
Number.isNaN()	       //判断传递的参数是否为 isNaN()。
Number.isSafeInteger()	//判断传递的参数是否为安全整数。

var num = 123
num.toExponential()	 //返回一个数字的指数形式的字符串，如：1.23e+2
toFixed()	         //返回指定小数位数的表示形式。
b=a.toFixed(2);      // b="123.00" 返回指定小数位数的表示形式。
var a=123;
b=a.toPrecision(2); // b="1.2e+2"  返回一个指定精度的数字。
```

<br/>

**（2）布尔(Boolean)**

- 布尔（逻辑）只能有两个值：true 或 false。布尔常用在条件测试中。
- 如果布尔对象无初始值或者其值为: 0、-0、null、""、false、undefined、NaN 那么对象的值为 false。否则，其值为 true（即使当变量值为字符串 "false" 时）！

```javascript
var x=true;
var y=false;
```

<br/>

**（3）对空（Null）、未定义（Undefined）、Symbol**

- Undefined 这个值表示变量不含有值。可以通过将变量的值设置为 null 来清空变量。

<br/>



## 4. String字符串

- 字符串可以是插入到引号中的任何字符。你可以使用单引号或双引号。
- 你可以使用索引位置来访问字符串中的每个字符：字符串的索引从 0 开始，这意味着第一个字符索引值为 [0],第二个为 [1], 以此类推。
- 可以使用内置属性 length 来计算字符串的长度：
- 字符串可以是对象，通常， JavaScript 字符串是原始值，可以使用字符创建： var firstName = "John"
但我们也可以使用 new 关键字将字符串定义为一个对象： var firstName = new String("John")
但不要创建 String 对象。它会拖慢执行速度，并可能产生其他副作用：

```javascript
var carname = "Volvo XC60";
var carname = 'Volvo XC60';
var character = carname[7];

var txt = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
var sln = txt.length;  //使用内置属性 length 来计算字符串的长度：

var x = "John";
var y = new String("John");
typeof x // 返回 String
typeof y // 返回 Object
(x === y) // 结果为 false，因为 x 是字符串，y 是对象
```
<br/>

**字符串方法:**

```javascript
charAt()	        //返回指定索引位置的字符
charCodeAt()	    //返回指定索引位置字符的 Unicode 值
concat()	        //连接两个或多个字符串，返回连接后的字符串
fromCharCode()	    //将 Unicode 转换为字符串
indexOf()	        //返回字符串中检索指定字符第一次出现的位置
lastIndexOf()	    //返回字符串中检索指定字符最后一次出现的位置
localeCompare()   	//用本地特定的顺序来比较两个字符串
match()	            //找到一个或多个正则表达式的匹配
replace()	        //替换与正则表达式匹配的子串
search()	        //检索与正则表达式相匹配的值
slice()	            //提取字符串的片断，并在新的字符串中返回被提取的部分
split()	            //把字符串分割为子字符串数组
substr()	        //从起始索引号提取字符串中指定数目的字符
substring()	        //提取字符串中两个指定的索引号之间的字符
toLocaleLowerCase()	//根据主机的语言环境把字符串转换为小写，只有几种语言（如土耳其语）具有地方特有的大小写映射
toLocaleUpperCase()	//根据主机的语言环境把字符串转换为大写，只有几种语言（如土耳其语）具有地方特有的大小写映射
toLowerCase()	    //把字符串转换为小写
toString()	        //返回字符串对象值
toUpperCase()	    //把字符串转换为大写
trim()	            //移除字符串首尾空白
valueOf()	        //返回某个字符串对象的原始值
```

<br/>



## 5. 常用运算符

1. 算术运算符
-  `+       -       *      /(常规除法)         %(取模/求余)   ++（自增）  --（自减） `


2. 关系运算符
-  `>       <       >=       <=        ==        !=  `（=”为赋值运算符，“==”为等于运算符）
- `===`	绝对等于（值和类型均相等）     `!==`	 不绝对等于（值和类型有一个不相等，或两个都不相等）

3. 逻辑运算符

|    运算符     | 描述 |         例子（x=6， y=3）          |
| :----------: | :--: | :-------------------------------: |
|      &&      | and  |     `(x < 10 && y > 1) `为 true     |
| &#124;&#124; |  or  | `(x==5 || y==5) `为 false |
|     !	      | not |          `!(x==y)` 为 true          |

4. 其他运算符
- **赋值运算符**： `  =  （+=   -=    *=   /=  //=  %= ）` 
- **字符连接运算符：** `+ ` 
- **条件运算符**：

```javascript
//如果变量 age 中的值小于 18，则向变量 voteable 赋值 "年龄太小"，否则赋值 "年龄已达到"。
voteable=(age<18)?"年龄太小":"年龄已达到"; 
```

<br/>



## 6. 条件与循环
1. 条件语句
```javascript
if (time<10)
{
    document.write("<b>早上好</b>");
}
else if (time>=10 && time<20)
{
    document.write("<b>今天好</b>");
}
else
{
    document.write("<b>晚上好!</b>");
}
```
**switch**
```javascript
var d=new Date().getDay();
switch (d)
{
    case 6:x="今天是星期六";
    break;
    case 0:x="今天是星期日";
    break;
    default:
    x="期待周末";
}
document.getElementById("demo").innerHTML=x;
```

<br/>



2. 循环语句

**while循环：**
```javascript
while (i<5)
{
    x=x + "The number is " + i + "<br>";
    i++;
}

do
{
    x=x + "The number is " + i + "<br>";
    i++;
}
while (i<5);
```
**for循环：**
```javascript
for (i=0;i<10;i++)
{
    if (i==3)
    {
        break;
    }
    x=x + "The number is " + i + "<br>";
}

for (i=0;i<=10;i++)
{
    if (i==3) continue;
    x=x + "The number is " + i + "<br>";
}
```

<br/>



## 7. 函数定义与参数

**（1）函数定义**
```javascript
//1. 函数声明：主代码流中的函数
function sum(a, b) {
  let result = a + b;
  return result;
}

//2. 函数表达式：表达式上下文中的函数
let sum = function(a, b) {
  let result = a + b;

  return result;
}

```
<br/>

**（2）参数传递与全局变量**

- JavaScript 参数通过值来传递：函数仅仅只是获取值。如果函数修改参数的值，不会修改参数的初始值（在函数外定义）。
在JavaScript中，可以引用对象的值。因此我们在函数内部修改对象的属性就会修改其初始的值。
- 变量声明时如果不使用 var 关键字，那么它就是一个全局变量，即便它在函数内定义。

```javascript
var  num1 = 22;    //全局变量 
function myFunction(a,b)
{
    num2 = 33;    //全局变量
    return a*b;
}
document.getElementById("demo").innerHTML=myFunction(4,3);
```

- 如果您把值赋给尚未声明的变量，该变量将被自动作为 window 的一个属性。
 非严格模式下给未声明变量赋值创建的全局变量，是全局对象的可配置属性，可以删除。

```javascript
var var1 = 1; // 不可配置全局属性
var2 = 2; // 没有使用 var 声明，可配置全局属性

console.log(this.var1); // 1
console.log(window.var1); // 1

delete var1; // false 无法删除
console.log(var1); //1

delete var2; 
console.log(delete var2); // true
console.log(var2); // 已经删除 报错变量未定义
```

- JavaScript 函数有个内置的对象 arguments 对象。argument 对象包含了函数调用的参数数组（所有参数）。

```javascript
x = findMax(1, 123, 500, 115, 44, 88);
//找到最大的一个参数的值
function findMax() {
    var i, max = arguments[0];
    
    if(arguments.length < 2) return max;
 
    for (i = 0; i < arguments.length; i++) {
        if (arguments[i] > max) {
            max = arguments[i];
        }
    }
    return max;
}
```
**函数内部的this指向：**
![](_v_images/20201113091606221_29752.png)

<br/>



## 8. JavaScript闭包

- 函数内部可以直接读取全局变量。但在函数外部自然无法读取函数内的局部变量。那么如何从外部读取局部变量？
- Javascript语言特有的"链式作用域"结构（chain scope）: 子对象会一级一级地向上寻找所有父对象的变量。所以，父对象的所有变量，对子对象都是可见的，反之则不成立。

```javascript
function f1(){
　　　　var n=999;
　　　　function f2(){
　　　　　　alert(n); // 999 函数f2就被包括在函数f1内部，这时f1内部的所有局部变量，对f2都是可见的。
　　　　}                 //但是反过来就不行，f2内部的局部变量，对f1就是不可见的。
　　}
```
https://www.cnblogs.com/chenglianjie/p/11914043.html







# 二 常用内置对象

## 1. 数组(Array)

```javascript
//1. 先创建数组对象再赋值、
var cars=new Array();
cars[0]="Saab";
cars[1]="Volvo";
cars[2]="BMW";

//2. 通过new 创建数组对象
var cars=new Array("Saab","Volvo","BMW");  

 //3. 定义数组
var cars=["Saab","Volvo","BMW"];          

// 检测是否为数组 (instanceof、Array.isArray() )
var arr = [1, 23];
var obj = {};
// instanceof 可以判断一个对象是否是某个构造函数的实例
console.log(arr instanceof Array); // true   
console.log(obj instanceof Array); // false

// Array.isArray()用于判断一个对象是否为数组，isArray() 是 HTML5 中提供的方法
console.log(Array.isArray(arr));   // true  
console.log(Array.isArray(obj));   // false
```

<br/>

**数组方法：**

```javascript
//toString() 把数组转换为数组值（逗号分隔）的字符串：
//如果需要原始值，则 JavaScript 会自动把数组转换为字符串。下面两个例子将产生相同的结果：
var fruits = ["Banana", "Orange", "Apple", "Mango"];
document.getElementById("demo").innerHTML = fruits.toString(); //结果：Banana,Orange,Apple,Mango
document.getElementById("demo").innerHTML = fruits;            //结果：Banana,Orange,Apple,Mango

//join() 方法也可将所有数组元素结合为一个字符串。它的行为类似 toString()，但是您还可以规定分隔符：
document.getElementById("demo").innerHTML = fruits.join(" * ");  //Banana * Orange * Apple * Mango

//pop() 方法从数组中删除最后一个元素：
var x = fruits.pop();      // x 的值是 "Mango"

//push() 方法（在数组结尾处）向数组添加一个新的元素，push() 方法返回新数组的长度：
fruits.push("Kiwi");            //  向 fruits 添加一个新元素
var x =  fruits.push("Kiwi");   //  x 的值是 5

//shift() 方法会删除首个数组元素，并把所有其他元素“位移”到更低的索引,返回被“位移出”的字符串：
fruits.shift();            // 从 fruits 删除第一个元素 "Banana"

//unshift() 方法（在开头）向数组添加新元素，并“反向位移”旧元素,返回新数组的长度。
fruits.unshift("Lemon");    // 向 fruits 添加新元素 "Lemon"

//length 属性提供了向数组追加新元素的简易方法：
fruits[fruits.length] = "Kiwi";          // 向 fruits 追加 "Kiwi"

//使用 delete 会在数组留下未定义的空洞。请使用 pop() 或 shift() 取而代之。
delete fruits[0];           // 把 fruits 中的首个元素改为 undefined

//splice() 方法可用于向数组添加新项：
// 第一个参数定义了应添加新元素的位置（拼接）。第二个参数定义应删除多少元素。其余参数为要添加的新元素。
var fruits = ["Banana", "Orange", "Apple", "Mango"];
fruits.splice(2, 2, "Lemon", "Kiwi");             //Banana,Orange,Lemon,Kiwi
fruits.splice(0, 1);                             // 删除 fruits 中的第一个元素

//concat() 方法通过合并（连接）现有数组来创建一个新数组：
//concat() 方法不会更改现有数组。它总是返回一个新数组。concat() 方法可以使用任意数量的数组参数：
var arr1 = ["Cecilie", "Lone"];
var arr2 = ["Emil", "Tobias", "Linus"];
var arr3 = ["Robin", "Morgan"];
var myChildren = arr1.concat(arr2, arr3);   // 将arr1、arr2 与 arr3 连接在一起
//concat() 方法也可以将值作为参数：
var myChildren = arr1.concat(["Emil", "Tobias", "Linus"]); 

//slice() 方法用数组的某个片段切出新数组。
//slice() 方法创建新数组。它不会从源数组中删除任何元素。
//slice() 可接受两个参数，比如 (1, 3)。该方法会从开始参数选取元素，直到结束参数（不包括）为止。
//如果结束参数被省略，则 slice() 会切出数组的剩余部分。
var fruits = ["Banana", "Orange", "Lemon", "Apple", "Mango"];
var citrus = fruits.slice(1, 3);  //Orange,Lemon
var citrus = fruits.slice(2);     //Lemon,Apple,Mango
```

<br/>

**数组排序：**

```javascript
//sort() 方法以字母顺序对数组进行排序：
var fruits = ["Banana", "Orange", "Apple", "Mango"];
fruits.sort();            // 对 fruits 中的元素进行排序.

//reverse() 方法反转数组中的元素。
fruits.reverse();         // 反转元素顺序

//默认地，sort() 函数按照字符串顺序对值进行排序。如果数字按照字符串来排序，则 "25" 大于 "100"，因为 "2" 大于 "1"。
//正因如此，sort() 方法在对数值排序时会产生不正确的结果。我们通过一个比值函数来修正此问题：
//当 sort() 函数比较两个值时，会将值发送到比较函数，并根据所返回的值（负、零或正值）对这些值进行排序。
var points = [40, 100, 1, 5, 25, 10];
points.sort(function(a, b){return a - b}); 
//使用相同的技巧对数组进行降序排序：
points.sort(function(a, b){return b - a}); 
points.sort(function(a, b){return 0.5 - Math.random()});  //以随机顺序排序数组

//JavaScript 不提供查找数组中最大或最小数组值的内建函数。不过，在对数组进行排序之后，您能够使用索引来获得最高或最低值。
//如果您仅仅需要找到最高或最低值，对整个数组进行排序是效率极低的方法。
//您可以使用 Math.max.apply 来查找数组中的最高值：
//Math.max.apply([1, 2, 3]) 等于 Math.max(1, 2, 3)。
function myArrayMax(arr) {
    return Math.max.apply(null, arr);
}
//最快的解决方法是使用“自制”方法。此函数遍历数组，用找到的最高值与每个值进行比较：
function myArrayMax(arr) {
    var len = arr.length
    var max = -Infinity;  //负无穷
    while (len--) {
        if (arr[len] > max) {
            max = arr[len];
        }
    }
    return max;
}


//排序对象数组:
//即使对象拥有不同数据类型的属性，sort() 方法仍可用于对数组进行排序。解决方法是通过比较函数来对比属性值：
var cars = [
{type:"Volvo", year:2016},
{type:"Saab", year:2001},
{type:"BMW", year:2010}];
cars.sort(function(a, b){return a.year - b.year});

//比较字符串属性会稍复杂：
cars.sort(function(a, b){
	  var x = a.type.toLowerCase();
	  var y = b.type.toLowerCase();
	  if (x < y) {return -1;}
	  if (x > y) {return 1;}
	  return 0;
});
```

<br/>

**数组迭代：**

```javascript
//forEach() 方法为每个数组元素调用一次函数（回调函数）。
//注释：该函数接受 3 个参数：项目值  项目索引  数组本身
var txt = "";
var numbers = [45, 4, 9, 16, 25];
numbers.forEach(myFunction);

 //例子只用了 value 参数。可以重新写为：function myFunction(value)
function myFunction(value, index, array) { 
  txt = txt + value + "<br>"; 
}


//map() 方法通过对每个数组元素执行函数来创建新数组。
//map() 方法不会对没有值的数组元素执行函数。map() 方法不会更改原始数组。
var numbers1 = [45, 4, 9, 16, 25];
var numbers2 = numbers1.map(myFunction);

function myFunction(value, index, array) {
  return value * 2;  //这个例子将每个数组值乘以2：
}


//filter() 方法创建一个包含通过测试的数组元素的新数组。
var numbers = [45, 4, 9, 16, 25];
var over18 = numbers.filter(myFunction);

function myFunction(value, index, array) {
  return value > 18;  //这个例子用值大于 18 的元素创建一个新数组
}


//reduce() 方法(类似求和？？？)   ————   Array.reduceRight()
var numbers1 = [45, 4, 9, 16, 25];
var sum = numbers1.reduce(myFunction);

function myFunction(total, value, index, array) {
  return total + value;  //这个例子确定数组中所有数字的总和：
}


//every() 方法检查所有数组值是否通过测试。
var numbers = [45, 4, 9, 16, 25];
var allOver18 = numbers.every(myFunction);

function myFunction(value, index, array) {
  return value > 18;  //这个例子检查所有数组值是否大于 18，结果为：false
}


//some() 方法检查某些数组值是否通过了测试。
var numbers = [45, 4, 9, 16, 25];
var someOver18 = numbers.some(myFunction);

function myFunction(value, index, array) {
  return value > 18;  //true
}


//indexOf() 方法在数组中搜索元素值并返回其位置。如果未找到项目，Array.indexOf() 返回 -1。.
//Array.lastIndexOf() 与 Array.indexOf() 类似，但是从数组结尾开始搜索。
var fruits = ["Apple", "Orange", "Apple", "Mango"];
var a = fruits.indexOf("Apple");  //0


//find() 方法返回通过测试函数的第一个数组元素的值。
//findIndex() 方法返回通过测试函数的第一个数组元素的索引。
var numbers = [4, 9, 16, 25, 29];
var first = numbers.find(myFunction);

function myFunction(value, index, array) {
  return value > 18;   //25
}
```

<br/>



## 2. 日期对象
- JavaScript 将日期存储为自 1970 年 1 月 1 日 00:00:00 UTC（协调世界时）以来的毫秒数。零时间是 1970 年 1 月 1 日 00:00:00 UTC。
```javascript
var d = new Date();
document.getElementById("demo").innerHTML = d;  //Sat Jun 27 2020 18:31:04 GMT+0800 (中国标准时间)
```

<br/>

**（1）创建 Date 对象**

> new Date()
> new Date(year, month, day, hours, minutes, seconds, milliseconds)
> new Date(milliseconds)
> new Date(date string)

```javascript
var d = new Date();                            //用当前日期和时间创建新的日期对象：
var d = new Date(2018, 11, 24, 10, 33, 30, 0); //7个数字分别指定年、月、日、小时、分钟、秒和毫秒（按此顺序）
                                               //如果只提供一个参数，则将其视为毫秒。一位和两位数年份将被解释为 19xx 年：
var d = new Date("October 13, 2014 11:13:00"); //从日期字符串创建一个新的日期对象.
var d = new Date(0);                           //创建一个零时加毫秒的新日期对象：Thu Jan 01 1970 08:00:00 GMT+0800 (中国标准时间)
```

<br/>

**（2）日期格式化**

- ISO 日期：	"2018-02-19" （国际标准）
- 短日期：	"02/19/2018" 或者 "2018/02/19"
- 长日期：	"Feb 19 2018" 或者 "19 Feb 2019"
- 完整日期：	"Monday February 25 2015"

```javascript
var d = new Date("2018-02-19"); //ISO 8601 语法 (YYYY-MM-DD) 是首选的 JavaScript 日期格式：
var d = new Date("2018");       //写日期也可以不规定具体的月和日 (YYYY)
var d = new Date("2018-02-19T12:00:00");  //写日期也可以添加时、分和秒 (YYYY-MM-DDTHH:MM:SS)：

var d = new Date("02/19/2018");  //短日期通常使用 "MM/DD/YYYY" 这样的语法：
var d = new Date("Feb 19 2018"); //长日期通常以 "MMM DD YYYY" 这样的语法来写
                                 //月和天能够以任意顺序出现,月能够以全称 (January) 或缩写 (Jan) 来写
var d = new Date("FEBRUARY, 25, 2015");      //逗号会被忽略，且对大小写不敏感
```

<br/>

**（3）获取日期方法**

```javascript
getDate()	     //以数值返回天（1-31）
getDay()	     //以数值获取周名（0-6）
getFullYear()	 //获取四位的年（yyyy）
getHours()	     //获取小时（0-23）
getMilliseconds()	//获取毫秒（0-999）
getMinutes()	 //获取分（0-59）
getMonth()	     //获取月（0-11）
getSeconds()	 //获取秒（0-59）
getTime()	     //获取时间（从 1970 年 1 月 1 日至今的毫秒数）

var d = new Date();
document.getElementById("demo").innerHTML = d.getTime();
document.getElementById("demo").innerHTML = d.getFullYear();
```
<br/>

**（4）将Date对象转换成时间戳**

```javascript
var newDay = new Date();  
console.log(Number(newDay)); 
```

<br/>



## 3. Math对象

**（1）随机数 Math.random()**

```javascript
Math.random();			                // 返回随机数，总是返回大于等于 0 小于 1 的数。
Math.floor(Math.random() * 10);		    // 返回 [0, 9] 之间的数
Math.floor(Math.random() * 11);		    // 返回 [0, 10] 之间的数
Math.floor(Math.random() * 10) + 1;	    // 返回 [1, 10] 之间的数
Math.floor(Math.random() * 100);	    // 返回 [0, 99] 之间的数
Math.floor(Math.random() * 101);	    // 返回 [0, 100] 之间的数
Math.floor(Math.random() * 100) + 1;	// 返回 [1, 100] 之间的数

//返回介于 min（包括）和 max（不包括）之间的随机数:
function getRndInteger(min, max) {
    return Math.floor(Math.random() * (max - min) ) + min;
}
//返回介于 min 和 max（都包括）之间的随机数
function getRndInteger(min, max) {
    return Math.floor(Math.random() * (max - min + 1) ) + min;
}
```

<br/>

**（2）Math 属性（常量）** ：JavaScript 提供了可由 Math 对象访问的 8 个数学常量：

```javascript
Math.E          // 返回欧拉指数（Euler's number）
Math.PI         // 返回圆周率（PI）
Math.SQRT2      // 返回 2 的平方根
Math.SQRT1_2    // 返回 1/2 的平方根
Math.LN2        // 返回 2 的自然对数
Math.LN10       // 返回 10 的自然对数
Math.LOG2E      // 返回以 2 为底的 e 的对数（约等于 1.414）
Math.LOG10E     // 返回以 10 为底的 e 的对数（约等于0.434）
```
<br/>

**（3）Math 对象方法** ：（Math对象方法和属性是静态的。）

```javascript
random()	//返回 0 ~ 1 之间的随机数
abs(x)	    //返回 x 的绝对值
round(x)	//把 x 四舍五入为最接近的整数
ceil(x)   	//对 x 进行上舍入
floor(x)	//对 x 进行下舍入

pow(x,y)	//返回 x 的 y 次幂
sqrt(x)	    //返回 x 的平方根
log(x)   	//返回 x 的自然对数（底为e）
exp(x)	    //返回 Ex 的值

max(x,y,z,...,n)	//返回最高值
min(x,y,z,...,n)	//返回最低值

sin(x)	   //返回 x（x 以角度计）的正弦
cos(x)	   //返回 x 的余弦
tan(x)	   //返回角的正切

acos(x)	   //返回 x 的反余弦值，以弧度计
asin(x)	   //返回 x 的反正弦值，以弧度计
atan(x)	   //以介于 -PI/2 与 PI/2 弧度之间的数值来返回 x 的反正切值。
atan2(y,x) //返回从 x 轴到点 (x,y) 的角度
```

<br/>



# 三 JavaScript进阶

## 1. 变量预解析

	JavaScript 代码是由浏览器中的 JavaScript 解析器来执行的。JavaScript 解析器在运行 JavaScript 代码的时候分为两步：预解析和代码执行。

- 预解析：在当前作用域下, JS 代码执行之前，浏览器会默认把带有 var 和 function 声明的变量在内存中进行提前声明或者定义。

- 代码执行： 从上到下执行JS语句。

  **预解析会把变量和函数的声明在代码执行之前执行完成。**
  
  <br/>

**2.1 变量预解析**

	预解析也叫做变量、函数提升。
	变量提升（变量预解析）： 变量的声明会被提升到当前作用域的最上面，变量的赋值不会提升。

```js
console.log(num);  // 结果是多少？
var num = 10;      // ？
```

	结果：undefined
	
	注意：**变量提升只提升声明，不提升赋值**

<br/>

**2.2 函数预解析**

	函数提升： 函数的声明会被提升到当前作用域的最上面，但是不会调用函数。

```js
fn();
function fn() {
    console.log('打印');
}
```

	结果：控制台打印字符串 --- ”打印“ 
	
	注意：函数声明代表函数整体，所以函数提升后，函数名代表整个函数，但是函数并没有被调用！	

<br/>

**2.3 函数表达式声明函数问题**

	函数表达式创建函数，会执行变量提升，此时接收函数的变量名无法正确的调用：

```js
fn();
var  fn = function() {
    console.log('想不到吧');
}
```

	结果：报错提示 ”fn is not a function"
	
	解释：该段代码执行之前，会做变量声明提升，fn在提升之后的值是undefined；而fn调用是在fn被赋值为函数体之前，此时fn的值是undefined，所以无法正确调用

<br/>




## 2. 开启严格模式

JavaScript 除了提供正常模式外，还提供了严格模式（strict mode）。ES5 的严格模式是采用具有限制性 JavaScript变体的一种方式，即在严格的条件下运行 JS 代码。

严格模式在 IE10 以上版本的浏览器中才会被支持，旧版本浏览器中会被忽略。

严格模式对正常的 JavaScript 语义做了一些更改： 

1.消除了 Javascript 语法的一些不合理、不严谨之处，减少了一些怪异行为。

2.消除代码运行的一些不安全之处，保证代码运行的安全。

3.提高编译器效率，增加运行速度。

4.禁用了在 ECMAScript 的未来版本中可能会定义的一些语法，为未来新版本的 Javascript 做好铺垫。比如一些保留字如：class,enum,export, extends, import, super 不能做变量名

<br/>

**开启严格模式**

严格模式可以应用到整个脚本或个别函数中。因此在使用时，我们可以将严格模式分为为脚本开启严格模式和为函数开启严格模式两种情况。

- 情况一 :为脚本开启严格模式

  - 有的 script 脚本是严格模式，有的 script 脚本是正常模式，这样不利于文件合并，所以可以将整个脚本文件放在一个立即执行的匿名函数之中。这样独立创建一个作用域而不影响其他
    script 脚本文件。

```js
(function (){
  //在当前的这个自调用函数中有开启严格模式，当前函数之外还是普通模式
　　　　"use strict";
       var num = 10;
　　　　function fn() {}
})();
//或者 
<script>
  　"use strict"; //当前script标签开启了严格模式
</script>
<script>
  			//当前script标签未开启严格模式
</script>
```

- 情况二: 为函数开启严格模式

  - 要给某个函数开启严格模式，需要把“use strict”;  (或 'use strict'; ) 声明放在函数体所有语句之前。

```js
function fn(){
　　"use strict";
　　return "123";
} 
//当前fn函数开启了严格模式
```

<br/>

**严格模式中的变化**

严格模式对 Javascript 的语法和行为，都做了一些改变。

```js
'use strict'
num = 10 
console.log(num)//严格模式后使用未声明的变量
--------------------------------------------------------------------------------
var num2 = 1;
delete num2;//严格模式不允许删除变量
--------------------------------------------------------------------------------
function fn() {
 console.log(this); // 严格模式下全局作用域中函数中的 this 是 undefined
}
fn();  
---------------------------------------------------------------------------------
function Star() {
	 this.sex = '男';
}
// Star();严格模式下,如果 构造函数不加new调用, this 指向的是undefined 如果给他赋值则 会报错.
var ldh = new Star();
console.log(ldh.sex);
----------------------------------------------------------------------------------
setTimeout(function() {
  console.log(this); //严格模式下，定时器 this 还是指向 window
}, 2000);  
```

[更多严格模式要求参考](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Strict_mode)



<br/>



## 3. 对象与原型链

**（一）对象**

对象的三种创建方式：

1. 字面量方式

   ```js
   var obj = {};
   ```

2. new关键字

   ```js
   var obj = new Object();
   ```

3. 构造函数方式

   ```js
   function Person(name,age){
     this.name = name;
     this.age = age;
   }
   var obj = new Person('zs',12);
   ```

<br/>

**实例成员和静态成员：**

**1. 实例成员**

实例成员就是构造函数内部通过this添加的成员 如下列代码中uname age sing 就是实例成员,实例成员只能通过实例化的对象来访问

```js
 function Star(uname, age) {
     this.uname = uname;
     this.age = age;
     this.sing = function() {
     console.log('我会唱歌');
    }
}
var ldh = new Star('刘德华', 18);
console.log(ldh.uname);//实例成员只能通过实例化的对象来访问
```

**2. 静态成员**

静态成员 在构造函数本身上添加的成员  如下列代码中 sex 就是静态成员,静态成员只能通过构造函数来访问

```js
 function Star(uname, age) {
     this.uname = uname;
     this.age = age;
     this.sing = function() {
     console.log('我会唱歌');
    }
}
Star.sex = '男';
var ldh = new Star('刘德华', 18);
console.log(Star.sex);//静态成员只能通过构造函数来访问
```

<br/>



**（二）原型链**

**对象原型：**

```html
对象都会有一个属性 __proto__ 指向构造函数的 prototype 原型对象，之所以我们对象可以使用构造函数 prototype 原型对象的属性和方法，
就是因为对象有 __proto__ 原型的存在。
__proto__对象原型和原型对象 prototype 是等价的
__proto__对象原型的意义就在于为对象的查找机制提供一个方向，或者说一条路线，但是它是一个非标准属性，因此实际开发中，不可以使用这个属性，
它只是内部指向原型对象 prototype
```

![](_v_images/20201113092941345_16411.png)
![](_v_images/20201113093025912_26680.png)

**原型链：**
![](_v_images/20201113093505550_5177.png)
![](_v_images/20201113093654615_12189.png)

```js
1.构造函数的prototype属性指向了构造函数原型对象
2.实例对象是由构造函数创建的,实例对象的__proto__属性指向了构造函数的原型对象
3.构造函数的原型对象的constructor属性指向了构造函数,实例对象的原型的constructor属性也指向了构造函数
```

```html
当访问一个对象的属性（包括方法）时，首先查找这个对象自身有没有该属性。
如果没有就查找它的原型（也就是 __proto__指向的 prototype 原型对象）。
如果还没有就查找原型对象的原型（Object的原型对象）。
依此类推一直找到 Object 为止（null）。
__proto__对象原型的意义就在于为对象成员查找机制提供一个方向，或者说一条路线。
```

<br/>




## 2. 对象的继承

- call()可以调用函数
- call()可以修改this的指向,使用call()的时候 参数一是修改后的this指向,参数2,参数3..使用逗号隔开连接

```js
 function fn(x, y) {
     console.log(this);
     console.log(x + y);
}
  var o = {
  	name: 'andy'
  };
  fn.call(o, 1, 2);//调用了函数此时的this指向了对象o,
```

![](_v_images/20201113093919175_6636.png)

<br/>

**子构造函数继承父构造函数中的属性：**

1. 先定义一个父构造函数
2. 再定义一个子构造函数
3. 子构造函数继承父构造函数的属性(使用call方法)

```js
 // 1. 父构造函数
 function Father(uname, age) {
   // this 指向父构造函数的对象实例
   this.uname = uname;
   this.age = age;
 }
  // 2 .子构造函数 
function Son(uname, age, score) {
  // this 指向子构造函数的对象实例
  // 3.使用call方式实现子继承父的属性
  Father.call(this, uname, age);
  this.score = score;
}
var son = new Son('刘德华', 18, 100);
console.log(son);
```

![](_v_images/20201113094124693_5501.png)

<br/>

**借用原型对象继承方法：**

1. 先定义一个父构造函数
2. 再定义一个子构造函数
3. 子构造函数继承父构造函数的属性(使用call方法)

```js
// 1. 父构造函数
function Father(uname, age) {
  // this 指向父构造函数的对象实例
  this.uname = uname;
  this.age = age;
}
Father.prototype.money = function() {
  console.log(100000);
 };
 // 2 .子构造函数 
  function Son(uname, age, score) {
      // this 指向子构造函数的对象实例
      Father.call(this, uname, age);
      this.score = score;
  }
// Son.prototype = Father.prototype;  这样直接赋值会有问题,如果修改了子原型对象,父原型对象也会跟着一起变化
  Son.prototype = new Father();
  // 如果利用对象的形式修改了原型对象,别忘了利用constructor 指回原来的构造函数
  Son.prototype.constructor = Son;
  // 这个是子构造函数专门的方法
  Son.prototype.exam = function() {
    console.log('孩子要考试');

  }
  var son = new Son('刘德华', 18, 100);
  console.log(son);
```

![](_v_images/20201113094343118_25471.png)



<br/>

