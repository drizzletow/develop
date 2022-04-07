# 一 Introduction

## 1. Web服务器

常见的两种开发模型：

- C/S（Client/Server）客户/服务器模式：客户端 需要安装专⽤的客户端软件
- B/S（Brower/Server）：建立在广域网的基础上

Web服务器是运⾏及发布Web应⽤的容器，只有将开发的Web项⽬放置到该容器中，才能使⽹络中的所 有⽤户通过浏览器进⾏访问

开发Java Web应⽤所采⽤的服务器主要是与JSP/Servlet兼容的Web服务 器，⽐较常⽤的有Tomcat、Resin、JBoss、WebSphere 和 WebLogic 等

| Web服务器 | 简介                                                         |
| --------- | ------------------------------------------------------------ |
| Tomcat    | ⼀个⼩型、轻量级的⽀持JSP和Servlet 技术的Web服务器（最流⾏、开发JSP应⽤的⾸选） |
| Resin     | Resin是Caucho公司的产品，是⼀个⾮常流⾏的⽀持Servlet和JSP的服务器、速度⾮常快 |
| JBoss     | 纯Java的EJB服务器、不包含Servlet和JSP的 Web容器，不过它可以和Tomcat完美结合 |
| WebSphere | 是IBM公司的产品，有多个系列，其中WebSphere Application Server 是基于Java 的应⽤环境 |
| WebLogic  | WebLogic 是BEA公司的产品（现在已经被Oracle收购）、同样有多个系列。<br />WebLogic ⽀持企业级的、多层次的和完全分布式的Web应⽤，并且服务器的配置简单、界⾯友好 |

<br/>



## 2. 安装Tomcat

Tomcat官网：https://tomcat.apache.org/ 

开源⼩型web服务器 ，完全免费，主要⽤于中⼩型web项⽬。常用版本：8.5 和 9.0

```bash

启动之前首先安装JDK并配置环境变量`JAVA_HOME`，

若希望Tomcat服务器可以在任意路径启动， 则需要配置环境变量`CATALINA_HOME` 

```

<br>

```bash

# Linux 下解压后，可能需要先赋予权限，如果配置了JAVA_HOME依然不能正常启动，
# 则还需要在 bin目录 的catalina.sh中添加JAVA_HOME （如下；）

sudo vim ./bin/catalina.sh

export JAVA_HOME=/usr/local/bin/jdk/jdk1.8.0_191

```



<br/>



## 3. Tomcat配置

Tomcat的⽬录简介： （ 通过url访问服务器示例: http://localhost:8080 ）

- bin：该⽬录下存放的是⼆进制可执⾏⽂件（Windows下可通过该目录下的startup.bat启动Tomcat）

- conf：配置文件的⽬录、这个⽬录下有四个很重要的⽂件：

  - `server.xml`：配置整个服务器信息（主要的配置文件）
  - `tomcat-users.xml`：存储tomcat⽤户的⽂件
  - `web.xml`：部署描述符⽂件
  - `context.xml`：对所有应⽤的统⼀配置（通常我们不会去配置它）

- lib：Tomcat的类库（⾥⾯是⼀⼤堆jar⽂件）

- logs：⽇志⽂件目录，记录了Tomcat启动和关闭的信息

- temp：存放Tomcat的临时⽂件

- webapps：存放web项⽬的⽬录，每个⽂件夹都是⼀个项⽬

  其中ROOT是⼀个特殊的项⽬，在地址栏中没有给出项⽬⽬录时，对 应的就是ROOT项⽬

- work：运⾏时⽣成的⽂件，最终运⾏的⽂件都在这⾥（通过webapps中的项⽬⽣成）

<br/>

```xml

<!-- Windows下启动信息乱码的处理方式： 在conf文件夹下的logging.properties文件修改如下语句： 
	此方法可以让其在cmd窗口中不乱码，但很可能与idea的utf8冲突，导致idea中启动Tomcat乱码...
	故而不推荐修改，使用默认的UTF-8即可
-->
java.util.logging.ConsoleHandler.encoding = GBK  （UTF-8）

```

<br/>

```xml

<!-- server.xml 常用配置： 端口、协议等 -->
<Connector port="8888" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" />

```

<br/>

```xml

<!-- tomcat-users.xml文件用来配置管理Tomcat服务器的用户与权限 -->
<role rolename="manager-gui"/> 
<user username="admin" password="123456" roles="manager-gui"/>

```



<br/>



# 二 项目资源部署

## 1. 直接部署

在tomcat中，最小的单元是应用，任何一个资源文件都必须属于某个应用（应用：tomcat的webapps下的一个目录）

所以，如果希望部署一个资源文件，那么就必须先设置一个应用，将该资源文件放置在该应用中。

![image-20220407211249850](vx_images\image-20220407211249850.png)

如图，Tomcat原本就包含了一些 项目， 例如 examples目录 就是代表一个 项目（或者说应用）

![image-20220407211847918](vx_images\image-20220407211847918.png)

<br>

```bash

# 示例：webapps下部署war项目

1. 直接将war包放到 webapps 下

2. Tomcat 会 自动将其解压，无需我们进行额外的操作

```



<br>



## 2. 虚拟映射

正常情况下，我们部署资源需要将资源文件放置在webapps目录下，如果其他目录下，则需要配置虚拟映射关系

~~~bash

# 方式一：conf/Catalina/localhost目录下，新建一个xml文件（tomcat会解析该xml文件，形成一个应用）

# xml文件的文件名会被tomcat解析成为应用名，xml文件中需要去配置应用的应用路径

```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Context docBase="D:/Temp/test1" />
```

# 访问地址：http://localhost:8080/demo1/a.txt


# 应用需要有两个属性，一个叫做应用名，一个叫做应用路径；
# 在直接部署时，应用名其实就是目录的名字；应用路径其实就是 webapps路径 + 目录名）

~~~

![QQ截图20220407195734](vx_images\QQ截图20220407195734-16493383899362.png)



**总而言之，一定要知道该资源文件在硬盘中路径，才有后续** 。 



<br/>



~~~bash

# 方式二： conf/server.xml中，在Host节点下配置一个Context节点

```xml
	<Context path="/demo2" docBase="D:/Temp/test2" />
```
~~~

![QQ截图20220407195338](vx_images\QQ截图20220407195338-16493383807361.png)



无论直接部署还是虚拟映射，tomcat首先会解析网络路径中的应用名，将其转换成应用路径，拼接出后面的部分，拿到文件的绝对路径



<br>



## 3. 请求处理流程

Tomcat请求处理流程：

```bash

1. 浏览器地址栏输入网址，首先进行域名解析，其次进行TCP连接，发起HTTP请求

2. HTTP请求到达目标机器，HTTP请求报文会被监听8080端口号的Connector接收到，
   将其解析转换成request对象，同时还会提供一个response对象

3. Connector将这两个对象传给engine，engine进一步将这两个对象传给host

4. host会根据请求的资源路径，匹配一个Context应用（tomcat启动时，会将应用解析，形成映射关系），
   根据请求资源路径中的 `应用名`，去寻找应用，找到则将这两个对象进一步传给该应用

5. 该应用拿到有效路径，会将应用的路径和该路径进行拼接，形成硬盘上的绝对路径，再查找该文件是否存在，
   如果存在，则往response里面写入文件的数据，以及写入200状态码；
   如果文件不存在，则写入404状态码

6. 最终程序返回，最终Connector读取response里面的数据，生成HTTP响应报文

```















