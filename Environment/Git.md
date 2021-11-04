# 一 本地代码仓库
[Git教程](https://github.com/geeeeeeeeek/git-recipes)

![](_v_images/20201108160139770_24883.png)
## 1. Git基础配置
**【Git配置】**: 在使用 git 前，需要告诉 git 你是谁，在向 git 仓库中提交时需要用到。
1. 配置提交人姓名：`git config --global user.name 提交人姓名`
2. 配置提交人姓名：`git config --global user.email 提交人邮箱` 
3. 查看git配置信息：`git config --list`   
>如果要对配置信息进行修改，重复上述命令即可。
>配置只需要执行一次。



## 2. 搭建本地仓库
1. `git init` ——初始化git仓库（创建新的 git 仓库）[更多](https://github.com/geeeeeeeeek/git-recipes/wiki/2.2-创建代码仓库)
2. `git status`  ——经常被用于查看仓库状态，列出已缓存、未缓存、未追踪的文件。
3. `git add 文件列表`  —— 添加到缓存区 [更多](https://github.com/geeeeeeeeek/git-recipes/wiki/2.3.1-Git-add)
4. `git commit -m 提交信息`   ——向本地仓库中提交代码
5. `git log`  ——查看提交记录


## 3. 撤销与删除

- `git checkout <commit>` —— 更新工作目录中的所有文件，使得和某个特定提交中的文件一致。
- `git checkout <commit> <file>` —— 它将工作目录中的 `<file>`文件变成` <commit> `中那个文件的拷贝，**并将它加入缓存区**。 [更多](https://github.com/geeeeeeeeek/git-recipes/wiki/2.5-检出之前的提交)


- 将文件从暂存区中删除： `git rm --cached 文件`
- 将 git 仓库中指定的更新记录恢复出来，并且覆盖暂存区和工作目录：`git rest --hard commitID` 


# 二 远程代码仓库
## 1. 远程仓库连接

```shell
git remote -v                            #列出你和其他远程仓库之间的连接（-v 同时显示每个连接的 URL）
git remote add <name> <url>              #创建一个新的远程仓库连接。在添加之后，你可以将 <name> 作为 <url> 便捷的别名在其他 Git 命令中使用
git remote rm <name>                     #删除名为<name>的远程仓库连接
git remote rename <old-name> <new-name>  #将远程连接从 <old-name> 重命名为 <new-name>

#需要将代码同时推送到多个远程仓库的情形：
git remote add origin https://gitee.com/drizzletow/develop.git
git remote set-url --add origin https://github.com/drizzletow/develop.git
```

## 2. 代码推送到远程仓库

```shell
git push <远程主机名> <本地分支名>:<远程分支名>   #将本地分支的更新，推送到远程主机(这里的:前后是必须没有空格)

#将本地的master分支推送到origin主机的master分支,如果后者不存在，则会被新建
git push -u origin master      #-u选项指定一个默认主机，这样后面就可以不加任何参数使用git push

git push origin                #如果当前分支与远程分支之间存在追踪关系，则本地分支和远程分支都可以省略
git push                       #如果当前分支只有一个追踪分支，那么主机名都可以省略
```

```shell
#慎用！删除远程仓库的分支
git push origin :master          #推送一个空的本地分支到远程分支,等同于:
git push origin --delete master

git push -f origin master        #强制用本地的代码去覆盖掉远程仓库的代码 (-f为force，意为：强行、强制)
```

# 三 其他情景
## 1.  ssh免登陆

生成秘钥：`ssh-keygen`

秘钥存储目录：C:\Users\用户\\.ssh

公钥名称：id_rsa.pub

私钥名称：id_rsa

```bash
ssh-keygen -t rsa -C "msdrizzle@outlook.com"    #进入gitbash , 使用如下命令，连续三次回车
cat ~/.ssh/id_rsa.pub                           #查看公钥 (然后登录Gitee,在设置中找到SSHKEY将id_rsa.pub文件的内容复制进去即可)
ssh -T git@gitee.com -y                         #测试是否成功
```



## 2. 中文乱码问题
```bash
git config --global core.quotepath false             #git status 乱码解决方法
git config --global i18n.commitencoding utf-8        #git commit 乱码解决方法
git config --global i18n.logoutputencoding utf-8     #git status 乱码解决方法

#注意：如果是Linux系统，需要设置环境变量 export LESSCHARSET=utf-8
```