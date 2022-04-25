# 一 AJAX技术

AJAX = > Asynchronous JavaScript and XML（异步的 JavaScript 和 XML）

```html

传统的web应用允许用户填写表单(form)，当提交表单时就向web服务器发送一个请求。
服务器接收并处理传来的表单，然后返回一个新的网页(刷新整个页面--因为当时没有一种办法可以做到发送和响应指定的数据)。
这个做法浪费了许多带宽，因为在前后两个页面中的大部分HTML代码往往是相同的。
由于每次应用的交互都需要向服务器发送请求，应用的响应时间就依赖于服务器的响应时间。
在那个时代，网速还是相对比较慢的，这导致了用户界面的响应比本地应用慢得多

与此不同，AJAX应用可以仅向服务器发送并取回必需的数据。
因为在服务器和浏览器之间交换的数据大量减少，结果我们就能看到响应更快的应用。
同时很多的处理工作可以在发出请求的客户端机器上完成，所以Web服务器的处理时间也相对减少了

使用Ajax的最大优点，就是能在不更新整个页面的前提下维护数据。
这使得Web应用程序更为迅捷地回应用户动作，并避免了在网络上发送那些没有改变过的信息。
Ajax不需要任何浏览器插件，但需要用户允许JavaScript在浏览器上执行。

```


AJAX 的核⼼是 XMLHttpRequest 对象、不同的浏览器创建 XMLHttpRequest 对象的⽅法是有差异的

IE 浏览器使⽤ ActiveXObject，⽽其他的浏览器使⽤名为 XMLHttpRequest 的 JavaScript 内建对象

<br>



## 1. Ajax编程步骤

原生 JS 发送 Ajax 请求的步骤：

```javascript
$(function () {
    $("#username").on("blur", function () {
        // 第⼀步：创建XMLHttpRequest对象 (为了兼容性，需要小狐狸IE的兼容性问题)
        let xmlHttp;
        if (window.XMLHttpRequest) {
            xmlHttp = new XMLHttpRequest();  //⾮IE
        } else if (window.ActiveXObject) {
            xmlHttp = new ActiveXObject("Microsoft.XMLTYPE");  //IE
        }

        //第⼆步：设置和服务器端交互的相应参数和路径
        let url = "http://localhost:8080/user/isExist";
        xmlHttp.open("POST", url, true);

        //第三步：注册回调函数
        xmlHttp.onreadystatechange = function() {
            if (xmlHttp.readyState === 4) {
                if (xmlHttp.status === 200) {
                    let obj = document.getElementById("username_msg");
                    obj.innerText = xmlHttp.responseText;
                } else {
                    alert("AJAX服务器返回错误！");
                }
            }
        }

        //第四步：设置发送请求的内容和发送报文。然后发送请求
        let uname= document.getElementsByName("username")[0].value;
        // 增加 time 随机参数，防⽌读取缓存
        let params = "username=" + uname +"&time=" + Math.random();
        // 向请求添加 HTTP 头，POST如果有数据⼀定要加！！！！
        xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded;charset=UTF-8");

        xmlHttp.send(params);
    })
})
```

原生JS的方式步骤繁琐， ⽅法、属性、常⽤值较多 不好记忆



<br/>



## 2. XMLHttpRequest





<br>



## 3. XHR 2.0版本



<br>



## 4. Ajax存在的缺陷

对应用Ajax最主要的批评就是，它可能破坏浏览器后退按钮的正常行为。在动态更新页面的情况下，用户无法回到前一个页面状态，这是因为浏览器仅能记下历史记录中的静态页面。

一个被完整读入的页面与一个已经被动态修改过的页面之间的差别非常微妙；用户通常都希望单击后退按钮，就能够取消他们的前一次操作，但是在Ajax应用程序中，却无法这样做。

不过开发者已想出了种种办法来解决这个问题，当中大多数都是在用户单击后退按钮访问历史记录时，通过建立或使用一个隐藏的IFRAME来重现页面上的变更。（例如，当用户在Google Maps中单击后退时，它在一个隐藏的IFRAME中进行搜索，然后将搜索结果反映到Ajax元素上，以便将应用程序状态恢复到当时的状态。）

　　一个相关的观点认为，使用动态页面更新使得用户难于将某个特定的状态保存到收藏夹中。该问题的解决方案也已出现，大部分都使用URL片断标识符（通常被称为锚点，即URL中#后面的部分）来保持跟踪，允许用户回到指定的某个应用程序状态。（许多浏览器允许JavaScript动态更新锚点，这使得Ajax应用程序能够在更新显示内容的同时更新锚点。）这些解决方案也同时解决了许多关于不支持后退按钮的争论。

