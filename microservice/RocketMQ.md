# 一 RocketMQ Introduction

RocketMQ是阿里巴巴开源的一个消息中间件，是一个队列模型的消息中间件，具有高性能、高可靠、高实时、分布式特点。

目前已贡献给apache

官网地址：http://rocketmq.apache.org

Github：https://github.com/apache/rocketmq

[README · Apache RocketMQ开发者指南 (itmuch.com)](https://www.itmuch.com/books/rocketmq/)



下载地址：http://rocketmq.apache.org/release_notes/ (注意下载 bin-release 结尾的文件)

参考阅读链接：RocketMQ的前世今生 https://yq.aliyun.com/articles/66129



<br>

## 1. 基础概念及功能介绍

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



**MQ的优点和缺点**：

优点：异步处理、解耦、削峰、数据分发

缺点包含以下几点：

- **系统可用性降低** ：系统引入的外部依赖越多，系统稳定性越差。一旦MQ宕机，就会对业务造成影响

  如何保证MQ的高可用？

- **系统复杂度提高**：MQ的加入大大增加了系统的复杂度，以前系统间是同步的远程调用，现在是通过MQ进行异步调用

  如何保证消息没有被重复消费？怎么处理消息丢失情况？那么保证消息传递的顺序性？

- **一致性问题**： 例如：A系统处理完业务，通过MQ给B、C、D三个系统发消息数据，如果B系统、C系统处理成功，D系统处理失败。如何保证消息数据处理的一致性？



<br>



## 2. 单机版安装与使用

RocketMQ 是基于Java开发的，所以需要配置相应的jdk环境变量才能运行 （在windows上运行还需要配置环境变量）

```bash

Add Environment ROCKETMQ_HOME="D:\Develop\env\rocketmq"

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

终端出现上述错误日志，表示rocketMQ中没有创建这个topic,表示 `autoCreateTopicEnable` 失效了，这个时候需要手动创建topic，进入bin目录，执行下列命令，然后重新启动一下程序即可。

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



# 二 RocketMQ的概念模型

## 1. 消息发送规则及分发

### Topic和MessageQueue

RocketMQ中，是基于多个Message Queue来实现类似于kafka的分区效果。如果一个Topic要发送和接收的数据量非常大，需要能支持增加并行处理的机器来提高处理速度，这时候一个Topic可以根据需求设置一个或多个Message Queue。

Topic有了多个Message Queue 后，消息可以并行地向各个Message Queue发送，消费者也可以并行地从多个Message Queue读取消息并消费。

<br>



### MessageQueueSelector

那么一个消息会发送到哪个Message Queue上呢，这个就需要我们的路由分发策略了。在Send的众多重载方法中，有这样一个参数 MessageQueueSelector。

```java

public void send(Message msg, MessageQueueSelector selector, Object arg, SendCallback sendCallback, long timeout) throws MQClientException, RemotingException, InterruptedException {
    this.defaultMQProducerImpl.send(msg, selector, arg, sendCallback, timeout);
}

```

RocketMQ中已经帮我们实现了三个实现类：

- SelectMessageQueueByHash（默认）：它是一种不断自增、轮询的方式。
- SelectMessageQueueByRandom：随机选择一个队列。
- SelectMessageQueueByMachineRoom：返回空，没有实现。

如果上面这几个不能满足我们的需求，还可以自定义MessageQueueSelector，作为参数传进去：

```java
SendResult sendResult = producer.send(msg, new MessageQueueSelector() {
@Override
public MessageQueue select(List<MessageQueue> mqs, Message msg, Object arg) {
               Integer id = (Integer) arg;
               int index = id % mqs.size();
               return mqs.get(index);
       }
}, orderId);
```

<br>



## 2. 延迟消息和顺序消息

**延迟消息**：

很多时候，我们村会在这样的业务场景：`在一段时间之后，完成一个工作任务`的需求，例如：滴滴打车订单完成之后，如果用户一直不评价，48小时会将自动评价为5星；外卖下单30分钟不支付自动取消等等。这种问题的解决方案有很多种，其中一种就是用RocketMQ的延迟队列来实现，但是开源版本功能被阉割了，只能支持特定等级的消息，商业版可以任意指定时间。

```java
msg.setDelayTimeLevel(2); // 5秒钟
```

比如leve=2代表5秒，一共支持18个等级，延迟的级别配置在代码MessageStoreConfig中：

```java

private String messageDelayLevel = "1s 5s 10s 30s 1m 2m 3m 4m 5m 6m 7m 8m 9m 10m 20m 30m 1h 2h";

// 延迟级别
// 1s 5s 10s 30s 1m 2m 3m 4m 5m 6m 7m 8m 9m 10m 20m 30m 1h 2h
// 1  2  3   4   5  6  7  8  9  10 11 12 13 14  15  16  17 18

```

Spring Boot中可以这样使用：

```java
rocketMQTemplate.syncSend(topic,message,1000,2);// 5秒钟
```

<br>



**顺序消息**：

一道很经典的面试题，如何保证消息的有序性？思路是，需要保证顺序的消息要发送到同一个message queue中。其次，一个message queue只能被一个消费者消费，这点是由消息队列的分配机制来保证的。最后，一个消费者内部对一个mq的消费要保证是有序的。**我们要做到生产者 - message queue - 消费者之间是一对一对一的关系。**

具体操作过程如下：

1. 生产者发送消息的时候，到达Broker应该是有序的。所以对于生产者，不能使用多线程异步发送，而是顺序发送。
2. 写入Broker的时候，应该是顺序写入的。也就是相同主题的消息应该集中写入，选择**同一个Message Queue**，而不是分散写入。

要达到这个效果很简单，只需要我们在发送的时候传入相同的hashKey，就会选择同一个队列。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8714f164d37746ae9aed355a069ab458~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 3. 消费者消费的时候只能有一个线程，否则由于消费的速率不同，有可能出现记录到数据库的时候无序。 在Spring Boot中，consumeMode设置为ORDERLY，在Java API中，传入MessageListenerOrderly的实现类即可。

```java
consumer.registerMessageListener(new MessageListenerOrderly() {
复制代码
```

当然顺序消费会带来一些问题：

1. 遇到消息失败的消息，无法跳过，当前队列消费暂停
2. 降低了消息处理的性能




<br>



## 3. RocketMQ事务消息

分布式事务有很多种解决方案，其中一种就是使用RocketMQ的事务消息来达到**最终一致性**。

下面是RocketMQ官网的一张流程图， [rocketmq.apache.org/rocketmq/th…](https://link.juejin.cn?target=http%3A%2F%2Frocketmq.apache.org%2Frocketmq%2Fthe-design-of-transactional-message%2F)  . 

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fc3ca150bda54497bb6402487f587100~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

1. 生产者向RocketMQ服务端发送半消息，什么叫半消息呢，就是暂不能投递消费者的消息，发送方已经将消息成功发送到了MQ服务端，此时消息被标记为**暂不能投递**状态，需要等待生产者对该消息的**二次确认**。
2. MQ服务端给生产者发送ack，告诉生产者半消息已经成功收到了。
3. 发送方开始执行本地数据库事务的逻辑。
4. 执行完成以后将结果告诉MQ服务端，本地事务执行成功就告诉commint，MQ Server收到commit后则将半消息状态置为**可投递**，consumer最终将收到该消息；本地事务执行失败则发送rollback，MQ Server收到rollback以后则删除半消息，订阅费将不会收到该条消息。
5. 未收到第4步的确认信息时，回查事务状态。**消息回查：** 因为网络闪断、生产者重启等原因，RocketMQ 的发送方会提供一个反查事务状态接口，如果一段时间内半消息没有收到任何操作请求，那么 Broker 会通过反查接口得知发送方事务是否执行成功。
6. 发送方收到消息回查后，需要检查对应消息的本地事务执行的最终结果。
7. 发送方根据检查本地事务的最终状态再次提交二次确认，发送commit或者rollback。

上述就是整个事务消息的执行流程，下面我们来看下如何在代码中操作。 RocketMQ中提供了一个TransactionListener接口，我们需要实现它，然后在executeLocalTransaction方法中实现执行本地事务逻辑。

```java
    @Override
    public LocalTransactionState executeLocalTransaction(Message msg, Object arg) {
        //local transaction process,return rollback,commit or unknow
        log.info("executeLocalTransaction:"+JSON.toJSONString(msg));
        return LocalTransactionState.UNKNOW;
    }
复制代码
```

这个方法必须返回一个状态，rollback，commit或者unknow，返回unknow之后，因为不确定到底事务有没有成功，Broker会主动发起对事务执行结果的查询，所以还要再实现一个checkLocalTransaction回查方法。

```java
    @Override
    public LocalTransactionState checkLocalTransaction(MessageExt msg) {
       log.info("checkLocalTransaction:"+JSON.toJSONString(msg));
       return LocalTransactionState.COMMIT_MESSAGE;
    }
复制代码
```

默认回查总次数是15次，第一次回查的间隔是6s，后续每次间隔60s。最后在生产者发送的时候指定下事务监听器即可。 ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/93761e2f448b4db0ab884586f8935270~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 



<br>



## 4. Broker存储理念

## Broker

### 物理存储

我们进入到RocketMQ存储的文件夹看一下，这个目录是我们在安装的时候指定的。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/91f4a749e90b49baa2889a969b5d57c1~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 下面依次介绍下这几个文件夹的作用：

1. checkpoint：文件检查点，存储commitlog、consumequeue、indexfile最后一次刷盘时间或时间戳。
2. commitlog：消息存储目录，一个文件集合，每个默认文件1G大小，当第一个文件写满了，第二个文件会以初始量命名。比如起始偏移量是1073741824，第二个文件名为00000000001073741824，以此类推。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/188193ced1cf46adb123a5fce44a253f~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

1. config：运行时的配置信息，包含主题消息过滤信息、集群消费模式消息消费进度、延迟消息队列拉取进度、消息消费组配置信息、topic配置属性等。
2. consumequeue：消息消费队列存储目录，我们可以看到在consumequeue文件夹下是按topic的名字建文件夹，在每一个topic下面又是按message queue的编号建文件夹，在每个message queue文件夹下就是存放消息在commit log的偏移量以及大小和Tag属性。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f9fd0cdc2c074e3da3d1b41790d7acd6~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 5. index：消息索引文件存储目录，在前面使用java api发送消息的时候，我们看到会传入一个keys的参数，它是用来检索消息的。所以如果出现keys，服务端就会创建索引文件，以空格分割的每个关键字都会产生一个索引。单个IndexFile可以保存2000W个索引，文件固定大小约为400M。**索引使用的是哈希索引，所以key尽量设置为唯一不重复。**

### 存储理念

我们来看下RocketMQ官网的说明，[rocketmq.apache.org/rocketmq/ho…](https://link.juejin.cn?target=http%3A%2F%2Frocketmq.apache.org%2Frocketmq%2Fhow-to-support-more-queues-in-rocketmq%2F) ，我们来导读一下，首先是说kafka为什么不能支持更多的分区，然后说在RocketMQ中我们是如何支持更多分区的。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8bf43c7299d54150a5df3c8b50ff0337~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

1. 每个分区存储整个消息数据。虽然每个分区被有序地写入磁盘，但随着并发写入分区数量的增加，从操作系统的角度来看，写入变得随机。
2. 由于数据文件分散，难以使用Linux IO Group Commit机制。

所以RocketMQ干脆另辟蹊径，设计了一种新的文件文件存储方式，就是所有topic的所有消息全部写在同一个文件中，这样就能够保证绝对的顺序写。当然消费的时候就复杂了，要到一个巨大的commitlog中去查找消息，我们不可能遍历所有消息吧，这样效率太慢了。

那怎么办呢？这个就是上面提到的consume queue，它把consume group消费的topic的最后消费到的offset存储在里面。当我们消费的时候，先从consume queue读取持久化消息的起始物理位置偏移量offset、大小size和消息tag的hashcode值，随后再从commitlog中进行读取待拉取消费消息的真正实体内容部分。

consume queue可以理解为消息的索引，它里面没有消息，当然这样的存储理念也不是十全十美，**对于commitlog来说，写的时候虽然是顺序写，但是读的时候却变成了完全的随机读；读一条消息先会读consume queue，再读commit log，这样增加了开销。**

### 文件清理策略

跟kalka一样，commit log的内容在**消费**之后是不会删除，这样做有两个好处，一个是可以被多个consumer group重复消费，只要修改consumer group，就可以从头开始消费，每个consumer group维护自己的offset；另一个是支持消息回溯，随时可以搜索。

但是如果不清理文件的话，文件数量不断地增加，最终会导致磁盘可用空间越来越少，所以RocketMQ会将commitLog、consume queue这些过期文件进行删除，默认是超过**72个小时**的文件。这里会启动两个线程去跑。

```java
    private void cleanFilesPeriodically() {
        this.cleanCommitLogService.run();
        this.cleanConsumeQueueService.run();
    }
复制代码
```

过期文件选出来以后，什么时候去清理呢，有两种情况。一种是通过定时任务，**每天凌晨四点**去删除这些文件。第二种是磁盘使用空间**超过75%** 了，这时候已经火烧眉毛了，我还等到你四点干嘛，**立即马上**就清理了。

如果情况更严重，如果磁盘空间使用率超过**85%**，会开始批量清理文件，**不管有没有过期**，直到空间充足；如果磁盘使用率超过**90%**，会**拒绝**消息写入。

### 零拷贝

大家都知道RocketMQ的消息是存储在磁盘上的，但是怎么还能做到这么低的延迟和这么高的吞吐量，其中的一个奥秘就是使用到了零拷贝技术。

首先和大家介绍一下page Cache的概念，这个是操作系统层面的，CPU如果要读取或者操作磁盘上的数据，必须要把磁盘的数据加载到内存中，这个加载的大小有一个固定的单位，叫做Page。x86的linux中一个标准的页大小是4kb。如果要提升磁盘的访问速度，或者说减少磁盘的IO，可以把访问过的Page在内存中缓存起来，这个内存的区域就叫做Page Cache。

下次处理IO请求的时候，先到Page Cache中查找，找到了就直接操作，没找到再到磁盘中去找。当然Page Cache本身也会对数据进行预读，对于每个文件的第一个读请求操作，系统也会将所请求的页的相邻后几个页一起读出来。但是这里还有个问题，我们知道虚拟内存分为内核空间和用户空间，Page Cache属于内核空间，用户空间访问不了，还需要从内核空间拷贝到用户空间缓冲区，这个copy的过程就降低了数据访问的速度。

为了解决这个问题，就产生了零拷贝技术，**干脆把Page Cache的数据在用户空间中做一个地址映射，这样用户进行就可以通过指针操作直接读写Page Cache，不再需要系统调用（例如read()）和内存拷贝。RocketMQ中具体的实现是使用mmap（memory map，内存映射），而kafka用的是sendfile。** ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/390a3cff83f34a9985f0a6368041a585~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

## 消费者

### 消费端的负载均衡与rebalance

和kafka一样，消费端也会针对Message Queue做负载均衡，使得每个消费者能够合理的消费多个分区的消息。消费者**挂了**，消费者**增加**，这时候就会用到我们的rebalance。

在RebalanceImpl.class的277行有rebalance的策略

```java
      AllocateMessageQueueStrategy strategy = this.allocateMessageQueueStrategy;

      List<MessageQueue> allocateResult = null;
      try {
               allocateResult = strategy.allocate(this.consumerGroup,
                            this.mQClientFactory.getClientId(),
                            mqAll,
                            cidAll);
           } catch (Throwable e) {
                log.error("AllocateMessageQueueStrategy.allocate Exception. allocateMessageQueueStrategyName={}", strategy.getName(),e);
                return;
           }
复制代码
```

AllocateMessageQueueStrategy有`6种`实现的策略，也可以自定义实现，在消费者端指定即可。

```java
consumer.setAllocateMessageQueueStrategy();
复制代码
```

- AllocateMessageQueueAveragely：平均分配算法（默认）

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dd0d83379dbd498c8579f01bf2356cbe~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- AllocateMessageQueueAveragelyByCircle：环状分配消息队列

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0f4d9408a27d48d5909cb4103fc9a32f~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

- AllocateMessageQueueByConfig：按照配置来分配队列，根据用户指定的配置来进行负载
- AllocateMessageQueueByMachineRoom：按照指定机房来配置队列
- AllocateMachineRoomNearby：按照就近机房来配置队列
- AllocateMessageQueueConsistentHash：一致性hash，根据消费者的cid进行

**队列的数量尽量要大于消费者的数量。**

### 重试与死信队列

在消费者端如果`出现异常`，比如数据库不可用、网络出现问题、中途断电等等，这时候返回给Broker的是RECONSUME_LATER，表示稍后重试。这个时候消息会发回到Broker，进入到RocketMQ的重试队列中。服务端会为consumer group创建一个名字为%RETRY%开头的重试队列。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8d7ae5ddf2b2433087450344913adc83~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 重试队列过一段时间后再次投递到这个ConsumerGroup，如果还是异常，会再次进入到重试队列。重试的时间间隔会不断衰减，从10秒开始直到2个小时：10s 30s 1m 2m 3m 4m 5m 6m 7m 8m 9m 10m 20m 30m 1h 2h，最多重试16次。

而如果一直这样重复消费都持续失败到一定次数（默认16次），就会投递到DLQ**死信队列**。Broker会创建一个死信队列，死信队列的名字是`%DLQ%+ConsumerGroupName`，应用可以监控死信队列来做人工干预。**一般情况下我们在实际生产中是不需要重试16次，这样既浪费时间又浪费性能，理论上当尝试重复次数达到我们想要的结果时如果还是消费失败，那么我们需要将对应的消息进行记录，并且结束重复尝试。**

源码在jackxu/SimpleConsumer.java

## MQ选型分析

下面列出市面上常见的三种MQ的分析对比，供大家在项目中实际使用的时候参考对比： ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/228dd1d21e464a3bbcb6c488ceaa1cd5~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 



<br>



# 三 RocketMQ集群环境部署

[RocketMQ高可用架构及二主二从异步集群部署 - 掘金 (juejin.cn)](https://juejin.cn/post/6929500274457313293)

## RocketMQ发展历史

RocketMQ是一个由阿里巴巴开源的消息中间件， 2012年开源，2017年成为apache顶级项目。RocketMQ在阿里内部应用是非常广泛的，阿里内部的几千个应用都运行在RocketMQ之上，双十一期间需要处理亿万级别的消息，TPS可以达到几十万。目前支持Java、C/C++，Python、Go四种语言访问。

RocketMQ现在有两个版本，一个是社区开源版，一个是商业的云服务版（AliwareMQ）。最新版本：4.8.0（本文演示版本）。

它的核心设计借鉴了Kafka，所以我们在学习RocketMQ的时候，会发现很多和kafka相同的特性，但是在某些功能上和kafka又有较大的差异，它有以下一些特性：

1. 支持集群模型、负载均衡、水平扩展能力
2. 亿级别消息堆积能力
3. 采用零拷贝的原理，顺序写盘，随机读
4. 底层通信框架采用Netty NIO
5. NameServer代替Zookeeper，实现服务寻址和服务协调
6. 消息失败重试机制、消息可查询
7. 强调集群无单点，可扩展，任意一点高可用，水平可扩展
8. 经过多次双十一的考验

## 高可用架构

RocketMQ天生对集群的支持非常好，它有以下一些模式：

（1）单Master

优点：除了配置简单没什么优点

缺点：不可靠，该机器重启或者宕机，将要导致整个服务不可用

（2）多Master

优点：配置简单，性能最高

缺点：可能会有少量消息丢失（配置相关），单台机器重启或宕机期间，该机器下未被消费的消息在机器恢复前不可订阅，影响消息实时性

（3）多Master多Slave，每个Master配一个Slave，有多对Master-Slave，集群采用异步复制方式，主备有短暂消息延迟，毫秒级

优点：性能同多Master几乎一样，实时性高，主备间切换对应用透明，不需人工干预

缺点：Master宕机或磁盘损坏时会有少量消息丢失

（4）多Master多Slave，每个Master配一个Slave，有多对Master-Slave，集群采用同步双写方式，主备都写成功，向应用返回成功

优点：服务可用性与数据可用性非常高

缺点：性能比异步集群略低，当前版本主宕备不能自动切换为主

```
本文采用的是二主二从安装模式，即第四种多Master多Slave
```

## 二主二从异步集群安装

### 端口规划

首先我买了两台云服务器，平时我会用来学习安装一些中间件，比较方便，大家有条件的话也可以买下，当然也可以通过在本地安装虚拟机的方式来操作。

![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f5e55fd7cf614ce2985d0b3eb9d55f75~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

接下来我要通过这两台服务器来实现二主二从的安装，首先对它们的端口进行一下规划

```
第一台机器  42.192.77.73
端口规划：
9876     NameServer1
10910    BrokerA-master
10921    BrokerB-slave

第二台机器  39.103.144.86
端口规划：
9876     NameServer2
10920    BrokerB-master
10911    BrokerA-slave
复制代码
```

画图看上去更加清晰明了一些 ![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a518a0d430374215a151bd2ebd9496a4~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### 下载

从官网 [rocketmq.apache.org/](https://link.juejin.cn?target=http%3A%2F%2Frocketmq.apache.org%2F) 进去获得最新的下载地址，红框里标注出来的 ![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b601a03e0dbd47689c7cef371f971406~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

这里的地址都可以，下载下来

```
cd /jackxu
wget https://mirror.bit.edu.cn/apache/rocketmq/4.8.0/rocketmq-all-4.8.0-bin-release.zip
复制代码
```

下载好后解压，改个名字

```
unzip rocketmq-all-4.8.0-bin-release.zip
mv unzip rocketmq-all-4.8.0-bin-release.zip rocketmq
复制代码
```

### 配置第一台机器

在两台机器上都下载、解压好。在rocketmq/conf目录下，有三种建议配置模式：

2m-2s-async(2主2从异步) —— 本文采用这种

2m-2s-sync (2主2从同步)

2m-noslave (2主)

现在需要修改两台机器上2m-2s-async这个目录中的文件。在42.192.77.73机器上修改broker-a.properties

```
cd /jackxu/rocketmq/conf/2m-2s-async
vim  broker-a.properties
复制代码
```

修改集群名字

```
brokerClusterName=jackxu-cluster
复制代码
```

增加的内容

```
#Broker 对外服务的监听端口
listenPort=10910
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#nameServer地址，分号分割
namesrvAddr=39.103.144.86:9876;42.192.77.73:9876
#存储路径
storePathRootDir=/jackxu/rocketmq/store/broker-a
#commitLog 存储路径
storePathCommitLog=/jackxu/rocketmq/store/broker-a/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/jackxu/rocketmq/store/broker-a/consumequeue
#消息索引存储路径
storePathIndex=/jackxu/rocketmq/store/broker-a/index
#checkpoint 文件存储路径
storeCheckpoint=/jackxu/rocketmq/store/checkpoint
#abort 文件存储路径
abortFile=/jackxu/rocketmq/store/abort
复制代码
```

修改broker-b-s.properties

```
vim  broker-b-s.properties
复制代码
```

修改集群名字

```
brokerClusterName=jackxu-cluster
复制代码
```

增加的内容

```
#Broker 对外服务的监听端口
listenPort=10921
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#nameServer地址，分号分割
namesrvAddr=39.103.144.86:9876;42.192.77.73:9876
#存储路径
storePathRootDir=/jackxu/rocketmq/store/broker-b-s
#commitLog 存储路径
storePathCommitLog=/jackxu/rocketmq/store/broker-b-s/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/jackxu/rocketmq/store/broker-b-s/consumequeue
#消息索引存储路径
storePathIndex=/jackxu/rocketmq/store/broker-b-s/index
#checkpoint 文件存储路径
storeCheckpoint=/jackxu/rocketmq/store/checkpoint
#abort 文件存储路径
abortFile=/jackxu/rocketmq/store/abort
复制代码
```

### 配置第二台机器

在39.103.144.86机器上修改broker-b.properties

```
cd /jackxu/rocketmq/conf/2m-2s-async
vim  broker-b.properties
复制代码
```

修改集群名字

```
brokerClusterName=jackxu-cluster
复制代码
```

增加的内容

```
#Broker 对外服务的监听端口
listenPort=10920
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#nameServer地址，分号分割
namesrvAddr=39.103.144.86:9876;42.192.77.73:9876
#存储路径
storePathRootDir=/jackxu/rocketmq/store/broker-b
#commitLog 存储路径
storePathCommitLog=/jackxu/rocketmq/store/broker-b/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/jackxu/rocketmq/store/broker-b/consumequeue
#消息索引存储路径
storePathIndex=/jackxu/rocketmq/store/broker-b/index
#checkpoint 文件存储路径
storeCheckpoint=/jackxu/rocketmq/store/checkpoint
#abort 文件存储路径
abortFile=/jackxu/rocketmq/store/abort
复制代码
```

修改broker-a-s.properties

```
vim  broker-a-s.properties
复制代码
```

修改集群名字

```
brokerClusterName=jackxu-cluster
复制代码
```

增加的内容

```
#Broker 对外服务的监听端口
listenPort=10911
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#nameServer地址，分号分割
namesrvAddr=39.103.144.86:9876;42.192.77.73:9876
#存储路径
storePathRootDir=/jackxu/rocketmq/store/broker-a-s
#commitLog 存储路径
storePathCommitLog=/jackxu/rocketmq/store/broker-a-s/commitlog
#消费队列存储路径存储路径
storePathConsumeQueue=/jackxu/rocketmq/store/broker-a-s/consumequeue
#消息索引存储路径
storePathIndex=/jackxu/rocketmq/store/broker-a-s/index
#checkpoint 文件存储路径
storeCheckpoint=/jackxu/rocketmq/store/checkpoint
#abort 文件存储路径
abortFile=/jackxu/rocketmq/store/abort
复制代码
```

### 创建数据目录

第一台机器42.192.77.73执行，只需要执行一次

```
mkdir -p /jackxu/rocketmq/store/broker-a /jackxu/rocketmq/store/broker-a/consumequeue /jackxu/rocketmq/store/broker-a/commitlog /jackxu/rocketmq/store/broker-a/index /jackxu/rocketmq/logs /jackxu/rocketmq/store/broker-b-s /jackxu/rocketmq/store/broker-b-s/consumequeue /jackxu/rocketmq/store/broker-b-s/commitlog /jackxu/rocketmq/store/broker-b-s/index
复制代码
```

第二台机器39.103.144.86执行，只需要执行一次

```
mkdir -p /jackxu/rocketmq/store/broker-a-s /jackxu/rocketmq/store/broker-a-s/consumequeue /jackxu/rocketmq/store/broker-a-s/commitlog /jackxu/rocketmq/store/broker-a-s/index /jackxu/rocketmq/logs /jackxu/rocketmq/store/broker-b /jackxu/rocketmq/store/broker-b/consumequeue /jackxu/rocketmq/store/broker-b/commitlog /jackxu/rocketmq/store/broker-b/index
复制代码
```

### 启动两个NameServer

在两台机器分别执行，& 表示在后台运行，默认情况下，nameserver监听的是9876端口

```
nohup sh /jackxu/rocketmq/bin/mqnamesrv >/jackxu/rocketmq/logs/mqnamesrv.log 2>&1 &
复制代码
```

查看日志

```
tail -f /jackxu/rocketmq/logs/mqnamesrv.log
复制代码
```

### 启动Broker

启动的时候按照下面的顺序来，-c 是指定broker的配置文件

1、启动73的A主

```
nohup sh /jackxu/rocketmq/bin/mqbroker -c /jackxu/rocketmq/conf/2m-2s-async/broker-a.properties > /jackxu/rocketmq/logs/broker-a.log 2>&1 &
复制代码
```

2、启动86的A从

```
nohup sh /jackxu/rocketmq/bin/mqbroker -c /jackxu/rocketmq/conf/2m-2s-async/broker-a-s.properties > /jackxu/rocketmq/logs/broker-a-s.log 2>&1 &
复制代码
```

3、启动86的B主

```
nohup sh /jackxu/rocketmq/bin/mqbroker -c /jackxu/rocketmq/conf/2m-2s-async/broker-b.properties > /jackxu/rocketmq/logs/broker-b.log 2>&1 &
复制代码
```

4、启动73的B从

```
nohup sh /jackxu/rocketmq/bin/mqbroker -c /jackxu/rocketmq/conf/2m-2s-async/broker-b-s.properties > /jackxu/rocketmq/logs/broker-b-s.log 2>&1 &
复制代码
```

查看日志

```
tail -f /jackxu/rocketmq/conf/2m-2s-async/broker-a.properties
tail -f /jackxu/rocketmq/conf/2m-2s-async/broker-a-s.properties
tail -f /jackxu/rocketmq/conf/2m-2s-async/broker-b.properties
tail -f /jackxu/rocketmq/conf/2m-2s-async/broker-b-s.properties

复制代码
```

### 检查是否启动成功

输入jps命令，一共四个进程没问题

![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/412214e005d04aafa3b73deaec662181~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

但是大多数情况下不会这么顺利，我在安装中有一些坑点：

1、没有安装jdk，因为这是我新的服务器，上面是没有jdk环境的，大家知道rocketmq是用java写的，所以需要有java环境才能运行，包括jps命令就是查看java进程 ![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/88333bea1fbc4978b8f81a8a54eb5959~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 2、内存不足，因为默认的配置文件设置了很大的内存，但是我的机器只有1核2G，肯定是不够的，所以在启动的时候会报内存不足 ![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8dcb2ced758845449b5b5466a0b1f892~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 解决办法就是修改配置文件

```
vim /jackxu/rocketmq/bin/runserver.sh
vim /jackxu/rocketmq/bin/runbroker.sh
复制代码
```

把NameServer和Broker的内存大小都改小一点，然后重新启动即可 ![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9cee5233c03e44179c6bd2ba2f43e812~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### 关闭命令

停止服务的时候需要注意，要先停止broker，其次停止nameserver。

```
cd /jackxu/rocketmq/bin

sh mqshutdown namesrv
sh mqshutdown broker
复制代码
```

## web控制台安装

与kafka不同的是，rocket官方提供了一个可视化控制台，大家可以在这里下载 [github.com/apache/rock…](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fapache%2Frocketmq-externals) ，这个是rocketmq的扩展，里面不仅包含控制台的扩展，也包含对大数据flume、hbase等组件的对接和扩展。

### 下载

下载源码，一般下载速度会比较慢，等不及的话可以去网盘下载链接：

[pan.baidu.com/s/1-eg5JK8T…](https://link.juejin.cn?target=https%3A%2F%2Fpan.baidu.com%2Fs%2F1-eg5JK8Te9uVAwADZeO_Dw)   提取码：jack

```
cd /jackxu
wget https://github.com/apache/rocketmq-externals/archive/master.zip
复制代码
```

解压

```
unzip master.zip
复制代码
```

### 修改配置文件

```
cd /jackxu/rocketmq-externals-master/rocketmq-console/src/main/resources
vim application.properties
复制代码
```

这是一个spring boot项目，我们需要修改里面的参数

```
//修改端口号：
server.port=7298
//修改name server地址（多个地址用英文分号隔开）
rocketmq.config.namesrvAddr=39.103.144.86:9876;42.192.77.73:9876
复制代码
```

### 打包

打成一个jar包，`这里需要先安装maven，编译慢的话可以替换成淘宝的镜像`

```
cd /jackxu/rocketmq-externals-master/rocketmq-console
mvn clean package -Dmaven.test.skip=true
复制代码
```

### 启动jar包

```
cd target
java -jar rocketmq-console-ng-2.0.0.jar
复制代码
```

### 访问

访问一下 [http://42.192.77.73:7298/](https://link.juejin.cn?target=http%3A%2F%2F42.192.77.73%3A7298%2F) ，可以看到都已经启动成功了 ![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dc86a56bcb1c437da0058d29fe8ed13e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### 踩坑点

这里有两个踩坑点，在启动的时候会报错

（1）spring boot启动的时候报连接不上39.103.144.86:9876;42.192.77.73:9876，这里我的第一反应是防火墙的原因，关闭一下

```
systemctl disable firewalld.service 
复制代码
```

再次启动还是不行，然后我的第二个反应是端口没有开放，telnet一下

```
telnet 42.192.77.73 9876
复制代码
```

果然telnet不通，原因是这样的，我安装在云服务器上，默认端口是不开放的，需要到控制台打开，这也算是一个经验吧。 ![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/50a2d6637c65442592dc9940db0c441b~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) （2）再次启动的时候又报了另一个错误，连接不上172.26.182.88:9876，当时我就奇怪了，我写的地址里没有这个地址啊，怎么在连接它，而且这个IP看上去又像是内网地址，后来我打开阿里云控制台一看，果真是这台机器的内网地址，然后我又百度了一番，大概原因就是RocketMQ是阿里开源的，而那台机器又是阿里云的机器，它的源码里应该是优先连接到阿里云的内网地址，网上的做法是在配置文件里面显式的加上公网地址即可解决。

```
#新增公网IP
brokerIP1=39.103.144.86
复制代码
```

### 控制台介绍

- 运维：主要是设置nameserver和配置vipchannel。
- 驾驶舱：控制台的dashboard，可以分别按broker和主题来查看消息的数量和趋势。
- 集群：整个RocketMQ的集群情况，包括分片，编号，地址，版本，消息生产和消息消费的TPS等，这个在做性能测试的时候可以作为数据指标。
- 主题：即topic，可以新增/更新topic，也可以查看topic的信息，如状态，路由，消费者管理和发送消息等。
- 消费者：可以在当前broker中查看/新建消费者group，包括消费者信息和消费进度。
- 生产者：可以在当前broker中查看生产组下的生产者group，包括生产者信息和生产者状态。
- 消息：可以按照topic，messageID，messageKey分别查询具体的消息。
- 用户中心：切换语言和登录相关（登录需要在console的配置中打开对应配置，默认不需要登录）。

其中最常用的是集群，主题，消费者和消息这四部分。

## 配置文件说明

下面介绍一下安装RocketMQ配置文件里面的属性

首先是集群名字相同，上面四台机器的集群名字都叫 brokerClusterName=jackxu-cluster，其次是连接到相同的NameServer，namesrvAddr=39.103.144.86:9876;42.192.77.73:9876。在配置文件中brokerId=0代表master，brokerId=1代表slave。

在配置文件中还有这两个属性

![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ee3c1309af2547bcaec2c3c70a3516d6~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

brokerRole在master broker可以配置成SYNC_MASTER或者ASYNC_MASTER，在slave broker统一配置成SLAVE

| 值           | 说明                 | 含义                                                         |
| ------------ | -------------------- | ------------------------------------------------------------ |
| ASYNC_MASTER | 主从异步复制         | master写成功，返回客户端成功。拥有较低的延迟和较高的吞吐量，但是当master出现故障以后，有可能造成数据丢失。 |
| SYNC_MASTER  | 主从同步双写（推荐） | master和slave均写成功，才返回客户端成功。master挂了以后可以保证数据不丢失，但是同步复制会增加数据写入延迟，降低吞吐量。 |

flushDiskType分为ASYNC_FLUSH和SYNC_FLUSH

| 值          | 说明             | 含义                                                         |
| ----------- | ---------------- | ------------------------------------------------------------ |
| ASYNC_FLUSH | 异步刷盘（默认） | 生产者发送的每一条消息并不是立即保存到磁盘，而是暂时缓存起来，然后就返回生产者成功。随后再异步的将缓存数据保存到磁盘，有两种情况：1是定期将缓存中更新的数据进行刷盘，2是当缓存中更新的数据条数达到某一设定值后进行刷盘。这种方式会存在消息丢失（在还未来得及同步到磁盘的时候宕机），但是性能很好。默认是这种模式。 |
| SYNC_FLUSH  | 同步刷盘         | 生产者发送的每一条消息都在保存到磁盘成功后才返回告诉生产者成功。这种方式不会存在消息丢失的问题，但是有很大的磁盘IO开销，性能有一定影响。 |

流程图 ![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3761ed62a74446fcbfb637722865023e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

我们推荐的配置是异步刷盘+同步复制。

## HA与故障转移

在之前的版本中，RocketMQ只有master/slave一种部署方式，一组broker中有一个master，有0到多个slave，这种模式下提供了一定的高可用性。

master在挂了的情况下，slave仍然可以提供读服务。默认情况下，读写都在master上，如果开启了slaveReadEnable=true，slave也可以参与读负载，但是是在master积压的消息超过了物理内存的40%，才会默认转向brokerId为1的从服务器读取，具体转向哪台机器由whichBrokerWhenConsumeSlowly参数控制。

```java
org.apache.rocketmq.common.subscription.SubscriptionGroupConfig
private long whichBrokerWhenConsumeSlowly=1;
复制代码
```

由于是多主的存在，当一个master挂了以后，可以写到其他的master上。

RocketMQ 2019年3月发布的4.5.0版本中，利用Dledger技术解决了自动选主的问题。Dledger就是一个基于raft协议的commitlog存储库，也是RocketMQ实现新的高可用多副本架构的关键。它的优点是不需要引入外部组件，自动选主逻辑集成到各个节点的进程中，节点之间通过通信就可以完成选主。

架构图 ![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b930d8668a6e4f3fabbd35eb27b68f25~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 在这种情况下，commitlog是Dledger管理的，具有选主的功能。默认是不开启，如果需要开启，需要在配置文件里面添加以下配置：

```
# 是否启用DLedger
enableDLegerCommitLog=true
# DLedger Raft Group的名字
dLegerGroup=broker-a
# DLedger Group内各节点的地址和端口，至少需要3个节点
dLegerPeers=n0-192.168.44.163:10911;n1-192.168.44.164:10911;n2-192.168.44.165:10911
# 本节点id
dLegerSelfId=n0
复制代码
```

## 结语

小伙伴在学习一个中间件的时候一定要动手实践安装，首先是体验一下安装的过程氛围，了解一些参数配置，在公司里这个操作一般是由运维来完成的，虽然我们平时接触不到，但是学习还是需要的，不一定需要精，至少是要会；其次是为后面的写代码做实验做准备，发消息消费消息总得有个地方吧。最后介绍下课外读物，这个上面的安装命令非常的全，谢谢大家的观看~

> RocketMQ常用管理命令：[blog.csdn.net/gwd11549783…](https://link.juejin.cn?target=https%3A%2F%2Fblog.csdn.net%2Fgwd1154978352%2Farticle%2Fdetails%2F80829534)






<br>



# 四 Java API使用精讲



## RocketMQ的架构

> 这是在RocketMQ官网的架构图，[rocketmq.apache.org/docs/rmq-ar…](https://link.juejin.cn?target=http%3A%2F%2Frocketmq.apache.org%2Fdocs%2Frmq-arc%2F)

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/979b578a184245e39317b5de22623cf9~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 一般见到的架构图都是这样的，其中这些重要的角色需要解释下。

### Broker

RocketMQ 的服务，或者说一个进程，叫做 Broker，Broker 的作用是存储和转发消息。RocketMQ 单机大约能承受10万 QPS 的请求，为了提升 Broker 的`性能（做负载均衡）`以及`可用性（防止单点故障）`，通常会做集群部署。

跟 Kafka 或者 Redis Cluster 一样，RocketMQ 集群的每个 Broker 节点保存总数据的一部分，因为可用横向扩展。为了提高`可靠性（防止数据丢失）`，每个 Broker 可以有自己的副本（Slave）。

### Topic

Topic用于将消息按主题做划分，比如订单消息，支付消息，人员消息，`注意，跟kafka不同的是，在RocketMQ 中，Topic是一个逻辑概念，消息不是按Topic划分存储的。`

Producer 将消息发往指定的 Topic，Consumer 订阅这个 Topic 就可以收到相应的消息。Topic 跟生产者和消费者都是多对多的关系，一个生产者可以发送消息到多个 Topic，一个消费者也可以订阅多个 Topic。

### NameServer

在 rocketmq 的早版本（2.x）的时候，是没有 namesrv 组件的，用的是 zookeeper 做分布式协调和服务发现，但是后期阿里数据根据实际业务需求进行改进和优化，自组研发了轻量级的 namesrv，用于注册 Client 服务与 Broker 的请求路由工作，namesrv 上不做任何消息的位置存储，频繁操作 zookeeper 的位置存储数据会影响整体集群性能。

**为了保证高可用，NameServer 自身也可以做集群的部署，节点之间无任何信息同步。**

### Producer

生产者，拥有相同 Producer Group 的 Producer 组成一个集群， 与 Name Server 集群中的其中一个节点（随机选择）建立长连接，定期从 Name Server 取 Topic 路由信息，并向提供 Topic 服务的 Master 建立长连接，且定时向 Master 发送心跳。Producer 完全无状态，可集群部署。

RocketMQ 的生产者支持批量发送 ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/baff91d814974673b2c59dd9aa6b9ad1~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

### Consumer

消费者，接收消息进行消费的实例，拥有相同 Consumer Group 的 Consumer 组成一个集群，与 Name Server 集群中的其中一个节点（随机选择）建立长连接，定期从 Name Server 取Topic 路由信息，并向提供 Topic 服务的`Master、Slave `建立长连接，且定时向 `Master、Slave `发送心跳。Consumer 既可以从 Master 订阅消息，也可以从 Slave 订阅消息，订阅规则由 Broker 配置决定。

消费者有两种`消费方式`：一种是集群消费（消息轮询），一种是广播消费（全部收到相同副本）。

从`消费模型`来说，一种是 pull 主动拉去，另一种是 push，被动接收。但实际上 RocketMQ 都是 pull 模式，只是 push 在 pull 模式上做了一层封装，PushConsumer 会注册 MessageListener 监听器，取到消息后，唤醒 MessageListener 的 ConsumeMessage()来消费，对用户而言，感觉消息是被推送过来的。RocketMQ是基于`长轮训`来实现消息的 pull。

### Message Queue

大家知道发往某一个 Topic 的多条信息，是分布在不同的 Broker 上的，在 Kafka 里面设计了一个partition，一个 Topic 可以拆分成多个 partition，这些 partition 可以分布在不同的 Broker 上，这样就实现了数据的分片，也决定了 kafka 可以实现横向扩展。

在 RocketMQ 中只有一个存储文件，并没有像 kafka 一样按照不同的 Topic 分开存储。所以它设计了一个Message Queue 的逻辑概念，作用跟`partition类似。`

首先我们在创建 Topic 的时候会让我们指定队列数量，一个叫 writeQueueNums（写队列数量），一个叫readQueueNums（读队列数量），写队列数量决定了有几个 Message Queue，读队列数量决定了有几个线程来消费这些 Message Queue（只是用来负载的）。perm 表示队列权限，2表示W，4表示R，6表示RW。

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/eefe28a236cb40f0a72fbe5ee713717c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 这里是我们创建 topic 的时候指定的，如果我们由代码自动创建 topic 的时候默认是几个 Message Queue呢？

```java
 //服务端创建一个Topic默认8个队列，在BrokerConfig类里面
 private int defaultTopicQueueNums = 8;
 //topic不存在，生产者发送消息时创建默认4个队列，在DefaultMQProducer类里面
 private volatile int defaultTopicQueueNums = 4;
 //最终服务端创建的时候有一个判断，取小一点的值，在MQClientInstance类里面
 int queueNums = Math.min(defaultMQProducer.getDefaultTopicQueueNums(), data.getReadQueueNums());
复制代码
```

最终计算结果应该是4吧，我们找一个由代码创建的topic看下，确实是4。

![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/40732658d53b4866882520171b1235e2~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 

**写队列数量和读队列数量这两个值需要相等**，在集群模式下如果不相等，假如说writeQueueNums=6，readQueueNums=3, 那么每个 broker 上会有3个 queue 的消息是无法消费的。

**如果消费者数大于readQueueNumbs，那么会有一些消费者消费不到消息，浪费资源。**

## Java API

现在开始API的教程使用，官网提供了Java客户端API，只需要引入pom依赖就可以了。

```
      <dependency>
          <groupId>org.apache.rocketmq</groupId>
          <artifactId>rocketmq-client</artifactId>
          <version>4.7.1</version>
      </dependency>
复制代码
```

先写一个生产者Producer类：

```java
/**
 * @author jackxu
 */
public class Producer {

    public static void main(String[] args) throws MQClientException {
        //生产者组
        DefaultMQProducer producer = new DefaultMQProducer("jackxu_producer_group");
        //生产者需用通过NameServer获取所有broker的路由信息，多个用分号隔开，这个跟Redis哨兵一样
        producer.setNamesrvAddr("39.103.144.86:9876;42.192.77.73:9876");
        //启动
        producer.start();

        for (int i = 0; i < 10; i++) {
            try {
                /*Message(String topic, String tags, String keys, byte[] body)
                 Message代表一条信息，第一个参数是topic，这是主题
                第二个参数是tags，这是可选参数，用于消费端过滤消息
                第三个参数是keys，这也是可选参数，如果有多个，用空格隔开。RocketMQ可以根据这些key快速检索到消息，相当于
                消息的索引，可以设置为消息的唯一编号（主键）。*/
                Message msg = new Message("jackxu_test_topic", "TagA", "6666", ("RocketMQ Test message " + i).getBytes());
                //SendResult是发送结果的封装，包括消息状态，消息id，选择的队列等等，只要不抛异常，就代表发送成功
                SendResult sendResult = producer.send(msg);
                System.out.println("第" + i + "条send结果: " + sendResult);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
        producer.shutdown();
    }

}
复制代码
```

SendResult中，有 一个SendStatus状态，表示消息的发送状态。一共有四种状态。

1. FLUSH_DISK_TIMEOUT：表示没有在规定时间内完成刷盘（需要Broker的刷盘策略配置SYNC_FLUSH才会报这个错误）。
2. FLUSH_SLAVE_TIMEOUT：表示在主备方式下，并且Broker被设置成SYNC_MASTER方式，没有在规定时间内完成主从同步。
3. SLAVE_NOT_AVAILABLE：这个状态产生的场景和FLUSH_SLAVE_TIMEOUT类似，表示在主备方式下，并且Broker被设置成SYNC_MASTER，但是没有找到被配置成Slave的Broker。
4. SEND_OK：表示发送成功

再写一个简单消费者类SimpleConsumer：

```java
/**
 * @author jackxu
 */
public class SimpleConsumer {

    public static void main(String[] args) throws MQClientException {
        //消费者组
        DefaultMQPushConsumer consumer = new DefaultMQPushConsumer("jackxu_consumer_group");
        //消费者从NameServer拿到topic的queue所在的Broker地址，多个用分号隔开
        consumer.setNamesrvAddr("39.103.144.86:9876;42.192.77.73:9876");
        //设置Consumer第一次启动是从队列头部开始消费
        //如果非第一次启动，那么按照上次消费的位置继续消费
        consumer.setConsumeFromWhere(ConsumeFromWhere.CONSUME_FROM_FIRST_OFFSET);
        //subscribe订阅的第一个参数就是topic,第二个参数为生产者发送时候的tags，*代表匹配所有消息，
        //想要接收具体消息时用||隔开，如"TagA||TagB||TagD"
        consumer.subscribe("jackxu_test_topic", "*");
        //Consumer可以用两种模式启动，广播（Broadcast）和集群（Cluster），广播模式下，一条消息会发送给所有Consumer，
        //集群模式下消息只会发送给一个Consumer
        consumer.setMessageModel(MessageModel.BROADCASTING);
        //批量消费,每次拉取10条
        consumer.setConsumeMessageBatchMaxSize(10);
        consumer.registerMessageListener(new MessageListenerConcurrently() {
            @Override
            public ConsumeConcurrentlyStatus consumeMessage(List<MessageExt> msgs, ConsumeConcurrentlyContext context) {
                //msgs是一个List，一般是Consumer先启动，所有每次都是一条数据
                //如果Producer先启动Consumer端后启动，会积压数据，此时setConsumeMessageBatchMaxSize会生效,
                //msgs的数据就是十条
                StringBuilder sb = new StringBuilder();
                sb.append("msgs条数：" + msgs.size());
                MessageExt messageExt = msgs.get(0);
                //消息重发了三次
                if (messageExt.getReconsumeTimes() == 3) {
                    //todo 持久化消息记录表
                    //重试了三次不再重试了，直接签收掉
                    return ConsumeConcurrentlyStatus.CONSUME_SUCCESS;
                }

                for (MessageExt msg : msgs) {
                    try {
                        String topic = msg.getTopic();
                        String messageBody = new String(msg.getBody(), "utf-8");
                        String tags = msg.getTags();
                        //todo 业务逻辑处理
                        sb.append("topic:" + topic + ",tags:" + tags + ",msg:" + messageBody);
                    } catch (Exception e) {
                        e.printStackTrace();
                        // 重新消费
                        return ConsumeConcurrentlyStatus.RECONSUME_LATER;
                    }
                }
                System.out.println(sb.toString());
                //签收，这句话告诉broker消费成功，可以更新offset了，也就是发送ack。
                return ConsumeConcurrentlyStatus.CONSUME_SUCCESS;
            }
        });

        consumer.start();
    }

}
复制代码
```

**每行代码的功能作用都写在注释里了，小伙伴要仔细观看下哦**。现在测试一下，先启动消费者，然后启动生产者。

这是生产者启动后发送的十条数据。

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b110e5e674d548f8b0e0e83c80e8e595~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) msgId：生产者生成的唯一编号，全局唯一，也叫uniqId。

offsetMsgId：消息偏移id，该id记录了消息所在集群的物理地址，主要包含所存储Broker服务器的地址（IP与端口号）以及所在commitlog文件的物理偏移量。

在控制台可以通过 msgId 来查询该条消息。 ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d6975d0645694d4e84a67a681a568c4c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 通过Key也一样可以找到 ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6e06b1733f524dd4978894570ec49c68~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 再看下消费者端，十条数据都已经被成功消费了 ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7013fb3450304221b3a1a6752e32a861~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

> 源码以及官方提供的 rocketmq\example 的示例代码已经上传，需要的小伙伴可以下载下来观看。地址：[github.com/xuhaoj/rock…](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fxuhaoj%2Frocketmq-javaapi)

rocketmq\example中各个包的作用如下：

| package      | 作用                                                 |
| ------------ | ---------------------------------------------------- |
| batch        | 批量消息，用List发送                                 |
| broadcast    | 广播消息，setMessageModel(MessageModel.BROADCASTING) |
| delay        | 延迟消息，msg.setDelayTimeLevel(3)                   |
| filter       | 基于tag或者 SQL表达式过滤                            |
| ordermessage | 顺序消息                                             |
| quickstart   | 入门                                                 |
| rpc          | 实现RPC调用                                          |
| simple       | ACL、异步、assign、subscribe                         |
| tracemessage | 消息追踪                                             |
| transaction  | 事务消息                                             |

## Spring Boot 集成

在Srping Boot中提供了更简单的配置方式和操作方式，使用起来非常的舒服，干净，简洁。首先还是引入RocketMQ starter 的依赖。

```
        <dependency>
            <groupId>org.apache.rocketmq</groupId>
            <artifactId>rocketmq-spring-boot-starter</artifactId>
            <version>2.0.4</version>
        </dependency>
复制代码
```

然后客户端的配置直接写在application.properties中

```properties
server.port=9096
spring.application.name=springboot-rocketmq-demo
rocketmq.name-server=39.103.144.86:9876;42.192.77.73:9876
rocketmq.producer.group=jackxu-springboot-rocketmq-group
rocketmq.producer.send-message-timeout=3000
复制代码
```

创建一个消费者类Consumer，加上@RocketMQMessageListener注解监听消息

```java
/**
 * @author jackxu
 */
@Component
@RocketMQMessageListener(topic = "springboot-topic", consumerGroup = "springboot-consumer-group",
        selectorExpression = "tag1", selectorType = SelectorType.TAG,
        messageModel = MessageModel.CLUSTERING, consumeMode = ConsumeMode.CONCURRENTLY)
public class Consumer implements RocketMQListener<String> {

    @Override
    public void onMessage(String message) {
        try {
            System.out.println("接收到rocketmq消息:" + message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
复制代码
```

注解里面的配置和 java api中的一样，相信大家都能够看懂。

MessageModel有两个选项，BROADCASTING代表所有消费者消费同样的消息，CLUSTERING代表多个消费者轮询消费消息（默认）。

**ConsumeMode也有两个选项，CONCURRENTLY代表消费端并发消费（默认），消息顺序得不到保证，到底有多少个线程并发消费，取决于线程池的大小，ORDERLY代表有序消费，也就是生产者发送的顺序跟消费者消费的顺序一致。**

> 两者的区别：顺序消费需要对要处理的队列加锁，确保同一队列，同一时间，只允许一个消费线程处理。很显然并发消费效率更高。

创建一个生产者类MessageSender，生产者的代码更加简单，只需要注入RocketMQTemplate就可以发送消息。

```java
/**
 * @author jackxu
 */
@Component
public class MessageSender {

    @Autowired
    private RocketMQTemplate rocketMQTemplate;

    public void syncSend() {
        /**
         * 发送可靠同步消息 ,可以拿到SendResult 返回数据
         * 同步发送是指消息发送出去后，会在收到mq发出响应之后才会发送下一个数据包的通讯方式。
         * 参数1： topic:tag
         * 参数2:  消息体 可以为一个对象
         * 参数3： 超时时间 毫秒
         */
        SendResult result = rocketMQTemplate.syncSend("springboot-topic:tag", "这是一条同步消息", 10000);
        System.out.println(result);
    }


    public void asyncSend() throws Exception {
        /**
         * 发送 可靠异步消息
         * 发送消息后，不等mq响应，接着发送下一个数据包。发送方通过设置回调接口接收服务器的响应，并可对响应结果进行处理。
         * 参数1： topic:tag
         * 参数2:  消息体 可以为一个对象
         * 参数3： 回调对象
         */
        rocketMQTemplate.asyncSend("springboot-topic:tag1", "这是一条异步消息", new SendCallback() {
            @Override
            public void onSuccess(SendResult sendResult) {
                System.out.println("回调sendResult:" + sendResult);
            }

            @Override
            public void onException(Throwable e) {
                System.out.println(e.getMessage());
            }
        });
        TimeUnit.SECONDS.sleep(100000);
    }


    public void sendOneWay() {
        /**
         * 发送单向消息，特点为只负责发送消息，不等待服务器回应且没有回调函数触发，即只发送请求不等待应答。
         * 此方式发送消息的过程耗时非常短，一般在微秒级别。应用场景：适用于某些耗时非常短，但对可靠性要求并
         * 不高的场景，例如日志收集。
         * 参数1： topic:tag
         * 参数2:  消息体 可以为一个对象
         */
        rocketMQTemplate.sendOneWay("springboot-topic:tag1", "这是一条单向消息");
    }


    public void sendOneWayOrderly() {
        /**
         * 发送单向的顺序消息
         * 参数1： topic:tag
         * 参数2:  消息体 可以为一个对象
         */
        rocketMQTemplate.sendOneWayOrderly("springboot-topic:tag1", "这是一条顺序消息", "8888");
    }

}
复制代码
```

一共有三种类型，它们的使用方法和作用已经写在注释上了，它们的选择方案如下：

- 当发送的消息不重要时，采用one-way方式，以提高吞吐量，`效率最高`
- 当发送的消息很重要时，且对响应时间不敏感的时候采用sync方式
- 当发送的消息很重要时，且对响应时间非常敏感的时候采用async方式

写一个测试类测试下

```java
/**
 * @author jackxu
 */
@SpringBootTest
class SpringbootRocketmqApplicationTests {

    @Autowired
    private MessageSender sender;

    @Test
    public void syncSendTest() {
        sender.syncSend();
    }


    @Test
    public void asyncSendTest() throws Exception {
        sender.asyncSend();
    }


    @Test
    public void sendOneWayTest() {
        sender.sendOneWay();
    }


    @Test
    public void sendOneWayOrderlyTest() {
        sender.sendOneWayOrderly();
    }

}
复制代码
```

这里选择异步发送sendOneWayTest，执行一下，查看结果，发送成功并且回调了。

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/93f9815a02e94c39b0fe3b182f5749a2~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 看下控制台，也有这条消息 ![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bb59780af8754a84880e74ad6a043c4c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp) 消费端也消费成功，测试完成。 ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4b364422e045427aa48237cf69b9e500~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

> 源码已经上传至 [github.com/xuhaoj/spri…](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fxuhaoj%2Fspringboot-rocketmq) ，感兴趣的小伙伴可以下载下来观看。

## 结语

最后推荐一本电子书《RocketMQ实战与原理解析》作为课外读物，下载链接在：[pan.baidu.com/s/1Ah1Gm3CX…](https://link.juejin.cn?target=https%3A%2F%2Fpan.baidu.com%2Fs%2F1Ah1Gm3CXeFnbyoBSvCekfw) 提取码：jack 

