
# 一 单体应用—部署上线
## 1. 安装jdk

[jdk 8u202之前的版本下载地址](https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html)   &nbsp;  [jdk全版本下载地址](https://www.oracle.com/java/technologies/oracle-java-archive-downloads.html)

- 先检查是否已经安装jdk

```shell
java -version

rpm -qa|grep openjdk -i   # 检查系统安装的openjdk

rpm -e --nodeps XXX(需要删除的软件名) #如果存在openjdk,就用这个命令逐一删除
```

- 创建jdk安装目录和软件包存储目录，并上传jdk文件。将文件解压剪贴到jdk安装目录后配置环境变量即可。

```shell
mkdir /usr/java
mkdir /home/software

tar -zxvf jdk-8u191-linux-x64.tar.gz
mv jdk1.8.0_191/ /usr/java/
```

- 配置环境变量，（修改profile文件）

```shell
vim /etc/profile  #配置环境变量，加入如下信息：(按esc退出插入模式后 :wq 保存退出)
```

```
export JAVA_HOME=/usr/java/jdk1.8.0_191
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export PATH=$JAVA_HOME/bin:$PATH
```

- 刷新profile，使其生效

```shell
source /etc/profile
```

## 2. 安装tomcat
可通过wget命令下载和通过官网下载后上传至服务器。[Tomcat下载地址](https://tomcat.apache.org/download-80.cgi)

```shell
wget https://mirrors.cnnic.cn/apache/tomcat/tomcat-8/v8.5.69/bin/apache-tomcat-8.5.69.tar.gz

wget https://mirrors.cnnic.cn/apache/tomcat/tomcat-9/v9.0.50/bin/apache-tomcat-9.0.50.tar.gz
```
- 下载后解压至我们指定的目录，按需修改配置文件，启动即可

```shell
tar -zxvf apache-tomcat-9.0.50.tar.gz

mv apache-tomcat-9.0.50 /usr/local/tomcat

cd /usr/local/tomcat/bin/
./startup.sh
```


## 3. 安装MariaDB
【方式一】通过添加yum源安装  [通过MariaDB官网选择yum源](https://downloads.mariadb.org/mariadb/repositories/#mirror=tuna)

```shell
vim /etc/yum.repos.d/MariaDB.repo
```
```repo
# MariaDB 10.6 CentOS repository list - created 2021-07-12 10:47 UTC
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.6/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
```
```shell
yum install MariaDB-server MariaDB-client -y
```

```shell
systemctl start mariadb   #启动数据库服务
systemctl enable mariadb  #设置 MariaDB 在操作系统重启后自动启动服务。
systemctl status mariadb  #查看 MariaDB 服务当前状态。

mysql_secure_installation #对 MariaDB 进行安全配置(设置 MariaDB 的root账户密码，删除匿名用户，禁用root远程登录，删除测试数据库，重新加载权限表。)

mysql --version           #查看版本
mysql -u root -p          #通过命令行登录
```

【方式二】通过离线安装包安装





# 二 Nginx


# 三 高可用集群负载均衡

## 1. Keepalived

## 2. LVS

## 3. 搭建高可用集群

