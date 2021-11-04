



# 一 CSS基础

**CSS书写规范及注释**： 

- 选择器 与 `{` 之间必须包含空格
- 属性定义必须另起一行、属性定义后必须以分号结尾
- 属性名与之后的` :` 之间不允许包含空格，` :` 与 属性值之间必须包含空格
- 并集选择器，每个选择器声明必须独占一行
- 一般情况情况下，选择器的嵌套层级应不大于 3 级，位置靠后的限定条件应尽可能精确

```css
/*  注释内容  */
```



## 1. 样式表分类
|   样式表   |          优点          |          缺点          |   使用情况    |     控制范围      |
| --------- | --------------------- | --------------------- | ------------ | ---------------- |
| 行内样式表 | 书写方便，权重高        | 没有实现样式和结构相分离 | 较少          | 控制一个标签（少） |
| 内部样式表 | 部分结构和样式相分离     | 没有彻底分离            | 较多          | 控制一个页面（中） |
| 外部样式表 | 完全实现结构和样式相分离 | 需要引入               | 最多，强烈推荐 | 控制整个站点（多） |

![image-20211026150259619](vx_images/image-20211026150259619.png)

![image-20211026151756968](vx_images/image-20211026151756968.png)




## 2. CSS选择器
|   选择器    |            作用            |          缺点          |  使用情况  |         用法         |
| ----------- | -------------------------- | --------------------- | --------- | -------------------- |
| 标签选择器   | 可以选出所有相同的标签，比如p | 不能差异化选择          | 较多       | `p { color：red;}`  |
| 类选择器     | 可以选出1个或者多个标签       | 可以根据需求选择         | 非常多     | `.nav { color: red; }` |
| id选择器     | 一次只能选择器1个标签         | 只能使用一次            | 不推荐使用 | `#nav {color: red;}` |
| 通配符选择器 | 选择所有的标签              | 选择的太多，有部分不需要 | 不推荐使用 | `* {color: red;}`    |

|   复合选择器 |          作用          |        特征        | 使用情况 |             隔开符号及用法             |
| ------------ | --------------------- | ------------------ | -------- | ------------------------------------ |
| 后代选择器     | 用来选择元素后代         | 是选择所有的子孙后代 | 较多     | 符号是**空格** `.nav a`               |
| 子代选择器     | 选择 最近一级元素        | 只选亲儿子          | 较少     | 符号是 >   `.nav>p`               |
| 交集选择器     | 选择两个标签交集的部分   | 既是 又是           | 较少     | **没有符号**  `p.one`                 |
| 并集选择器     | 选择某些相同样式的选择器 | 可以用于集体声明     | 较多     | 符号是**逗号** `.nav, .header`        |
| 链接伪类选择器 | 给链接更改状态          |                    | 较多     | 重点记住 `a{}` 和 `a:hover` |

```css
/* 并集选择器 */
.post,
.page,
.comment {
    line-height: 1.5;
}
```



## 3. CSS文本样式

| 文本属性        | 表示     | 注意点                                                       |
| :-------------- | :------- | :----------------------------------------------------------- |
| color           | 颜色     | 预定义的颜色值/十六进制/RGB代码（常用  十六进制，比如: #fff ） |
| line-height     | 行高     | 控制行与行之间的距离                                         |
| text-align      | 水平对齐 | 可以设定文字水平的对齐方式 （left、center、right）           |
| text-indent     | 首行缩进 | 通常我们用于段落首行缩进2个字的距离   `text-indent: 2em;`    |
| text-decoration | 文本修饰 | 添加下划线  underline  、取消下划线  none                    |

| 字体属性    | 表示     | 注意点                                                       |
| :---------- | :------- | :----------------------------------------------------------- |
| font-size   | 字号     | 我们通常用的单位是px 像素，一定要跟上单位                    |
| font-family | 字体     | 可以一次设置多个字体、如果浏览器不支持第一个字体，则会尝试下一个 |
| font-weight | 字体粗细 | 加粗是 700 或者 bold、  不加粗是 normal 或者 400 （数字不要跟单位） |
| font-style  | 字体样式 | 倾斜是 italic、不倾斜是 normal（工作中我们最常用 normal ）   |
| font        | 字体连写 | 1. 字体连写是有顺序的  不能随意换位置   2. 其中字号 和 字体 必须同时出现 |

