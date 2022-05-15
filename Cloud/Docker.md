# 一 Docker Introduction

## 1. Docker Install

docker 官网安装教程：https://docs.docker.com/engine/install/centos/ 

### Docker的快速安装

**Uninstall old versions**：

```shell
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

<br>

**install using the repository** :

```shell

#Set up the repository
sudo yum install -y yum-utils

sudo yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#install
yum makecache fast && yum install -y docker-ce docker-ce-cli containerd.io && systemctl enable docker

#start
systemctl start docker     #启动
systemctl restart docker   #重启
systemctl enable docker    #自启动

docker version

sudo docker run hello-world

```

<br>

**配置阿里云镜像加速器**: 

```shell

mkdir -p /etc/docker && tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://puqyip19.mirror.aliyuncs.com"]
}
EOF

systemctl daemon-reload && systemctl restart docker

```

<br>



### 安装指定版本docker

```bash

#找到所有可用docker版本列表
yum list docker-ce --showduplicates | sort -r

# 安装指定版本，用上面的版本号替换<VERSION_STRING>
sudo yum install docker-ce-<VERSION_STRING>.x86_64 docker-ce-cli-<VERSION_STRING>.x86_64 containerd.io

#例如：
#yum install docker-ce-3:20.10.5-3.el7.x86_64 docker-ce-cli-3:20.10.5-3.el7.x86_64 containerd.io

#注意加上 .x86_64 大版本号

```

<br>



## 2. Docker常用命令

[Docker官网—常用命令](https://docs.docker.com/engine/reference/commandline/docker/) —— [Docker Hub](https://hub.docker.com/)
```shell

docker version

docker info

docker xxx  --help     # 命令

```

<br>



### Images commands

镜像是怎么做成的? 基础环境+软件 （例如 ：redis的完整镜像应该是： linux系统 + redis软件）

- alpine：超级经典版的linux 5mb；+ redis = 29.0mb
- 没有alpine3的：就是centos基本版

以后自己选择下载镜像的时候尽量使用 alpine 和 slim 

```shell

docker images                            #查看本地主机上的所有镜像

#搜索镜像
docker search xxx                        #搜索镜像：如 mysql,redis......
docker search redis --filter=STARS=100   #过滤掉STARS小于100以下的


#下载镜像
docker pull xxx                          #下载镜像，默认为最新版本
docker pull redis == docker pull redis:latest（最新版）

docker pull mysql:5.7                    #也可指定docker官网可查询到的版本


#删除镜像
docker rmi -f imageID                    #根据镜像ID删除镜像
docker rmi -f $(docker images -aq)       #删除所有镜像

docker image prune   #移除游离镜像 dangling：游离镜像（没有镜像名字的）


#重命名
docker tag 原镜像:标签 新镜像名:标签 


docker container inspect 容器名 = docker inspect 容器

```

<br>



### Containers commands

从镜像创建容器，有两个命令：docker run的立即启动，docker create得稍后自己手动启动

```shell

docker pull centos              #要创建容器，必须先下载镜像
docker ps                       #查看运行中的容器（-a查看全部，-q只显示id）

#创建一个新的容器并运行一个命令
docker run xxx
docker run -it centos /bin/bash #启动并进入容器（使用exit停止并退出，也可以使用Ctrl+P+Q不停止退出）
docker run -d centos            #【问题】发现centos停止了！？原因：docker容器使用后天运行必须要有一个前台进程


#启动和停止
docker start   container_id     #启动容器
docker stop    container_id     #停止正在运行的容器（优雅停机）
docker kill    container_id     #强制停止正在运行的容器（kill是强制kill -9，约等于直接拔电源）
docker restart container_id     #重启容器


#删除容器
docker rm 86fe3bcb173e          #删除指定id的容器（不能删除正在运行的容器，如需强制删除需添加-f）
docker rm -f $(docker ps -aq)   #删除全部容器

```

<br>



### Others commands

```shell

docker logs                              #日志
docker top container_id                  #查看指定容器中的进程信息
docker inspect NAME|ID                   #获取容器/镜像的元数据


docker exec -it container_id /bin/bash   #进入运行的容器中执行命令
docker exec -it -u 0:0 --privileged container_id /bin/bash  # 以特权方式进入容器 （0表示用户）

docker attach -it container_id #连接到正在运行中的容器（绑定的是控制台. 可能导致容器停止。不要用这个）

```

<br>

**docker volume 数据卷**：

```bash

docker volume create xxx   # 创建数据卷

docker volume ls           # 列出所有的数据卷

