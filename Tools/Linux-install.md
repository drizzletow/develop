

# 一 VMware相关

## 1. 设置静态网络IP

    VMware 点击 编辑 ——> 虚拟网络编辑器 (如图：)

![](vx_images/2467802020864.png)


```shell
ip addr
vi /etc/sysconfig/network-scripts/ifcfg-ens33

service network restart 
```



<br/>

## 2. 虚拟机自启动

1. 创建启动、关闭脚本

```bash
# 在系统的某个安静的盘中创建一个vm_start.bat文件，然后使用编辑器打开。写入: 
"C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" start "D:\VirtualMachines\DevMachines\DevMachines.vmx" nogui

# 再次创建一个vm_stop.bat文件
"C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe" stop "D:\VirtualMachines\DevMachines\DevMachines.vmx"

#测试运行文件: 双击启动文件vm_start.bat，如果弹出dos窗口且虚拟机启动则无误,双击停止文件vm_stop.bat，如果弹出dos窗口且虚拟机停止则无误
```

<br/>

2. 添加到自启动任务

`Win+ R`  -> `gpedit.msc` -> 用户配置 -> windows设置 -> 鼠标双击脚本(登录/注销) -> 鼠标双击“登录”或“注销”分别添加启动、关闭脚本

【Q】主机访问不到虚拟机的服务的解决办法

```shell
firewall-cmd --query-port=9200/tcp                           #查看端口号是否开启,如果是no，就说明没有开放

firewall-cmd --zone=public --add-port=6379/tcp --permanent   #开通6379端口(redis)
firewall-cmd --zone=public --add-port=8848/tcp --permanent   #开通8848端口(nacos)
firewall-cmd --zone=public --add-port=3306/tcp --permanent   #开通3306端口(mysql)

firewall-cmd --reload                                        #重启防火墙，端口正常开启
systemctl restart docker                                     #如果是docker容器的化则要重启下docker服务 
```

<br/>



# 二 vagrant安装

## 1. 安装准备

**virtualbox + vagrant 安装**：

