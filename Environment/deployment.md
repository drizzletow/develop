
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
## 1. 安装Nginx
- 下载Nginx安装包并解压  ([Nginx官网](http://nginx.org/en/download.html) )

```shell
wget -c https://nginx.org/download/nginx-1.20.1.tar.gz

tar -zxvf nginx-1.20.1.tar.gz
```

- 安装依赖环境 — 需要前置环境 `gcc，PCRE pcre-devel，zlib，OpenSSL`
>gcc环境
PCRE库，用于解析正则表达式
zlib压缩和解压缩依赖
SSL 安全的加密的套接字协议层，用于HTTP安全传输，也就是https

```shell
yum install gcc-c++
yum install -y pcre pcre-devel
yum install -y zlib zlib-devel
yum install -y openssl openssl-devel
```

- 编译安装 — 编译之前，先创建nginx临时目录,并进行相关配置

```shell
mkdir /var/temp/nginx -p
cd nginx-1.20.1/


./configure \
--prefix=/usr/local/nginx \
--pid-path=/var/run/nginx/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--with-http_gzip_static_module \
--http-client-body-temp-path=/var/temp/nginx/client \
--http-proxy-temp-path=/var/temp/nginx/proxy \
--http-fastcgi-temp-path=/var/temp/nginx/fastcgi \
--http-uwsgi-temp-path=/var/temp/nginx/uwsgi \
--http-scgi-temp-path=/var/temp/nginx/scgi \
--with-http_ssl_module

make

make install
```
<table><thead><tr><th align="left">命令</th><th align="left">解释</th></tr></thead><tbody><tr><td align="left">–prefix</td><td align="left">指定nginx安装目录</td></tr><tr><td align="left">–pid-path</td><td align="left">指向nginx的pid</td></tr><tr><td align="left">–lock-path</td><td align="left">锁定安装文件，防止被恶意篡改或误操作</td></tr><tr><td align="left">–error-log</td><td align="left">错误日志</td></tr><tr><td align="left">–http-log-path</td><td align="left">http日志</td></tr><tr><td align="left">–with-http_gzip_static_module</td><td align="left">启用gzip模块，在线实时压缩输出数据流</td></tr><tr><td align="left">–http-client-body-temp-path</td><td align="left">设定客户端请求的临时目录</td></tr><tr><td align="left">–http-proxy-temp-path</td><td align="left">设定http代理临时目录</td></tr><tr><td align="left">–http-fastcgi-temp-path</td><td align="left">设定fastcgi临时目录</td></tr><tr><td align="left">–http-uwsgi-temp-path</td><td align="left">设定uwsgi临时目录</td></tr><tr><td align="left">–http-scgi-temp-path</td><td align="left">设定scgi临时目录</td></tr></tbody></table>





## 2. Nginx命令和配置

- 启动和停止 — 进入安装目录启动nginx  (`/usr/local/nginx/sbin`)

```bash
./nginx

./nginx -s stop

./nginx -s reload

./nginx -V
```

- Nginx 默认配置文件 （`nginx.conf`）

```conf
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
```


## 3. Nginx配置SSL证书
前置条件：需要已备案域名，SSL证书。上传证书后配置`nginx.conf` (注意：Nginx安装时要配置`--with-http_ssl_module`)

```
server {
    #SSL 访问端口号为 443
    listen 443 ssl; 
 #填写绑定证书的域名
    server_name cloud.tencent.com; 
 #证书文件名称
    ssl_certificate 1_cloud.tencent.com_bundle.crt; 
 #私钥文件名称
    ssl_certificate_key 2_cloud.tencent.com.key; 
    ssl_session_timeout 5m;
 #请按照以下协议配置
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; 
 #请按照以下套件配置，配置加密套件，写法遵循 openssl 标准。
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE; 
    ssl_prefer_server_ciphers on;
    location / {
    #网站主页路径。此路径仅供参考，具体请您按照实际目录操作。
        root html; 
        index  index.html index.htm;
    }
}
```



## 4. 总结和常见问题
1. 搭建动静分离、具备HTTPS安全访问的反向代理服务器架构

```conf
user root;
worker_processes  3;

events {
    worker_connections  4096;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    #监听80端口，重定向到443端口
    server {
        listen       80;
        server_name  qmt.ink;
        rewrite ^(.*)$ https://qmt.ink:443/$1 permanent;

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
    #后端反向代理 可拓展集群
    upstream tomcats{
        server 172.17.0.15:8088;
    }
    #HTTPS server
    server {
        listen 443 ssl;
        server_name qmt.ink;
        ssl_certificate 1_qmt.ink_bundle.crt;
        ssl_certificate_key 2_qmt.ink.key;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
        ssl_prefer_server_ciphers on;
        #配置网站路径
        location /shop {
            alias /home/website/foodie-shop/;
            index index.html index.htm;
        }
        #通用请求（反向代理）
        location / {
            proxy_pass http://tomcats;
        }
    }
}
```

2. `nginx: [error] open() "/var/run/nginx/nginx.pid" failed (2: No such file or directory)` ？
【原因分析】： 目录或文件不存在 （可先进入 `/var/run/nginx` 目录，验证目录是否存在，没有创建即可）

```
cd /var/run/nginx
mkdir /var/run/nginx

/usr/local/nginx/sbin/nginx -s reload
```
目录存在后重新加载nginx会出现 `nginx: [error] invalid PID number "" in "/var/run/nginx/nginx.pid"`，此时需要重新指定nginx的配置文件：
```
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx -s reload
```



# 三 高可用集群负载均衡

## 1. Keepalived

## 2. LVS

## 3. 搭建高可用集群