docker volume inspect xxx  # 查看数据卷的详细信息


docker volume pause        # 删除所有的未使用的数据卷

docker volume rm xxx       # 删除指定的数据卷

```

<br>



## 3. Docker常用镜像安装

如何使用Docker部署组件：
1、先去找组件的镜像
2、查看镜像文档，了解组件的可配置内容
3、docker run进行部署



### MySql安装与配置

```shell

#下载镜像(指定版本)
docker pull mysql:5.7

#创建实例并启动mysql （5.7）
docker run -p 3306:3306 --name mysql --restart=always --privileged=true \
-v /docker/data/mysql/log:/var/log/mysql \
-v /docker/data/mysql/data:/var/lib/mysql \
-v /docker/data/mysql/conf:/etc/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
-d mysql:5.7

# 创建mysql的配置文件
cat > /docker/data/mysql/conf/mysql.conf << EOF
[client]
default-character-set=utf8
[mysql]
default-character-set=utf8
[mysqld]
init_connect='SET collation_connection=utf8_unicode_cli'
init_connect='SET NAMES utf8'
character-set-server=utf8
collation-server=utf8_unicode_ci
skip-character-set-client-handshark
skip-name-resolve
secure_file_priv=/var/lib/mysql
EOF

docker restart mysql                    #修改完要重启mysql
docker exec -it mysql /bin/bash         #进入mysql

```

<br>

```shell

# 创建实例并启动mysql（ 8.0 ）
docker run -p 3306:3306 --name mysql8 --restart=always --privileged=true \
-v /docker/data/mysql/log:/var/log/mysql \
-v /docker/data/mysql/data:/var/lib/mysql \
-v /docker/data/mysql/conf:/etc/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
-d mysql:8.0

#启动两个mysql
docker run -p 3307:3306 --name mysql_gmall \
-v /docker/data/mysql_gmall/log:/var/log/mysql \
-v /docker/data/mysql_gmall/data:/var/lib/mysql \
-v /docker/data/mysql_gmall/conf:/etc/mysql \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql:5.7

```

<br>



### Redis安装与配置

```shell
#下载镜像
docker pull redis

##创建实例并启动redis
mkdir -p /docker/data/redis/conf && touch /docker/data/redis/conf/redis.conf

docker run -p 6379:6379 --name redis --restart=always \
 -v /docker/data/redis/conf/redis.conf:/etc/redis/redis.conf \
 -v /docker/data/redis/data:/data \
 -d redis redis-server /etc/redis/redis.conf


#配置（持久化）
cat > /docker/data/redis/conf/redis.conf << EOF
appendonly yes
EOF

docker restart redis                    #修改完要重启redis

```

<br>

```shell
#测试持久化配置是否生效
docker exec -it redis redis-cli
>set name alice                     # ok
>get name                           # "alice"
>exit

docker restart redis
docker exec -it redis redis-cli
>get name                           # "alice"   成功保存到硬盘，重启数据依旧存在
>exit
```

<br>



### Nginx安装与配置

创建配置文件目录：

```bash

sudo mkdir -p /docker/data/nginx/conf/conf.d
sudo mkdir -p /docker/data/nginx/html
sudo mkdir -p /docker/data/nginx/logs

```

conf 和conf.d 分别 用于保存配置文件
html 用于放置静态文件
logs 用于保存日志



<br>

下载镜像，先随便启动一个容器，复制相关配置文件：

```bash

sudo docker pull nginx

sudo docker run --name nginx-test -p 8088:80 -d nginx 


# 复制相关文件
sudo docker cp 622:/etc/nginx/nginx.conf /docker/data/nginx/conf/nginx.conf
sudo docker cp 622:/etc/nginx/conf.d /docker/data/nginx/conf
sudo docker cp 622:/usr/share/nginx/html /docker/data/nginx/


# 停止、并删除原来的容器
sudo docker stop 622
sudo docker rm 622

```

<br>

指定配置文件及数据保存位置、并启动Nginx：

```bash

sudo docker run --name nginx -p 80:80 \
-v /docker/data/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /docker/data/nginx/html/:/usr/share/nginx/html/ \
-v /docker/data/nginx/logs/:/var/log/nginx/ \
-v /docker/data/nginx/conf/conf.d/:/etc/nginx/conf.d/ \
--privileged=true -d nginx

```



<br>



### nacos安装与配置

注意服务器内存不足，启动后内存溢出问题（单机standalone模式默认服务器堆大小512M）[nacos官方文档](https://nacos.io/zh-cn/docs/what-is-nacos.html)

```shell
docker pull nacos/nacos-server

