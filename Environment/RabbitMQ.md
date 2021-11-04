
**AMQP协议**中的几个重要概念：
- `Server`：接收客户端的连接，实现AMQP实体服务。
- `Connection`：连接，应用程序与Server的网络连接，TCP连接。
- `Channel`：信道，消息读写等操作在信道中进行。客户端可以建立多个信道，每个信道代表一个会话任务。
- `Message`：消息，应用程序和服务器之间传送的数据，消息可以非常简单，也可以很复杂。有Properties和Body组成。Properties为外包装，可以对消息进行修饰，比如消息的优先级、延迟等高级特性；Body就是消息体内容。
- `Virtual Host`：虚拟主机，用于逻辑隔离。一个虚拟主机里面可以有若干个Exchange和Queue，同一个虚拟主机里面不能有相同名称的Exchange或Queue。
- `Exchange`：交换器，接收消息，按照路由规则将消息路由到一个或者多个队列。如果路由不到，或者返回给生产者，或者直接丢弃。RabbitMQ常用的交换器常用类型有direct、topic、fanout、headers四种。
- `Binding`：绑定，交换器和消息队列之间的虚拟连接，绑定中可以包含一个或者多个RoutingKey。
- `RoutingKey`：路由键，生产者将消息发送给交换器的时候，会发送一个RoutingKey，用来指定路由规则，这样交换器就知道把消息发送到哪个队列。路由键通常为一个“.”分割的字符串，例如“com.rabbitmq”。
- `Queue`：消息队列，用来保存消息，供消费者消费。

## 1. 安装RabbitMQ

- 安装包下载 — [rabbitmq-github地址](https://github.com/rabbitmq/rabbitmq-server/releases/tag/v3.8.19) &nbsp; &nbsp; [erlang官网](https://www.erlang.org/downloads)

```shell
cd /home/software

wget http://erlang.org/download/otp_src_24.0.tar.gz

wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.19/rabbitmq-server-generic-unix-3.8.19.tar.xz
```

- 安装erlang — 由于rabbitmq是基于erlang语言开发的，所以必须先安装erlang。

```shell
# 安装依赖
yum -y install gcc glibc-devel make ncurses-devel openssl-devel xmlto perl wget gtk2-devel binutils-devel

tar -zxvf otp_src_24.0.tar.gz
mkdir /usr/local/erlang
cd /home/software/otp_src_24.0/
./configure --prefix=/usr/local/erlang
make install

#查看一下是否安装成功
ll /usr/local/erlang/bin

#添加环境变量
echo 'export PATH=$PATH:/usr/local/erlang/bin' >> /etc/profile
source /etc/profile

#进入了erlang  halt().命令退出
erl
```

- 安装RabbitMQ — [rabbitmq-github地址](https://github.com/rabbitmq/rabbitmq-server/releases/tag/v3.8.19)

```shell
# 由于是tar.xz格式的所以需要用到xz，没有的话就先安装 
yum install -y xz

cd /home/software
xz -d rabbitmq-server-generic-unix-3.8.19.tar.xz
tar -xvf rabbitmq-server-generic-unix-3.8.19.tar
mv rabbitmq_server-3.8.19 /usr/local/rabbitmq

echo 'export PATH=$PATH:/usr/local/rabbitmq/sbin' >> /etc/profile
source /etc/profile
```

```shell
#用户管理
rabbitmqctl list_users                                  #查看所有用户
rabbitmqctl add_user rmq t0123....                      #添加用户rmq并配置权限：
rabbitmqctl set_permissions -p "/" rmq ".*" ".*" ".*"
rabbitmqctl list_user_permissions rmq                   #查看用户权限
rabbitmqctl set_user_tags rmq administrator             #设置tag
#rabbitmqctl delete_user guest                          #删除用户（删除默认用户）


rabbitmqctl status                   #状态
rabbitmq-server -detached            #启动
rabbitmqctl stop                     #停止

chkconfig rabbitmq-server on         #开机启动RabbitMQ服务
```

```shell
#开启web插件
rabbitmq-plugins enable rabbitmq_management

lsof -i:5672                 #查看服务有没有启动
lsof -i:15672                #查看管理端口有没有启动

#浏览器访问： http://42.192.84.121:15672
```

- 设置 RabbitMQ 开机自启动

```shell
vim rabbitmq                   #在/etc/init.d 目录下新建一个 rabbitmq 文件
chmod 777 rabbitmq             #对rabbitmq授予可执行权限
chkconfig --add rabbitmq       #添加rabbitmq服务到系统服务中
chkconfig rabbitmq on          #设置自启动
chkconfig --list rabbitmq      #查看自启动项是否设置成功

./rabbitmq start               #开启服务
reboot                         #测试开机重启
ps -elf|grep rabbitmq
```
```bash
#!/bin/bash
#chkconfig:2345 61 61

export HOME=/usr/local/rabbitmq/
export PATH=$PATH:/usr/local/erlang/bin
export PATH=$PATH:/usr/local/rabbitmq/sbin
 
case "$1" in
    start)
    echo "Starting RabbitMQ ..."
    rabbitmq-server  -detached
    ;;
stop)
    echo "Stopping RabbitMQ ..."
    rabbitmqctl stop
    ;;
status)
    echo "Status RabbitMQ ..."
    rabbitmqctl status
    ;;
restart)
    echo "Restarting RabbitMQ ..."
    rabbitmqctl stop
    rabbitmq-server  restart
    ;;
 
*)
    echo "Usage: $prog {start|stop|status|restart}"
    ;;
esac
exit 0
```

## 2. SpringBoot整合RabbitMQ