![image-20211026161433436](vx_images/image-20211026161433436.png)



## 4. Background

|         属性          | 作用            | （常用）值                                                                              |
| --------------------- | :------------- | :---------------------------------------------------------------------------------- |
| background-color      | 背景颜色         | 预定义的颜色值/十六进制/RGB代码                                                       |
| background-image      | 背景图片         | url(图片路径)                                                                       |
| background-repeat     | 是否平铺（复用）     | repeat / no-repeat / repeat-x / repeat-y                                            |
| background-position   | 背景图片位置的起始位置 | length / position    分别是x  和 y坐标 |
| background-attachment | 背景固定还是滚动 | scroll / fixed                                                                      |
| background    | 更简单          | `color iamgeurl repeat attachment position;` (没有顺序) |
注：**background-position** — 必须先指定background-image属性、用的最多的就是背景图片居中对齐

```css
background-position : length || length  和 background-position : position || position 

 /*-- 如果指定两个值，两个值都是方位名字，则两个值前后顺序无关，比如left  top和top  left效果一致--*/
background-position : right top;     /*--背景图片右上角与容器 右上角 重合 */
background-position : center center; /*-- 居中对齐 --*/
background-position : right;         /* 如果只指定了一个方位名词，另一个值默认居中对齐。*/

background-position : 10px 50px;     /* 如果position 后面是精确坐标， 那么第一个肯定是 x  第二的一定是y */
background-position : 10px;          /* 如果只指定一个数值,那该数值一定是x坐标，另一个默认垂直居中 */

/* 如果指定的两个值是 精确单位和方位名字混合使用，则第一个值是x坐标，第二个值是y坐标*/
background-position : right 20px;    
```
例：

![image-20211026172838274](vx_images/image-20211026172838274.png)

```css
/* 背景透明设置（让盒子半透明） */
background: rgba(166, 166, 255, 0.1);
```



# 二 CSS核心

## 1. display
HTML标签一般分为块标签和行内标签两种类型，它们也称块元素和行内元素。

|  元素模式  |       元素排列       |       设置样式       |    默认宽度     |          包含          |
| --------- | -------------------- | -------------------- | -------------- | --------------------- |
| 块级元素   | 一行只能放一个块级元素 | 可以设置宽度高度       | 容器的100%      | 容器级可以包含任何标签   |
| 行内元素   | 一行可以放多个行内元素 | 不可以直接设置宽度高度 | 它本身内容的宽度 | 容纳文本或则其他行内元素 |
| 行内块元素 | 一行放多个行内块元素   | 可以设置宽度和高度     | 它本身内容的宽度 |                       |
**（1）块级元素(block-level)**：

​	常见的块元素有`<h1>~<h6>、<p>、<div>、<ul>、<ol>、<li>`等，其中`<div>`标签是最典型的块元素。

- 注意：只有 文字才 能组成段落  因此 p  里面不能放块级元素，特别是 p 不能放div 、同理还有这些标签`h1, h2, h3, h4, h5, h6, dt`，他们都是文字类块级标签，里面不能放其他块级元素。

**（2）行内元素(inline-level)**：

​	常见的行内元素有`<a>、<strong>、<b>、<em>、<i>、<del>、<s>、<ins>、<u>、<span>`等，其中`<span>`标签最典型的行内元素。

​	有的地方也成内联元素

- 注意：链接里面不能再放链接、特殊情况a里面可以放块级元素，但是给a转换一下块级模式最安全。

**（3）行内块元素（inline-block）** 

​	在行内元素中有几个特殊的标签——`<img />、<input />、<td>`，可以对它们设置宽高和对齐属性

**（4）标签显示模式转换 display** ： 

- 块转行内：`display:inline;` 
- 行内转块：`display:block; ` 
- 块、行内元素转换为行内块： `display: inline-block;` 



## 2. 盒模型

盒模型：外边距（margin）、边框（border）、内边距（padding）和内容部分

![image-20211026221500583](vx_images/image-20211026221500583.png)

margin、padding 值的个数对应上下左右：

