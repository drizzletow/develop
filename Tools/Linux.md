# 一 Linux简介



一些在线网站：

- [鸟哥的 Linux 私房菜 服务器架设篇](http://cn.linux.vbird.org/linux_server/)
- [鸟哥的 Linux 私房菜 基础学习篇](http://cn.linux.vbird.org/linux_basic/linux_basic.php) 



<br/>



## 1. 命令行提示符

Linux命令行结尾的提示符有 “#” 和 “$” 两种不同的符号

```shell
[root@hostname ~]#        # <==这是超级管理员root用户对应的命令行。
[hostname@hostname ~]$    # <==这是普通用户oldboy对应的命令行。
```

> 命令行提示符@前面的字符代表当前登录的用户（可用whoami查询）
>
> @后面的为主机名（可用hostname查询）



<br/>

Linux命令提示符由PS1环境变量控制

```shell
set|grep PS1            # 注意PS要大写

> PS1='[\u@\h \W]\$ '   # 可以通过全局配置文件/etc/bashrc或/etc/profile进行按需配置和调整
```



<br/>



## 2. 查看命令帮助

<span style="font:normal bold 25px '宋体',sans-serif; color:blue"> 使用 man 或 --help 获取命令帮助信息</span>：

man命令是Linux系统中最核心的命令之一，因为通过它可以查看其他Linux命令的使用信息。

当然了，man命令不仅可以查看命令的使用帮助，还可以查看软件服务配置文件、系统调用、库函数等的帮助信息



```shell
man ls                        # 使用man 产看 ls 相关的信息

ls --help                     # --help 虽然有时这个输出很简单，但是相应地查看起来也会更方便
```

工作中建议结合使用，“命令--help”获取的是常用的帮助信息，“man命令”获取的是更多更复杂的帮助信息

<br/>



<span style="font:normal bold 25px '宋体',sans-serif; color:blue">使用help命令</span>：

在Linux系统里有一些特殊的命令，它们就是bash程序的内置命令，例如 `cd、history、read` 等，这些命令在系统目录里不存在真实的程序文件（存在于bash程序里），对于这部分命令，查看帮助的方法就是使用help命令

```shell
help cd            # 如果使用man cd，那么通常是查不到帮助信息的，而是会进入bash的帮助页面
```

<br/>



<span style="font:normal bold 25px '宋体',sans-serif; color:blue"> 使用info获取帮助信息</span>：

Linux系统中的info命令是一个查看程序对应文档信息的命令，可以作为man及help命令的帮助补充，不过一般在企业运维工作中，很少会有机会需要使用info去查询命令的使用帮助，因此，知道有这个命令就可以了，普通读者无需关注太多。使用info命令查看命令帮助的语法操作和man类似



<br/>



## 3. 关机重启注销

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">重启或关机命令：shutdown </span>：

shutdown是一个用来安全关闭或重启Linux系统的命令，系统在关闭之前会通知所有的登录用户，系统即将关闭，此时所有的新用户都不可以登录，与shutdown功能类似的命令还有init、halt、poweroff、reboot。

1）注意shutdown命令和后面的选项之间至少要有一个空格。

2）通常情况下，我们执行的shutdown命令为 `shutdown -h now` 或 `shutdown -r now`。



![image-20220314140009085](vx_images/image-20220314140009085.png)



> shutdown命令的工作过程就是当用户执行了对应参数并附带关机时间的命令之后，
>
> 通知所有用户即将关机的信息，并且在这个时间段内禁止新用户登录，
>
> 仅当到了指定的关机时间时，shutdown命令才会根据所接收的参数选项，发送请求给系统的init进程，请求将系统调整到对应参数的状态（例如-h参数），系统关机状态实际上对应的是Linux系统里的运行级别0。
>
> 和系统关机相关的运行级别有：0（关机运行级别）-halt，6（重启运行级别）-reboot，更多相关内容可查看/etc/inittab文件。



<br/>

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">关机与重启命令：halt/poweroff/reboot</span>：

从RedHat或CentOS 6开始，你会发现halt、poweroff、reboot这三个命令对应的都是同一个man帮助文档，而halt和poweroff命令是reboot命令的链接文件，通常情况下，我们执行这三个命令时都不带任何参数。

> 为什么halt、poweroff命令是reboot命令的链接文件，但是分别执行命令后效果不一样呢？
>
> 查看一下reboot命令的man帮助，可以发现reboot命令有2个参数--halt和--power-off，作用分别和halt、poweroff命令一样。

<br/>

![image-20220314141234604](vx_images/image-20220314141234604.png)



<br/>



## 4. 查看系统信息

linux查看cpu、内存、版本信息

```shell
# 查看CPU信息
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c 
cat /proc/cpuinfo | grep physical | uniq -c 


getconf LONG_BIT   
#32 (说明当前CPU运行在32bit模式下, 但不代表CPU不支持64bit) 

cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l  
# 8 (结果大于0, 说明支持64bit计算. lm指long mode, 支持lm则是64bit) 


dmidecode | grep "Product Name"    # 查看机器型号 

lsb_release -a  # 查看操作系统版本


# 查看内存信息
free
cat /proc/meminfo  # 查看详细内存信息 

```



<br/>

## 5. Linux语言设置

```shell

locale                  # 查看当前使用的语言

locale -a               # 查看系统中可以使用的语言


vi /etc/locale.conf     # 修改以下内容（LANG="zh_CN.UTF-8" ==> LANG="en_US.UTF-8" ）

#LANG="zh_CN.UTF-8"
LANG="en_US.UTF-8"


```



<br/>



# 二 文件与目录管理



<span style="font:normal bold 25px '宋体',sans-serif; color:blue"> ls：显示目录下的内容及相关属性信息</span>：

ls 命令是Linux下最常用的指令之一。

ls命令可以理解为英文单词list的缩写，其功能是列出目录的内容及其内容属性信息（list directory contents）。

该命令有点类似于DOS系统下的dir命令，有趣的是，Linux下其实也有dir命令，但我们更习惯于使用ls。

<br/>

**常用参数：** 

| 常用参数 | 参数说明                                         |
| :------: | ------------------------------------------------ |
|    -a    | 显示所有文件及目录 (包括以“.”开头的隐藏文件)     |
|    -l    | 使用长格式列出文件及目录信息                     |
|    -r    | 将文件以相反次序显示(默认依英文字母次序)         |
|    -t    | 根据最后的修改时间排序                           |
|    -A    | 同 -a ，但不列出 “.” (当前目录) 及 “..” (父目录) |
|    -S    | 根据文件大小排序                                 |
|    -R    | 递归列出所有子目录                               |

<br/>

```

stat命令：用于显示文件的状态信息。stat命令的输出信息比ls命令的输出信息要更详细

```



<br/>



<span style="font:normal bold 25px '宋体',sans-serif; color:blue"> pwd：显示当前所在的位置</span> ：

```shell

pwd命令是 “print working directory” 中每个单词的首字母缩写，其功能是显示当前工作目录的绝对路径。

在实际工作中，我们在命令行操作命令时，经常会在各个目录路径之间进行切换，此时可使用pwd命令快速查看当前我们所在的目录路径。

```



<br>



<span style="font:normal bold 25px '宋体',sans-serif; color:blue">cd：切换目录</span>：

```shell

# cd命令是 “change directory” 中每个单词的首字母缩写，其功能是从当前工作目录切换到指定的工作目录。

cd -                 # 返回当前用户上一次所在的目录
cd ..                # 切换到当前目录的上一级目录
cd ~                 # 进入当前用户的家目录
```



<br/>



## 1. mkdir和touch

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">mkdir：创建目录</span>：

```shell
# mkdir命令是“make directories”中每个单词的粗体字母组合而成，其功能是创建目录，
# 默认情况下，如果要创建的目录已存在，则会提示此文件已存在；而不会继续创建目录。

mkdir dir1 dir2                # mkdir命令可以同时创建多个目录


# 使用-p参数递归创建目录, 加-v参数显示创建目录的过程(其实这个-v没有什么实际用途)
mkdir -p dir/test
mkdir -pv dir/test
```

使用mkdir创建多级目录时，建议直接使用-p参数，可以避免出现“No such file or directory”这样没有文件或目录的报错了，不会影响已存在的目录。

<br/>

```shell
# 同时创建多个目录及多级子目录 (注意大括号内不能有空格)

mkdir -pv dir/{dir_1,dir_2}/{dir_a,dir_b}

```



<br/>



<span style="font:normal bold 25px '宋体',sans-serif; color:blue">touch：创建空文件或改变文件的时间戳属性</span>：

touch命令有两个功能：一是创建新的空文件；二是改变已有文件的时间戳属性。

特别说明：

1）注意区分touch和mkdir命令的功能，mkdir命令是创建空目录，而touch是创建空文件。

2）在Linux中，一切皆文件。虽然touch命令不能创建目录，但是可以修改目录的时间戳。

![image-20220314220906574](vx_images/image-20220314220906574.png)

<br/>

```shell

touch a.txt b.txt          # 创建多个文件

touch log{01..05}          # log01  log02  log03  log04  log05  (注意是两个点)

```

<br/>



## 2. 修改文件时间

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">文件时间</span>：

- **modifiy time (mtime)**：

  当该文件的『内容』变更时，就会升级这个时间！内容数据指的是文件的内容，而不是文件的属性或权限喔！

- **changetime (ctime)**：

  当该文件的『状态 (status)』改变时，就会升级这个时间，举例来说，像是权限与属性被更改了，都会升级这个时间啊。

- **access time (atime)**：

  当『该文件的内容被读取』时，就会升级这个读取时间 (access)。

  举例来说，我们使用 cat 去读取 /etc/man_db.conf， 就会升级该文件的 atime 了。

```shell

# 查看 文件时间

ls -l 文件名                      # 查看 mtime

ls -l --time=ctime 文件名         # 查看 ctime

ls -l --time=atime 文件名         # 查看 atime

```

示例：

![image-20220401102014938](vx_images/image-20220401102014938.png)

<br/>

```shell

touch 这个命令的两个常见功能：

1. 创建一个空的文件；

2. 将某个文件的所有日期更新为系统当前时间， 或将(mtime 与 atime)修改为指定时间 

```

<br/>

![image-20220401105626927](vx_images/image-20220401105626927.png)

<br/>

![image-20220401110013639](vx_images/image-20220401110013639.png)

<br/>

change time 只能通过修改系统时间来自定义（但是一般情况下修改系统时间需要root权限）

```shell

[root@DevMachine temp]# date -s 06/06/2022 >> a.bash

# 文件的atime和mtime已经改变，但是ctime时间没变
[root@DevMachine temp]# stat a.bash
  File: ‘a.bash’
  Size: 29              Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 67415159    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Context: unconfined_u:object_r:admin_home_t:s0
Access: 2022-03-03 23:23:00.000000000 +0800
Modify: 2022-06-06 00:00:00.000000000 +0800
Change: 2022-06-06 00:00:00.000000000 +0800
 Birth: -
 
#此时系统时间已经改变
[root@DevMachine temp]# date "+%F %T"
2022-06-06 00:00:56

# 更新系统时间为正常时间
[root@DevMachine temp]# /usr/sbin/ntpdate ntp.api.bz
 1 Apr 11:21:35 ntpdate[1803]: step time server 114.118.7.161 offset -5661630.439834 sec

# 系统时间已经更新正常
[root@DevMachine temp]# date "+%F %T"
2022-04-01 11:21:44

# 系统时间已经还原，ctime修改已完成
[root@DevMachine temp]# stat a.bash
  File: ‘a.bash’
  Size: 29              Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 67415159    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Context: unconfined_u:object_r:admin_home_t:s0
Access: 2022-03-03 23:23:00.000000000 +0800
Modify: 2022-06-06 00:00:00.000000000 +0800
Change: 2022-06-06 00:00:00.000000000 +0800
 Birth: -
 
```



<br/>



## 3. 复制移动删除

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">cp：复制文件或目录</span>:

cp命令可以理解为英文单词copy的缩写，其功能为复制文件或目录。

![image-20220314221359831](vx_images/image-20220314221359831.png)



```shell

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.ori

```



<br/>

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">mv：移动或重命名文件</span>:

mv命令可以理解为英文单词move的缩写，其功能是移动或重命名文件（move/rename files）

```shell

mv a.txt b.txt             # 若b.txt 不存在，则将 a.txt 重命名为 b.txt

```



<br/>

<span style="font:normal bold 25px '宋体',sans-serif; color:blue"> rm：删除文件或目录</span>:

rm命令可以理解为英文单词remove的缩写，其功能是删除一个或多个文件或目录（remove files or directories）。

这是Linux系统里最危险的命令之一，请慎重使用。

![image-20220314222403039](vx_images/image-20220314222403039.png)



```shell

rm -rf dir                   # 递归强制删除dir目录及其内部文件和目录

```



<br/>

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">rmdir：删除空目录</span>:

rmdir命令用于删除空目录（remove empty directories），当目录不为空时，命令不起作用

rmdir命令在实际工作中使用的极少





<br/>



## 4. 查看文件内容

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">  cat、tac、nl 直接查看文件内容</span> : 

- cat 由第一行开始显示文件内容，cat 是 Concatenate （连续）的简写
- tac 从最后一行开始显示，可以看出 tac 是 cat 的倒著写！
- nl  显示的时候，顺道输出行号！

这些命令在文件行数较多时使用并不方便、推荐使用下面介绍的 more 和 less



<br/>

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">  more、less 分页查看文件</span> : 

- more 一页一页的显示文件内容

  ```shell
  空白键 (space)  ：代表向下翻一页；
  Enter          ：代表向下翻『一行』；
  /字串           ：代表在这个显示的内容当中，向下搜寻『字串』这个关键字；
  :f             ：立刻显示出档名以及目前显示的行数；
  q              ：代表立刻离开 more ，不再显示该文件内容。
  b 或 [ctrl]-b  ：代表往回翻页，不过这动作只对文件有用，对管线无用。
  ```

  <br>

- less 与 more 类似，但是比 more 更好的是，他可以往前翻页！

  ```
  空白键       ：向下翻动一页；
  [pagedown]  ：向下翻动一页；
  [pageup]    ：向上翻动一页；
  /字串        ：向下搜寻『字串』的功能；
  ?字串        ：向上搜寻『字串』的功能；
  n           ：重复前一个搜寻 (与 / 或 ? 有关！)
  N           ：反向的重复前一个搜寻 (与 / 或 ? 有关！)
  q           ：退出 less 这个程序；
  ```



<br/>

<span style="font:normal bold 25px '宋体',sans-serif; color:blue">  head、tail 从头（尾）查看文件（指定行数）</span> : 		

- head  只看头几行 （若没有加上 -n 这个选项时，默认只显示十行）
- tail     只看尾巴几行 （默认也是显示十行，若要显示非十行，就加 -n number 的选项即可）

```shell

head -n 1 /etc/my.cnf            # 查看第一行文件

tail -n +100 /etc/man_db.conf    # 代表该文件从100行以后都会被列出来

```

<br/>

```shell 

# 例题：假如我想要显示 /etc/man.config 的第 11 到第 20 行呢？

# 答：先取前 20 行，再取后十行，所以结果就是：

head -n 20 /etc/man_db.conf | tail -n 10 

```



<br/>



## 5. 压缩和解压缩

```shell 
在Linux操作系统中，默认支持两种压缩格式
	1   .tar.gz
	2   .zip
	
	
不同的压缩格式可以使用不同的软件来解压与压缩

 1  .tar.gz  这种压缩格式其实是Linux比较传统的压缩格式，需要借助于tar命令
   
     tar -zcvf name.tar.gz test            # 压缩
  
     tar -zxvf name.tar.gz -C targetDir    # 解压   -C 表示解压到指定的路径下
 
   
 2   .zip
 
    zip name.zip fileName                   # 压缩
  
    unzip name.zip                          # 解压
  
```



<br/>



## 6. 追加与重定向

```shell

重定向：可以把控制台输出的内容重定向到文件中。
	   如果文件不存在，那么会创建文件
	   如果文件已经存在，那么会覆盖文件中的内容
	   echo 'bob' > 1.txt
	   ll > 2.txt
	   
	   
追加： 其实就是在指定文件的末尾追加控制台输出的内容
	  不会覆盖原来文件中的内容
	  如果文件不存在，依然会创建文件
	  ll >> 2.txt

```



<br/>



# 三 用户与权限管理

## 1. 用户和组管理

用户管理：

```shell

sudo useradd -m -s /bin/bash username         # 创建 `username` 用户
#  useradd     创建用户的命令
#  -m          指创建用户逇同时给这个用户创建一个家目录
#  -s          指定shell的版本为bash
#  username：  用户名称


sudo userdel [-r] username                    # 删除用户
#  userdel     删除用户的命令
#  -r          指删除用户的同事，还要删除用户的家目录
#  username：  用户名


sudo passwd username                          # 给用户设置密码


su username                                   # 切换用户

```

<br/>



组管理：

```shell

# 添加组
sudo groupadd groupName

# 添加用户的时候指定组
sudo useradd -m -s /bin/bash -g groupName username

# 查询用户所属的组的信息
id username

# 修改组
sudo usermod -g groupName username

```



<br/>



## 2. 文件权限管理

Linux里面，任何一个文件都具有『User, Group及Others』三种身份的权限

![image-20220401204409112](vx_images/image-20220401204409112.png)

<br/>

rwx这三个参数对文件和目录的意义是不同的，如下：

| 参数 |      文件       |               目录               | 权限分数 |
| :--: | :-------------: | :------------------------------: | :------: |
|  r   |   可读(read)    |  r (read contents in directory)  |    4     |
|  w   |   可写(write)   | w (modify contents of directory) |    2     |
|  x   | 可执行(execute) |       x (access directory)       |    1     |

<br/>

```shell

r (read)：     可读取此一文件的实际内容，如读取文本文件的文字内容等；
w (write)：    可以编辑、新增或者是修改该文件的内容(但不含删除该文件)；
x (execute)：  该文件具有可以被系统执行的权限。


r (read contents in directory)：
表示具有读取目录结构列表的权限，所以当你具有读取(r)一个目录的权限时，表示你可以查询该目录下的文件名数据。 
所以你就可以利用 ls 这个指令将该目录的内容列表显示出来！

w (modify contents of directory)：
可写入权限对目录来说表示你具有操作该目录结构列表的权限，也就是底下这些权限：
    - 建立新的文件与目录；
    - 删除已经存在的文件与目录(不论该文件的权限为何！)
    - 将已存在的文件或目录进行更名；
    - 移动该目录内的文件、目录位置。

x (access directory)：
目录不可以被执行，目录的x代表的是用户能否进入该目录成为工作目录的用途！ 
所谓的工作目录(work directory)就是你目前所在的目录！
举例来说，当你登入Linux时， 你所在的家目录就是你当下的工作目录。而变换目录的指令是『cd』(change directory)

```

<br/>



<span style="font:normal bold 25px '宋体',sans-serif; color:blue"> chmod：修改文件的权限</span>: 

```shell

# 方式一：
sudo chmod u=rwx,g=rw,o=r fileName
# u：表示文件拥有者
# g：表示同组的成员
# o：表示其他组的成员


# 方式二：通过数字来指代权限
sudo chmod 764 fileName

```

<br/>

```shell

# 一些常见情景例：

如果要将该文件变成可执行文件，并且不让其他人修改的话， 那么就需要 -rwxr-xr-x 这样的权限，即 chmod 755 test.sh 

如果有些文件你不希望被其他人看到，那么应该将文件的权限设定为： -rwxr----- ， 即 chmod 740 filename 

```



<br/>



# 四 进程与服务管理

## 1. Linux进程管理

```shell

# 查看进程
ps
# -e 显示所有的进程
# -f 全格式

# a 表示显示终端上所有的进程
# u 以用户的格式来显示进程信息
# x 显示后台运行的进程


# 一般查询进程，分为两种方式 ps -ef 、 ps aux
ps -ef  可以显示父进程的信息
ps aux  可以显示进程占用的资源信息


# 搜索进程（常用）
ps -ef | grep 进程名或进程id
ps aux | grep 进程名或进程id


# 关闭进程
kill -9 pid      # 强制关闭进程，从操作系统内核级别杀死进程
kill -15 pid     # 让内核通知应用主动关闭

```



<br/>

## 2. Linux服务管理







<br/>



# 五 SSH和网络管理

## 1. 常用网络工具

```shell

# 安装网络管理工具
sudo apt install net-tools

# 查看ip
ifconfig

# 通过网络中的心跳机制查看网络是否正常
ping ip


# 端口号查询
netstat -anp | grep port

lsof -i:port

# windows下
netstat -ano | findstr port

```



<br/>



## 2. SSH远程连接

```shell

# 首先需要给远程服务器（Linux服务器）安装ssh

## 搜索ssh是否已经安装
ps -ef | grep ssh


# 假如没有搜索到，则需要安装ssh服务
apt update

# 安装ssh
sudo apt install openssh-server

# 重启ssh
sudo service ssh restart 

# 执行完了以上指令之后，我们可以搜索ssh服务是否已经启动
ps -ef | grep ssh

```

阿里云、华为云、腾讯云等云服务器会默认安装好ssh服务。













<br/>