# 创建本地的映射文件：custom.properties
mkdir -p /docker/data/nacos/{init.d,logs}
touch /docker/data/nacos/init.d/custom.properties

cat > /docker/data/nacos/init.d/custom.properties << EOF
management.endpoints.web.exposure.include=*
EOF
```

<br>

创建数据库 `nacos_config` :  创建nacos数据库后，然后执行下面的Sql 。 [nacos官网的Sql](https://github.com/alibaba/nacos/blob/master/config/src/main/resources/META-INF/nacos-db.sql) . 

```shell
# 创建容器并启动(开机自启动)
docker run -d -p 8848:8848 --name nacos --restart always \
-e MODE=standalone \
-e PREFER_HOST_MODE=ip \
-e SPRING_DATASOURCE_PLATFORM=mysql \
-e MYSQL_SERVICE_HOST=192.168.5.106 \
-e MYSQL_SERVICE_PORT=3306 \
-e MYSQL_SERVICE_DB_NAME=nacos_config \
-e MYSQL_SERVICE_USER=root \
-e MYSQL_SERVICE_PASSWORD=123456 \
-e MYSQL_DATABASE_NUM=1 \
-v /docker/data/nacos/init.d/custom.properties:/home/nacos/init.d/custom.properties \
-v /docker/data/nacos/logs:/home/nacos/logs \
nacos/nacos-server

docker ps

```



<br>



### Zookeeper安装

```shell

docker pull zookeeper:3.4.13

docker run -p 2181:2181 --name zookeeper --restart=always \
-v /docker/zookeeper/data:/data \
-d zookeeper:3.4.13

```



<br>



## 4. docker run 命令详解

常用关键参数OPTIONS 说明：

```bash

-d:   # 后台运行容器，并返回容器ID；
-P:   # 随机端口映射，容器内部端口随机映射到主机的端口
-p:   # 指定端口映射，格式为：主机(宿主)端口:容器端口

-i:   # 以交互模式运行容器，通常与 -t 同时使用；
-t:   # 为容器重新分配一个伪输入终端，通常与 -i 同时使用

--restart ,      # 指定重启策略，可以写--restart=awlays 总是故障重启
--volume , -v:   # 绑定一个卷。一般格式 主机文件或文件夹:虚拟机文件或文件夹


--name="nginx-lb":         # 为容器指定一个名称；
--dns 8.8.8.8:             # 指定容器使用的DNS服务器，默认和宿主一致；
--dns-search example.com:  # 指定容器DNS搜索域名，默认和宿主一致；
-h "mars":                 # 指定容器的hostname；

-e username="ritchie":     # 设置环境变量；
--env-file=[]:             # 从指定文件读入环境变量；

--cpuset="0-2" or --cpuset="0,1,2":   # 绑定容器到指定CPU运行；

-m :             # 设置容器使用内存最大值；
--net="bridge":  # 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；

--link=[]:       # 添加链接到另一个容器；
--expose=[]:     # 开放一个端口或一组端口；

```

<br>



## 5. 可视化界面-Portainer

Portainer是功能强大的开源工具集，可让您轻松地在Docker，Swarm，Kubernetes和Azure ACI中构建和管理容器。 

Portainer的工作原理是在易于使用的GUI后面隐藏使管理容器变得困难的复杂性。通过消除用户使用CLI，编写YAML或理解清单的需求，Portainer使部署应用程序和解决问题变得如此简单，任何人都可以做到。

```bash

sudo docker pull portainer/portainer-ce


# 服务端部署

sudo docker volume create portainer_data

sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v portainer_data:/data portainer/portainer-ce
# 访问 9000 端口即可


# agent端部署
sudo docker run -d -p 9001:9001 --name portainer_agent --restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent

```



<br>



# 二 Dockerfile构建镜像

dockerfile：https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#dockerfile-instructions

菜鸟教程：https://www.runoob.com/docker/docker-dockerfile.html





<br>



# 三 Docker Compose

[Get started with Docker Compose](https://docs.docker.com/compose/gettingstarted/) 

 [You can use Docker Compose to easily run WordPress](https://docs.docker.com/samples/wordpress/) 

 [菜鸟教程](https://www.runoob.com/docker/docker-compose.html) &nbsp; 

[install-compose：](https://docs.docker.com/compose/install/#install-compose)

```shell
#To install a different version of Compose, substitute 1.29.2 with the version of Compose you want to use
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version                          #Test the installation


#To uninstall Docker Compose if you installed using curl:
sudo rm /usr/local/bin/docker-compose
```