1. 下载安装 [Virtual box](https://www.virtualbox.org/) 的`主程序`和`拓展包`，安装后修改虚拟机存放位置（需要cpu开启虚拟化）

   <br/>

2. 下载安装 [Vagrant](https://www.vagrantup.com/) （ Vagrant 是没有图形界面的，安装程序会自动把安装路径加入到 PATH 环境变量 ）

```
vagrant version
```

- 配置vagrant (虚拟机镜像文件存储目录，默认为：C:\Users\用户名\.vagrant.d)  —— `VAGRANT_HOME`

![](vx_images/1721139220770.png)

<br/>


3. 下载虚拟机镜像
   使用 Vagrant 创建虚机时，需要指定一个镜像，也就是 box。开始这个 box 不存在，所以 Vagrant 会先从网上（[镜像网站](https://app.vagrantup.com/boxes/search)）下载，然后缓存在本地目录中。但默认下载往往会比较慢，我们可以自己下载镜像文件。常用的两个 Linux 操作系统镜像的下载地址：

- CentOS [官网下载](http://cloud.centos.org/centos/) ，[CentOS-7.box （点击下载）](http://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7.box) 列表中有一个 vagrant 目录，选择其中的 .box 后缀的文件下载即可。

- Ubuntu [官网下载](http://cloud-images.ubuntu.com/) ，[清华大学镜像站下载](https://mirror.tuna.tsinghua.edu.cn/ubuntu-cloud-images/) ，同样选择针对 vagrant 的 .box 文件即可。

  <br/>


```shell

添加 box ：接下来我们需要将下载后的 .box 文件添加到 vagrant 中：

```

<br/>

```shell

# 如果这是第一次运行，此时 VAGRANT_HOME 目录下会自动生成若干的文件和文件夹，其中有一个 boxes 文件夹，
# 这就是要存放 box 文件的地方。

vagrant box list

#执行 vagrant box add 命令添加 box: (命令后面跟着的是镜像文件的路径，通过 --name centos-7 为这个 box 指定名字)
vagrant box add E:\Package\VM\VirtualBox\CentOS-7.box --name centos-7

vagrant box list        #再次查询，可以看到有了一个 box

```

<br/>



## 2. 安装虚拟机

Vagrant新建虚拟机

```shell

#先进入vagrant工作目录（Vagrantfile所在的目录）再执行命令
vagrant init centos-7

#首次执行会先安装再启动，之后就是启动的功能（注意要在Vagrantfile所在的目录执行）
vagrant up

```

<br/>

```shell
# 常用命令
vagrant status         #查看虚拟机状态
vagrant ssh            #以 vagrant 用户直接登入虚拟机中，使用 exit; 退出

vagrant halt           #关闭虚拟机
vagrant suspend        #暂停虚拟机
vagrant resume         #恢复虚拟机
vagrant reload         #重载虚拟机(可能会重启失败，需要重启宿主机才能开机虚拟机)
vagrant destroy        #删除虚拟机
```

<br/>

配置私有网络：

上述创建的虚拟机网络默认使用的是 `网络地址转换（NAT）+ 端口转发` 的方式，

我们需要修改 `Vagrantfile`，为虚拟机设置指定的私有网络地址：

```shell

# 取消改行的注释，根据下图宿主机的IP地址，修改前三段地址一致即可
config.vm.network "private_network", ip: "192.168.56.10"

```

<br/>

```
ipconfig
```

![](vx_images/4608247249196.png)

```shell

# 修改Vagrantfile文件后，需要重启虚拟机，若重启失败可删除重装，先修改Vagrantfile，再vagrant up
vagrant reload

```

<br/>



更改虚拟机配置（[Provider配置](https://www.vagrantup.com/docs/providers/virtualbox/configuration)）

```shell
config.vm.provider "virtualbox" do |v|
v.memory = 4096
v.cpus = 4
end
```

> 【注意】修改Vagrantfile可能会导致虚拟机无法启动，可在安装前先修改好Vagrantfile文件。系统用户密码均为 ：vagrant

<br/>



# 三 Ubuntu

官网：https://ubuntu.com/

## 1. vm tools
[安装 Open VM Tools](https://docs.vmware.com/cn/VMware-Tools/11.3.0/com.vmware.vsphere.vmwaretools.doc/GUID-C48E1F14-240D-4DD1-8D4C-25B6EBE4BB0F.html) 

```bash

请确保已更新软件包索引：
sudo apt-get update

如果虚拟机具有 GUI（X11 等），请安装或升级 open-vm-tools-desktop：
sudo apt-get install open-vm-tools-desktop

否则，请使用以下命令安装 open-vm-tools：
sudo apt-get install open-vm-tools

```


<br/>

## 2. 语言和输入法


<br/>












<br/>


# 四 Manjaro

## 1. vm tools
Manjaro原版中的open-vm-tools与VMware不匹配

Github地址：https://github.com/rasa/vmware-tools-patches

```bash

1、卸载open-vm-tools
sudo pacman -R open-vm-tools

2、下载vmwaretools补丁
git clone https://github.com/rasa/vmware-tools-patches.git

3、进入vmware-tools-patches目录
cd vmware-tools-patches

4、运行补丁
sudo ./patched-open-vm-tools.sh

5、重启
reboot

```

<br>

## 2. AUR助手
Yay (Yet another Yogurt) 是一个 AUR 助手，它允许用户在 Manjaro 上安装和管理软件包系统。
在安装过程中，它会自动从 PKGBUIDS 安装软件包。Yay 取代了早已停产的 Aurman 和 Yaourt。
自发布以来，Yay 已被证明是出色的帮手，并且是原生 Pacman 包管理器的完美替代品。

```bash

sudo pacman -Syu                      # 更新系统

sudo pacman -S yay                    # 下载yay


yay -S 软件名                          # 安装软件
yay -R 软件名                          # 卸载软件
yay -Ss 软件模糊名（或者精确的名字）     # 搜索软件


yay -S google-chrome                  # 安装Chrome

```

<br>



## 3. 安装deb包

arch 系列如果要安装 dep 软件包，需要通过 deptap 工具转换后才能安装

```bash

1、安装debtap：使用yay安装debtap，

sudo pacman -S yay   # 如果没有yay，需要使用pacman安装yay：

sudo yay -S debtap   # 安装debtap：


2、deb包转换arch包，需要先运行下述命令，否则会出错：

sudo debtap -u

sudo debtap -q xxxxx.deb   #使用debtap将deb包转换为arch包

# 在转换过程中会提示是否需要编辑相关信息，直接按回车即可，转换完成后，将会生成一个后缀为.pkg.tar.rst的文件。


3、安装，使用pacman安装转换的arch包：

sudo pacman -U xxxx.pkg.tar.rst

```





<br>



# 五 常用Linux设置


## 1. 解压安装jdk

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
<br>



## 2. http proxy

Windows + Linux虚拟机的 代理设置：

- 为避免Linux配置`clash`的一些麻烦，只在Windows上装有`clash`，并已有可用的服务
- 虚拟机采用桥接模式（似乎也有不采用桥接模式而成功的例子，但是我没有成功）
- `clash`开启`allow LAN`，并开启代理

<br>

linux下通过图形界面设置的代理，终端和浏览器一般不使用该代理，需要分别设置

```bash

# 终端设置(Linux 终端设置 HTTP 代理、注意只对当前终端有效)：
$ export http_proxy=http://192.168.5.64:7890
$ export https_proxy=http://192.168.5.64:7890

$ export http_proxy=socks5://127.0.0.1:1080
$ export https_proxy=socks5://127.0.0.1:1080

$ export ALL_PROXY=http://192.168.5.64:7890


# Linux 终端中取消代理设置：
$ unset http_proxy
$ unset https_proxy
$ unset ALL_RPOXY

```

注意：ping 使用的是 ICMP 协议，不支持代理。可以执行 `curl -vv https://www.google.com ` 看看有没有走代理。

永久代理设置：将代理命令写入配置文件 ~/.profile 或 ~/.bashrc 或 ~/.zshrc 中

<br>

```bash

# Git 设置代理：
git config --global http.proxy http://192.168.5.79:7890
git config --global https.proxy http://192.168.5.79:7890

# Git 取消代理设置：
git config --global --unset http.proxy
git config --global --unset https.proxy

```



<br>



## 3. 终端配色方案

### 原生Shell配色

更改到 centos 的 /etc/bashrc 中即可永久生效： ` vim /etc/bashrc  `         # 填入如下内容
```bash

if [ "${-#*i}" != "$-" ];then
    # interactively shell
    PS1="[\[\033[01;31m\]\u\[\033[00m\]@\[\033[36;36m\]\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]]$ "
    trap 'echo -ne "\e[0m"' DEBUG
fi

```

可以在/etc/profile中也去加载/etc/bashrc：

```bash

cat >> /etc/profile << EOF
if [ -f /etc/bashrc ]; then 
    . /etc/bashrc
fi
EOF

```
刷新即永久生效： `source /etc/profile` 


<br/>

参数说明-->PS1的定义中个常用的参数的含义如下：
```bash
\d ：#代表日期，格式为weekday month date，例如："Mon Aug 1"
\H ：#完整的主机名称
\h ：#仅取主机的第一个名字
\T ：#显示时间为24小时格式，如：HH：MM：SS
\t ：#显示时间为12小时格式 , 如：HH：MM：SS
\A ：#显示时间为12小时格式：HH：MM
\u ：#当前用户的账号名称
\v ：#BASH的版本信息
\w ：#完整的工作目录名称
\W ：#利用basename取得工作目录名称，所以只会列出最后一个目录
#  ：#下达的第几个命令
$  ：#提示字符，如果是root时，提示符为：`#` ，普通用户则为：`$`


设置颜色: 在PS1中设置字符颜色的格式为：[\e[F;Bm]
F为字体颜色，编号为30-37
B为背景颜色，编号为40-47

格式：[\e[F;Bm]需要改变颜色的部分[\e[0m] , F B 值分别对应的颜色

30 40 黑色

31 41 红色

32 42 绿色

33 43 黄色

34 44 蓝色

35 45 紫红色

36 46 青蓝色

37 47 白色

```

<br>


### On-my-zsh

什么是zsh: https://blog.csdn.net/lovedingd/article/details/124128721
和bash一样，zsh也是终端内的一个命令行解释器，简称：shell。顾名思义就是机器外面的一层壳，用于人机交互。接收用户或其他程序的命令，把这些命令转化成内核能理解的语言。

具体表现为其作用是用户输入一条命令，shell 就立即解释执行一条。不局限于系统、语言等概念、操作方式和表现方式等。比如：我们使用的cd、wget、curl和mount等命令。

传统的shell（如：bash），命令和显示的文字以单色为主；而zsh不仅支持彩色字体，还支持命令填充：

一般情况下，Linux是不自带zsh的，你可以使用命令查看，终端输入：

`cat /etc/shells `

正常情况下，应该是没有/bin/zsh的, 解决方法很简单，使用apt-get或者yum安装即可

```bash

apt-get install zsh

yum install zsh

```
安装后，重新使用cat /etc/shells命令查看

之后，设置为默认shell并重启终端：

```bash
chsh -s /bin/zsh

exit;

```

<br>


Oh-my-zsh十分简单，可以看看项目地址：https://github.com/ohmyzsh/ohmyzsh

官方配置非常简单，但是因为项目官方脚本在GitHub的原因，国内访问可能有点困难

官方安装-->Linux/Mac打开终端，输入官方提供的脚本：

```bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

```
为了保证脚本能顺利运行，你的Linux/Mac服务器需要：

- 提前安装git、curl
- 可以成功连接GitHub
- 如果有~/.zshrc文件，最好提前备份

<br>

脚本安装, 考虑到官方的方法，需要连接GitHub；如果你的设备无法有效访问GitHub。可以使用下列的脚本：

```

zsh -c "$(curl -fsSL 'https://api.host.mintimate.cn/fileHost/public/download/1P0R')"

```
为了保证脚本能顺利运行，你的Linux/Mac服务器需要：
- 提前安装curl、unzip
- 如果有~/.zshrc文件，最好提前备份，否则本脚本自动更改原本的.zshrc文件为zshrcBak

<br>
手动安装
其实，手动配置重复的内容就是我写的脚本配置：

- 在oh-my-zsh的github主页，手动将zip包下载下来。
- 将zip包解压，拷贝至~/.oh-my-zsh目录。
- 执行cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    或手动复制~/.oh-my-zsh/templates/zshrc.zsh-template内文件内容到~/.zshrc内。
    （如果没有~/.zshrc文件，可以手动创建）
- 重启终端或终端输入source ~/.zshrc使配置生效

<br>
On-my-zsh的功能和使用简介：

- 自带填充：主要使用到zsh的Tab功能

- 粘贴自动转义：
   使用Oh-my-zsh，默认是使用自动粘贴转义。但是这样容易出差错。
   为此，如果需要关闭自动转义，可以打开~/.zshrc文件，添加DISABLE_MAGIC_FUNCTIONS=true字段
   
zsh的强大不仅仅如此，还可以安装更多强大插件，感兴趣可以自己进行探索。
而Oh-my-zsh的使用也不仅仅如此，可以自行阅读开发者文档：https://github.com/ohmyzsh/ohmyzsh