| 值的个数 | 表达意思                                                  |
| -------- | --------------------------------------------------------- |
| 1个值    | 上、下、左、右 （全部）                                   |
| 2个值    | 第一个值上下、第二值左右                                  |
| 3个值    | 第一个值上、第二值左右、第三个值下                        |
| 4个值    | 第一个值上、第二值右、第三个值下、第四个值左 （上右下走） |

```css
margin: 10px 0 0 20px; /* 上右下左分别为： 10px 0 0 20px */
padding: 20px 10px;    /* 上右下左分别为： 20px 10px 20px 10px */
```



相关问题——**块元素的水平居中、外边距合并问题**： 

![image-20211026205707869](vx_images/image-20211026205707869.png)



![image-20211026214910341](vx_images/image-20211026214910341.png)

**解决方案：** 

1. 可以为父元素定义上边框
2. 可以为父元素定义上内边距
3. 可以为父元素添加`overflow:hidden`、还有其他方法，比如浮动、固定、绝对定位的盒子不会有此问题。



注意：优先使用宽度 （width）、其次使用内边距（padding）、最后再考虑使用外边距（margin）、因为：

- margin 会有外边距合并 还有 ie6下面margin 加倍的bug、所以最后使用
- padding  会影响盒子大小， 需要进行加减计算（麻烦） 其次使用
- width   没有问题、我们经常使用宽度剩余法、 高度剩余法来做



## 3. 盒子边框

**边框(border)** ： 

~~~css
/* border : border-width || border-style || border-color   没有顺序，如： */
border: 1px solid red; 
~~~

|     属性     |                                                  作用                                                   |
| ------------ | :------------------------------------------------------------------------------------------------------ |
| border-width |                                          定义边框粗细，单位是px                                           |
| border-style | -none：没有边框（默认值） <br />-solid：边框为单实线(最为常用的)  <br />-dashed：边框为虚线 <br />-dotted：边框为点线 |
| border-color |                                                 边框颜色                                                 |



**圆角及阴影**： 

```css
/* 圆角：border-radius:length; */

border-radius: 50%;  /* 矩形会变成椭圆，正方形变成圆*/
```

~~~css
/* 阴影： box-shadow: 水平阴影 垂直阴影 模糊距离（虚实）  阴影尺寸（影子大小）  阴影颜色  内/外阴影；*/
div {
    /* box-shadow: 5px 5px 3px 4px rgba(0, 0, 0, .4);  */
    box-shadow: 0 15px 30px  rgba(0, 0, 0, 0.4);		
}
~~~
![image-20211026230811003](vx_images/image-20211026230811003.png)



## 3. 浮动(float)

使用浮动的核心目的——**让多个块级盒子在同一行显示**。 这也是我们最常见的一种布局方式
- 加了浮动的盒子是浮起来的，漂浮在其他标准流盒子的上面。
- 加了浮动的盒子是不占位置的，它原来的位置给了标准流的盒子。
- 浮动元素会改变display属性， 类似转换为了行内块，但是元素之间没有空白缝隙



- 浮动是脱标的，会影响下面的标准流元素，此时，我们需要给浮动的元素添加一个标准流的父亲，这样，最大化的减小了对其他标准流的影响。
- 子盒子的浮动参照父盒子对齐，不会与父盒子的边框重叠，也不会超过父盒子的内边距
- 在一个父级盒子中，如果前一个兄弟盒子是：浮动的，那么当前盒子会与前一个盒子的顶部对齐；普通流的，那么当前盒子会显示在前一个兄弟盒子的下方。
- 如果一个盒子里面有多个子盒子，如果其中一个盒子浮动了，其他兄弟也应该浮动。防止引起问题


**清除浮动** ： 

- 父级盒子很多情况下，有时不方便给高度，但是子盒子浮动就不占有位置，最后父级盒子高度为0，就影响了下面的标准流盒子。
- 清除浮动主要为了解决父级元素因为子级浮动引起内部高度为0 的问题。清除浮动之后， 父级就会根据浮动的子盒子自动检测高度。父级有了高度，就不会影响下面的标准流了
```css
.clearfix:before,.clearfix:after { 
  content:"";
  display:table; 
}
.clearfix:after {
 clear:both;
}
.clearfix {
  *zoom:1;
}
```
**什么时候用清除浮动？**
1. 父级没高度
2. 子盒子浮动了
3. 影响下面布局了，我们就应该清除浮动了。