　　进行Ajax开发时，网络延迟——即用户发出请求到服务器发出响应之间的间隔——需要慎重考虑。不给予用户明确的回应 [5]，没有恰当的预读数据 [6]，或者对XMLHttpRequest的不恰当处理[7]，都会使用户感到延迟，这是用户不欲看到的，也是他们无法理解的[8]。通常的解决方案是，使用一个可视化的组件来告诉用户系统正在进行后台操作并且正在读取数据和内容。

　　一些手持设备（如手机、PDA等）现在还不能很好的支持Ajax;

　　用JavaScript作的Ajax引擎，JavaScript的兼容性和DeBug都是让人头痛的事;

　　Ajax的无刷新重载，由于页面的变化没有刷新重载那么明显，所以容易给用户带来困扰――用户不太清楚现在的数据是新的还是已经更新过的；现有的解决有：在相关位置提示、数据更新的区域设计得比较明显、数据更新后给用户提示等;

　　对串流媒体的支持没有FLASH、Java Applet好;

<br>



## 5. Ajax发展史介绍

在1998年前后，允许客户端脚本发送HTTP请求(XMLHTTP)的第一个组件由Outlook Web Access小组写成。

该组件原属于微软Exchange Server，并且迅速地成为了Internet Explorer 4.0的一部分。

IE5在JavaScript中引入了ActiveX对象（API），使得JavaScript可以直接发起HTTP请求，随后被多个浏览器跟进和模仿后，

最后W3C给这个API取名为XMLHttpRequest，并正式纳入W3C规范。

<br>

直到谷歌2004-2005年推出的两款革命性产品Gmail（邮件服务）和Google Map（谷歌地图）中，用户可以在不刷新页面的情况下，直接从服务器获取数据、这带来了非常友好的交互体验，加上一些别的因素，Ajax成为2005年的年度最火热的词汇之一，这项技术也开始流行起来。

<br>

Ajax这个词的来源：

Jesse James Garrett:  http://www.jjg.net/about/

https://courses.cs.washington.edu/courses/cse490h/07sp/readings/ajax_adaptive_path.pdf 

```javascript

Defining Ajax ：
Ajax isn’t a technology. It’s really several technologies, each flourishing in its own right, coming together in powerful new ways. 

Ajax incorporates:
    standards-based presentation using XHTML and CSS;
    dynamic display and interaction using the Document Object Model;
    data interchange and manipulation using XML and XSLT;
    asynchronous data retrieval using XMLHttpRequest;
    and JavaScript binding everything together.

```

Ajax不是一种新技术, 而是指 Asynchronous JavaScript + XML 等等技术的混合体



<br>



# 二 常用的Ajax库

随着Ajax的成熟，一些简化Ajax使用方法的程序库也相继问世。
同样，也出现了另一种辅助程序设计的技术，为那些不支持JavaScript的用户提供替代功能。

<br>

## 1. jquery

ajax() ⽅法 是 jQuery 最底层的 Ajax 实现，具有较⾼灵活性

```JavaScript

$.ajax({
    url: 请求地址
    type: "get | post | put | delete " 默认是get,
    data: 请求参数 {"id":"123","pwd":"123456"},
    dataType: 请求数据类型"html | text | json | xml | script | jsonp ",
    success: function(data, dataTextStatus, jqxhr){ }, //请求成功时 
    error: function(jqxhr, textStatus, error) //请求失败时
})

```

<br>

get() 和 post() ⽅法分别通过远程 HTTP GET和POST 请求载⼊信息 （url:请求的路径 、data:发送的数据）

```JavaScript

$.get(url, data, function(result) {
	 //省略将服务器返回的数据显示到⻚⾯的代码
});

$.post(url, data, function(result) {
 	//省略将服务器返回的数据显示到⻚⾯的代码
});

```



<br>



```js

常用选项参数介绍:

url：                 请求地址
type：                请求方法，默认为"GET"
dataType：            服务端响应数据类型
contentType：         请求体内容类型，默认"application/x-www-form-urlencoded"
data：                需要传递到服务端的数据，如果 GET 则通过 URL 传递，如果 POST 则通过请求体传递
timeout：             请求超时时间

beforeSend：          请求发起之前触发
success：             请求成功之后触发（响应状态码200）
error：               请求失败触发
complete：            请求完成触发（不管成功与否）

```



<br>



## 2. Axios

Axios 是目前应用最广泛的 AJAX 封装库

Axios 中文文档：https://www.axios-http.cn/docs/intro





<br>



## 3. Request







<br>



## 4. Fetch API



<br>



## 5. SuperAgent



