# 一 RocketMQ Introduction

RocketMQ是阿里巴巴开源的一个消息中间件，是一个队列模型的消息中间件，具有高性能、高可靠、高实时、分布式特点。

目前已贡献给apache

官网地址：http://rocketmq.apache.org

Github：https://github.com/apache/rocketmq

下载地址：http://rocketmq.apache.org/release_notes/release-notes-4.4.0/

参考阅读链接：RocketMQ的前世今生 https://yq.aliyun.com/articles/66129



<br>

## 1. 相关概念及功能介绍

Producer： 消息生产者，负责消息的产生，由业务系统负责产生

Consumer：消息消费者，负责消息消费，由后台业务系统负责异步消费

Topic：消息的逻辑管理单位（消息的一个属性，并且每个消息都一定有这个属性）

<br>

**异步化**：将一些可以进行异步化的操作通过发送消息来进行异步化，提高效率

具体场景：用户为了使用某个应用，进行注册，系统需要发送注册邮件并验证短信。对这两个操作的处理方式有两种：串行及并行。

什么样的操作可以异步化呢？
1. 这一步操作的执行结果不会影响到主业务的执行结果，即主业务的处理结果不依赖于这个可以异步
化的操作的执行结果
2. 耗时的操作

<br>

**限流削峰**：在高并发场景下把请求存入消息队列，利用排队思想降低系统瞬间峰值

具体场景：购物网站开展秒杀活动，一般由于瞬时访问量过大，服务器接收过大，会导致流量暴增，相关系统无法处理请求甚至崩溃。而加入消息队列后，系统可以从消息队列中取数据，相当于消息队列做了一次缓冲。

优点：
1. 请求先入消息队列，而不是由业务处理系统直接处理，做了一次缓冲,极大地减少了业务处理系统的压力；
2. 事实上，秒杀时，后入队列的用户无法秒杀到商品，这些请求可以直接被抛弃，返回活动已结束或商品已售完信息；



<br>



## 2. 单机版安装与使用

RocketMQ 是基于Java开发的，所以需要配置相应的jdk环境变量才能运行 （在windows上运行还需要配置环境变量）

```bash

Add Environment ROCKETMQ_HOME="D:\rocketmq"

```

安装：解压即安装，无需多余的操作，但默认启动的话占用内存极大，本地测试环境建议先修改相关配置

<br>

修改NameServer和Broker配置：（windows/Linux）

Windows环境下：编辑runserver.cmd 和 runbroker.cmd 文件

Linux环境则对应的是 runbroker.sh 和runserver.sh

```bash

1.runserver.sh 修改前：
JAVA_OPT="${JAVA_OPT} -server -Xms4g -Xmx4g -Xmn2g -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"

修改后：
JAVA_OPT="${JAVA_OPT} -server -Xms256m -Xmx256m -Xmn125m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m"


2.runbroker.sh 修改前：
JAVA_OPT="${JAVA_OPT} -server -Xms8g -Xmx8g -Xmn4g"

修改后：
JAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m -Xmn256m"

```

参数解释：
- Xms: 是指程序启动时初始内存大小（此值可以设置成与-Xmx相同，以避免每次GC完成后 JVM 内存重新分配）
- Xmx: 指程序运行时最大可用内存大小，程序运行中内存大于这个值会 OutOfMemory
- Xmn: 年轻代大小（整个JVM内存大小 = 年轻代 + 年老代 + 永久代）

<br>



启动RocketMQ：首先启动注册中心nameserver，再启动RocketMQ服务，也就是broker

```bash

# start nameserver

start mqnamesrv.cmd             # win

sh ./mqnamesrv                  # linux
nohup sh mqnamesrv &

# start broker

start mqbroker.cmd -n 127.0.0.1:9876 autoCreateTopicEnable=true  # win

sh ./mqbroker -n localhost:9876 autoCreateTopicEnable=true       # linux
nohup sh mqbroker -n localhost:9876 autoCreateTopicEnable=true & 


############################ Linux使用后台启动方式时查看日志 ########################
### check whether Name Server is successfully started
$ tail -f ~/logs/rocketmqlogs/namesrv.log
The Name Server boot success...

### check whether Broker is successfully started, eg: Broker's IP is 192.168.1.2, Broker's name is broker-a
$ tail -f ~/logs/rocketmqlogs/broker.log
The broker[broker-a, 192.169.1.2:10911] boot success...

```

注意：`autoCreateTopicEnable=true` 这个设置表示开启自动创建topic功能，真实生产环境不建议开启。

<br>



**No route info of this topic, xxx** : 

终端出现上述错误日志，表示rocketMQ中没有创建这个topic,表示开启autoCreateTopicEnable失效了，这个时候需要手动创建topic，还是进入bin目录，执行下列命令，然后重新启动一下程序即可。

```bash 

# linux
sh ./mqadmin updateTopic -n localhost:9876 -b localhost:10911 -t topicName

# win
mqadmin updateTopic -n localhost:9876 -b localhost:10911 -t topicName

```

rocketmq服务关闭：

关闭namesrv服务：`sh bin/mqshutdown namesrv` 

关闭broker服务 ：`sh bin/mqshutdown broker` 



<br>



## 3. 使用Docker安装









<br>



## 4. SpringBoot整合使用



```java

// 延迟级别
// 1s 5s 10s 30s 1m 2m 3m 4m 5m 6m 7m 8m 9m 10m 20m 30m 1h 2h
// 1  2  3   4   5  6  7  8  9  10 11 12 13 14  15  16  17 18

```





<br>



# 二 RocketMQ集群环境部署







<br>