|    清除浮动的方式     | 优点             | 缺点                            |
| -------------------- | :--------------- | :------------------------------ |
| 额外标签法（隔墙法）   | 通俗易懂，书写方便 | 添加许多无意义的标签，结构化较差。 |
| 父级overflow:hidden; | 书写简单          | 溢出隐藏                        |
| 父级after伪元素      | 结构语义化正确     | 由于IE6-7不支持:after，兼容性问题 |
| 父级双伪元素         | 结构语义化正确     | 由于IE6-7不支持:after，兼容性问题 |



## 4. position

|     定位模式     |   是否脱标占有位置   | 移动位置基准          | 模式转换（行内块） |        使用情况        |
| ---------------- | ------------------ | :------------------- | ---------------- | --------------------- |
| 静态static       | 不脱标，正常模式     | 正常模式             | 不能             | 几乎不用               |
| 相对定位relative | 不脱标，占有位置     | 相对自身位置移动       | 不能             | 基本单独使用            |
| 绝对定位absolute | 完全脱标，不占有位置 | 相对于定位父级移动位置 | 能               | 要和定位父级元素搭配使用 |
| 固定定位fixed    | 完全脱标，不占有位置 | 相对于浏览器移动位置   | 能               | 单独使用，不需要父级     |

> **相对定位**的特点：（务必记住）
> - 相对于 自己原来在标准流中位置来移动的
> - 原来**在标准流的区域继续占有**，后面的盒子仍然以标准流的方式对待它。

&nbsp;

> **绝对定位**的特点：（务必记住）
> - 绝对是以带有定位的父级元素来移动位置 （拼爹型） 如果父级都没有定位，则以浏览器文档为准移动位置
> - 不保留原来的位置，完全是脱标的。
> - 因为绝对定位的盒子是拼爹的，所以要和父级搭配一起来使用。
> - 定位口诀 —— **子绝父相** —— **子级**是**绝对**定位，**父级**要用**相对**定位。

&nbsp;

> **固定定位**是**绝对定位**的一种特殊形式： （认死理型）   如果说绝对定位是一个矩形 那么 固定定位就类似于正方形
> 1. **完全脱标** —— 完全不占位置；
> 2. 只认**浏览器的可视窗口** —— `浏览器可视窗口 + 边偏移属性` 来设置元素的位置；
>    * 跟父元素没有任何关系；单独使用的
>    * 不随滚动条滚动。

![](_v_images/20201030101610551_14720.png)

![](_v_images/20201030101646005_30569.png)



**绝对定位的盒子居中**： 

> **注意**：**绝对定位/固定定位的盒子**不能通过设置 `margin: auto` 设置**水平居中**。在使用**绝对定位**时要想实现水平居中，可以参照下图的方法：
1. `left: 50%;`：让**盒子的左侧**移动到**父级元素的水平中心位置**；
2. `margin-left: -100px;`：让盒子**向左**移动**自身宽度的一半**。

![image-20211026232813974](vx_images/image-20211026232813974.png)

![image-20211026234904039](vx_images/image-20211026234904039.png)



`z-index` 的特性如下：

1. **属性值**：**正整数**、**负整数**或 **0**，默认值是 0，数值越大，盒子越靠上；
2. 如果**属性值相同**，则按照书写顺序，**后来居上**；
3. **数字后面不能加单位**。
**注意**：`z-index` 只能应用于**相对定位**、**绝对定位**和**固定定位**的元素，其他**标准流**、**浮动**和**静态定位**无效。

**改变显示模式**有以下方式:
* 可以用 inline-block  转换为行内块
* 可以用浮动 float 默认转换为行内块（类似，并不完全一样，因为浮动是脱标的）
* 绝对定位和固定定位也和浮动类似， 默认转换的特性 转换为行内块。
所以说， 一个行内的盒子，如果加了**浮动**、**固定定位**和**绝对定位**，不用转换，就可以给这个盒子直接设置宽度和高度等。
**同时注意：**
浮动元素、绝对定位(固定定位）元素的都不会触发外边距合并的问题。 （我们以前是用padding border overflow解决的）
也就是说，我们给盒子改为了浮动或者定位，就不会有垂直外边距合并的问题了。



## 5. 权重计算

| CSS三大特性 | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| 层叠性      | 一个属性通过两个相同选择器设置到同一个元素上（样式冲突），那么其中一个属性就会被另一个属性 <br />层叠掉（覆盖）、样式冲突遵循的是就近原则、 哪个样式近就执行那个样式，样式不冲突，不会层叠 |
| 继承性      | 子标签会继承父标签的某些样式（**text-，font-，line-这些开头的、以及color属性可以继承**） |
| 优先级      | 定义CSS样式时，经常出现两个或更多规则应用在同一元素上，此时若选择器相同，则执行层叠性、<br />若选择器不同，就会出现优先级的问题 |

**权重计算公式**： CSS Specificity（特殊性）

| 标签选择器             | 计算权重公式   |
| ---------------------- | -------------- |
| 继承或者 *             | `0, 0, 0, 0`   |
| 每个元素（标签选择器） | `0, 0, 0, 1`   |
| 每个类，伪类           | `0, 0, 1, 0`   |
| 每个ID                 | `0, 1, 0, 0`   |
| 每个行内样式 style=""  | `1, 0, 0, 0`   |
| 每个!important  重要的 | `∞ `（无穷大） |

- 值从左到右，左面的最大，一级大于一级，数位之间没有进制，级别之间不可超越。 



**权重叠加**： 
我们经常用交集选择器，后代选择器等，是有多个基础选择器组合而成，那么此时，就会出现权重叠加。就是一个简单的加法计算

- div ul  li   ------>      0,0,0,3
- .nav ul li   ------>      0,0,1,2
- a:hover      -----—>   0,0,1,1
- .nav a       ------>      0,0,1,1

- 注意： 数位之间没有进制 比如说： 0,0,0,5 + 0,0,0,5 =0,0,0,10 而不是 0,0, 1, 0， 所以不会存在10个div能赶上一个类选择器的情况。



**继承的权重是0**： 
这个不难，但是忽略很容易绕晕。其实，我们修改样式，一定要看该标签有没有被选中。
1） 如果选中了，那么以上面的公式来计权重。谁大听谁的。 
2） 如果没有选中，那么权重是0，因为继承的权重为0.





# 三 高级技巧
## 1. 显示与隐藏

| 属性           | 区别                   | 用途                                                         |
| -------------- | ---------------------- | ------------------------------------------------------------ |
| **display**    | 隐藏对象，不保留位置   | 配合后面js做特效，比如下拉菜单，原先没有，鼠标经过，显示下拉菜单， 应用极为广泛 |
| **visibility** | 隐藏对象，保留位置     | 使用较少                                                     |
| **overflow**   | 只是隐藏超出大小的部分 | 1. 可以清除浮动  2. 保证盒子里面的内容不会超出该盒子范围     |

~~~css
display: none   隐藏对象  特点： 隐藏之后，不再保留位置。
display：block  除了转换为块级元素之外，同时还有显示元素的意思。
~~~

~~~css
visibility：visible ; 　对象可视
visibility：hidden; 　  对象隐藏  特点： 隐藏之后，继续保留原有位置。
~~~

**overflow溢出** ：检索或设置当对象的内容超过其指定高度及宽度时如何管理内容

|    属性值    |                  描述                  |
| ----------- | ------------------------------------- |
| **visible** | 不剪切内容也不添加滚动条                 |
| **hidden**  | 不显示超过对象尺寸的内容，超出的部分隐藏掉 |
| **scroll**  | 不管超出内容否，总是显示滚动条            |
| **auto**    | 超出自动显示滚动条，不超出不显示滚动条     |



**溢出的文字省略号显示**：

~~~css
white-space: nowrap;         /*1. 先强制一行内显示文本*/
overflow: hidden;            /*2. 超出的部分隐藏*/
text-overflow: ellipsis;     /*3. 文字用省略号替代超出的部分*/
~~~

&nbsp;



## 2. 用户界面样式

|     属性     |        用途         |                          用途                           |
| ------------ | ------------------ | ------------------------------------------------------- |
| **鼠标样式** | 更改鼠标样式cursor   | 样式很多，重点记住 pointer                                |
| **轮廓线**   | 表单默认outline      | outline 轮廓线，我们一般直接去掉，border是边框，我们会经常用 |
| 防止拖拽     | 主要针对文本域resize | 防止用户随意拖拽文本域，造成页面布局混乱，我们resize:none    |

**鼠标样式cursor** ：设置或检索在对象上移动的鼠标指针采用何种系统预定义的光标形状。
```html
<ul>
  <li style="cursor:default">我是小白</li>
  <li style="cursor:pointer">我是小手</li>
  <li style="cursor:move">我是移动</li>
  <li style="cursor:text">我是文本</li>
  <li style="cursor:not-allowed">我是文本</li>
</ul>
```

**轮廓线 outline** ：是绘制于元素周围的一条线，位于边框边缘的外围，可起到突出元素的作用。 
```html
 <input  type="text"  style="outline: 0;"/>
```

**防止拖拽文本域resize** ：实际开发中，我们文本域右下角是不可以拖拽： 
```html
<textarea  style="resize: none;"></textarea>
```
&nbsp;

## 3. 水平垂直对齐

- 有宽度的块级元素居中对齐，是margin: 0 auto;
- 让文字居中对齐，是 text-align: center;
- vertical-align：

![](_v_images/20201030105147330_29459.png)



**去除图片底侧空白缝隙**  图片或者表单等行内块元素，他的底线会和父级盒子的基线对齐。就是图片底侧会有一个空白缝隙。
![](_v_images/20201030105418952_21120.png)
**解决方法：**

- 给 img 设置 vertical-align:middle | top| bottom 等等。 让图片不要和基线对齐。
- 或者给 img 添加 display：block;  转换为块级元素就不会存在问题了。



&nbsp;

## 4. CSS精灵技术

CSS精灵技术（sprite)：

> 当用户访问一个网站时，需要向服务器发送请求，网页上的每张图像都要经过一次请求才能展现给用户。然而，一个网页中往往会应用很多小的背景图像作为修饰，当网页中的图像过多时，服务器就会频繁地接受和发送请求，这将大大降低页面的加载速度。为了**有效地减少服务器接受和发送请求的次数**，提高页面的加载速度。出现了CSS精灵技术（也称CSS Sprites、CSS雪碧）。
CSS 精灵其实是将网页中的一些背景图像整合到一张大图中（精灵图），各个网页元素通常只需要精灵图中不同位置的某个小图，只需要精确定位到精灵图中的某个小图即可。

**精灵技术使用的核心总结** css精灵技术主要针对于背景图片，插入的图片img 是不需要这个技术的。
- 精确测量，每个小背景图片的大小和 位置。
- 给盒子指定小背景图片时， 背景定位基本都是 负值。

背景图片很少的情况，没有必要使用精灵技术，维护成本太高。 如果是背景图片比较多，可以建议使用精灵技术。


&nbsp;

## 5. CSS滑动门

> 为了使各种特殊形状的背景能够自适应元素中文本内容的多少，出现了CSS滑动门技术。它从新的角度构建页面，使各种特殊形状的背景能够自由拉伸滑动，以适应元素内部的文本内容，可用性更强。 最常见于各种导航栏的滑动门。

![](_v_images/20201030105931992_17756.png)


```html
<li>
  <a href="#">
    <span>导航栏内容</span>
  </a>
</li>
```
~~~css
* {
      padding:0;
      margin:0;

    }
    body{
      background: url(images/wx.jpg) repeat-x;
    }
    .father {
      padding-top:20px;
    }
    li {
      padding-left: 16px;
      height: 33px;
      float: left;
      line-height: 33px;
      margin:0  10px;
      background: url(./images/to.png) no-repeat left ;
    }
    a {
      padding-right: 16px;
      height: 33px;
      display: inline-block;
      color:#fff;
      background: url(./images/to.png) no-repeat right ;
      text-decoration: none;
    }
    li:hover,
     li:hover a {
      background-image:url(./images/ao.png);
    }
~~~

总结： 
1. a 设置 背景左侧，padding撑开合适宽度。    
2. span 设置背景右侧， padding撑开合适宽度 剩下由文字继续撑开宽度。
3. 之所以a包含span就是因为 整个导航都是可以点击的。

&nbsp;

## 6. margin负值

margin负值之美：

1). 负边距+定位：水平垂直居中：一个绝对定位的盒子， 利用 父级盒子的 50%， 然后 往左(上) 走 自己宽度的一半 ，可以实现盒子水平垂直居中。

2). 压住盒子相邻边框

![](_v_images/20201030110832335_8078.png)


&nbsp;

## 7. CSS三角形

~~~css
 div {
 	width: 0; 
    height: 0;
    line-height:0；
    font-size: 0;
    
	border-top: 10px solid red;
	border-right: 10px solid green;
	border-bottom: 10px solid blue;
	border-left: 10px solid #000; 
 }
~~~
![](_v_images/20201030111014997_1560.png)
**做法如下：**
1. 我们用css 边框可以模拟三角效果
2. 宽度高度为0
3. 我们4个边框都要写， 只保留需要的边框颜色，其余的不能省略，都改为 transparent 透明就好了
4. 为了照顾兼容性 低版本的浏览器，加上 font-size: 0;  line-height: 0;




# 三 CSS3
## 1. 边框背景
**（1）边框及阴影**
- border-radius
- box-shadow
- border-image
```css
div {
    box-shadow: 10px 10px 5px #888888;  /*向 div 元素添加方框阴影*/
}
```
**（2）文本和背景**
- background-size   ——规定背景图片的尺寸
- background-origin ——规定背景图片的定位区域

- text-shadow —— 可向文本应用阴影。
- word-wrap —— 允许文本进行换行 - 即使这意味着会对单词进行拆分：

```css
h1{text-shadow: 5px 5px 5px #FF0000;}  /*向标题添加阴影*/
p {word-wrap:break-word;}              /*允许对长单词进行拆分，并换行到下一行：*/
```

## 2. 选择器拓展
**（1）属性选择器**
```css
a[href] {color:red;}          /*只对有 href 属性的锚（a 元素）应用样式*/
a[href][title] {color:red;}   /*将同时有 href 和 title 属性的 HTML 超链接的文本设置为红色*/

planet[moons="1"] {color: red;}  /*只选择 moons 属性值为 1 的 planet 元素*/
```

<table class="dataintable">
<tbody><tr>
<th>类型</th>
<th>描述</th>
</tr>

<tr>
<td>[abc^="def"]</td>
<td>选择 abc 属性值以 "def" 开头的所有元素</td>
</tr>

<tr>
<td>[abc$="def"]</td>
<td>选择 abc 属性值以 "def" 结尾的所有元素</td>
</tr>

<tr>
<td>[abc*="def"]</td>
<td>选择 abc 属性值中包含子串 "def" 的所有元素</td>
</tr>
</tbody></table>

**（2）结构化伪类选择器**
```css
ul li:first-child {background-color: #888;}        /*ul下的第一个li*/
ul li:last-child {background-color: #114488;}      /*ul下的最后一个li*/

ul li:nth-child(6) { background-color: #225511;}   /*ul下的第六个li*/

ul li:nth-child(even) {background-color: red;}     /* ul下顺序为偶数的li  (even  odd奇数) */

ul li:nth-child(2n) {background-color: #c3f433;}   /* 等同于 even */
ul li:nth-child(2n+1) {background-color: #233433;} /* 等同于 odd */
ul li:nth-child(n+5) {background-color: #f3f4;}    /*第五个之后的所有li */
ul li:nth-child(-n+5) {background-color: #e3ee;}   /*第五个之前的所有li */
```
```css
/* 【注意】:nth-child 不区分子元素是否属于同一种类型 故推荐上面的写法，加上子元素的类型*/
/* 上面的例子中 ul 里面只能写 li 故 :nth-child 和  :nth-of-type 效果一样
/*  div :nth-child(1){...}   选择 div 下的第 1 个子元素 不区分子元素是否属于同一种类型 */
<div>
    <p>段落</p>
    <span>1   0</span>
    <span>2   0</span>
    <span>3   0</span>
</div>

div :nth-child(1) {background-color: #3e45;} /*选中的是 p 标签*/
div span:nth-child(1) {background-color: #3e45;} /*无选中的元素*/
div span:nth-child(2) {background-color: #3e45;} /*选中    <span>2   0</span> */

div span:nth-of-type(1) {background-color: #3e45;} /*选中  <span>1   0</span> (只计指定类型的个数)*/
/* :first-of-type 和 :last-of-type 同上
```

**（3）伪元素选择器**
```css
<div>TEST</div> 

div {
    width: 600px;
    height: 300px;
    border: 1px solid #ccc;
}

div::before {
    content: "这是before的内容";
    display: inline-block;
    width: 166px;
    height: 66px;
    background-color: #c333;
}

div::after {
    content: "这是after的内容";
    display: inline-block;
    width: 166px;
    height: 66px;
    background-color: #aaff;
}
```
![](_v_images/20201030134345247_27540.png)
![](_v_images/20201030134523185_19172.png)



## 3. 过渡和动画
```css
transition: all 1s;    /*过渡*/
```

**（1）定义和使用**

```css
/*定义动画*/
@keyframes toRight {
    0% {
        transform: translateX(0px);
    }
    100% {
        transform: translateX(1200px);
    }
}

.animation {
    width: 200px;
    height: 200px;
    background-color: #9944ff;
    animation-name: toRight;  /*调用动画*/
    animation-duration: 5s;
}
```
![](_v_images/20201030171910199_20118.png )

![](_v_images/20201030172544382_24228.png)

![](_v_images/20201031090159165_4087.png)



## 4. Transform-2D
**（1）移动 translate**

![](_v_images/20201030140926052_14979.png)

```css
transform: translate(100px, 100px);  /* 分别向下、向右移动100px */
transform: translate(100px, 0);      /* 向右移动100px  等同于： (Y轴同理)*/
transform: translateX(100px);
```

**（2）旋转 rotate**
```css
transform: rotate(135deg);
/*通过 rotate() 方法，元素顺时针旋转给定的角度。允许负值，元素将逆时针旋转。*/
/*设置元素转换的中心点：*/
transform-origin：[ <percentage> | <length> | left | center① | right ]      [ <percentage> | <length> | top | center② | bottom ]
```

**（3）缩放 scale**
```css
transform: scale(2, 1);  /*左右放大2倍，上下不变*/
transform: scale(2);     /*整体放大2倍，  只有一个参数时，第二个参数与第一个相同 等同于：*/
transform: scale(2, 2);

transform: scale(0.5);   /* 整体缩小一半*/
```
![](_v_images/20201030160848688_907.png)


**【注意】综合写法：**
```css
transform: translate(100px, 100px) rotate(135deg) scale(2, 2);
```
![](_v_images/20201030162822488_25835.png)




## 5. Transform-3D
![](_v_images/20201031105357489_14998.png)

**（1）透视和移动**
```css
perspective：none | <length> /*none： 不指定透视      <length>： 指定观察者距离「z=0」平面的距离，为元素及其内容应用透视变换。不允许负值 */
perspective: 500px;
```
![](_v_images/20201031091943947_656.png)

![](_v_images/20201031105437134_16132.png)

**（2）3D旋转**

![](_v_images/20201031093424590_7716.png)

![](_v_images/20201031094925195_8896.png)




# 四 移动Web

![](_v_images/20201101134031415_17207.png)

![](_v_images/20201101134130574_21015.png)


## 1. flex弹性布局





## 2. rem及媒体查询
![](_v_images/20201101134632725_15023.png )

![](_v_images/20201101134747651_5868.png)

![](_v_images/20201101134913987_32540.png)

![](_v_images/20201101135003206_21255.png)

![](_v_images/20201101135106262_26692.png)

![](_v_images/20201101135139134_4671.png)

![](_v_images/20201101135322232_16681.png)

![](_v_images/20201101140936583_9323.png)

![](_v_images/20201101141052980_12654.png)

![](_v_images/20201101141012817_22428.png)

![](_v_images/20201101141147639_21686.png)

![](_v_images/20201101141544294_14710.png )





## 3. Leaner Style Sheets

![](_v_images/20201101135902655_12299.png )

![](_v_images/20201101140032905_10742.png )

**Easy LESS**插件用来把ess件编译为CSs文件,安装完毕插件,重新加载下 vscode, 只要保存一下Less文件,会自动生成CSS文件。

![](_v_images/20201101140128241_31795.png )

![](_v_images/20201101140205062_19062.png )


![](_v_images/20201101140447127_16876.png)

![](_v_images/20201101140630356_24889.png)

![](_v_images/20201101140725484_11509.png)

![](_v_images/20201101140844179_23752.png)








