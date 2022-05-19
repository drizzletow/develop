# 一 nvm/npm
## 1. nvm
管理不同版本的 node 与 npm
1. nvm的安装: 首先一定要卸载已安装的 NodeJS，否则会发生冲突。然后下载 [nvm-windows](https://github.com/coreybutler/nvm-windows/releases) 最新安装包，直接安装即可。
<br/>
2. 配置nvm的node下载源
安装完成后，找到nvm文件夹下settings.txt，新增下面内容(下载源)   默认地址： C:\Users\t\AppData\Roaming\nvm

```shell
arch: 64 
proxy: none 
node_mirror: http://npm.taobao.org/mirrors/node/ 
npm_mirror: https://npm.taobao.org/mirrors/npm/
```


<br/>

3. 使用nvm安装管理多版本 [node](http://nodejs.cn/)/npm

```shell
nvm version
nvm list
nvm ls                  #列出已安装实例（node/npm）
nvm ls available        #列出远程服务器上所有的可用版本 (linux/mac使用：nvm ls-remote)
nvm install 14.19       #每当我们安装了一个新版本 Node 后，全局环境会自动把这个新版本设置为默认
nvm install 16.14       #安装16.14

nvm use 16.14                       #在不同版本间切换 
nvm alias awesome-version 16.14     #给 16.14 这个版本号起了一个名字叫做 awesome-version
nvm use awesome-version
nvm unalias awesome-version         #取消别名

```
<br/>
4. 在项目中使用不同版本的 Node
可以通过创建项目目录中的 .nvmrc 文件来指定要使用的 Node 版本。之后在项目目录中执行 nvm use 即可。.nvmrc 文件内容只需要遵守上文提到的语义化版本规则即可。另外还有个工具叫做 [avn](https://github.com/wbyoung/avn)，可以自动化这个过程。
在多环境中，npm该如何使用呢？每个版本的 Node 都会自带一个不同版本的 npm，可以用 npm -v 来查看 npm 的版本。
但问题来了，我们安装过的 npm 包，都要重新再装一次？幸运的是，我们有个办法来解决我们的问题，运行下面这个命令，可以从特定版本导入到我们将要安装的新版本 Node：

```shell
nvm install 14.19 --reinstall-packages-from=12
```
<br/>

## 2. npm
全名 node package manger，是随同NodeJS一起安装的包管理工具

```shell
#配置 npm 淘宝镜像
npm config list                                                #检查 npm 镜像地址
npm config set registry https://registry.npm.taobao.org        #配置 npm 淘宝镜像

npm install -g cnpm --registry=https://registry.npm.taobao.org #将npm替换为cnpm

npm -v                                                         #查看 npm 版本号
```
<br/>
1. npm包管理 （[模块API查询](https://npm.taobao.org/)）

```shell
#npm查看模块
#良好的操作习惯是在安装模块时使用​ --save​ 将安装了哪些模块都记录在 ​package.json​ 中，这样如果要查询可以直接去 ​package.json​ 中查看即可

npm list -g                                            #查看全局模块
npm list                                               #查询已安装的本地模块，但前提是当前目录下有 ​node_modules ​目录

# --depth=0​ 表示查询模块，只显示第一层级的模块。这里的 0 如果换成 1 就是显示第一层级和第二层级的模块，依次类推
npm list -g --depth=0                                  #查看全局模块的一级目录
npm list --depth=1                                     #查询本地模块的两级目录
```

```shell
#安装
npm install express                                    # .\node_modules
npm install express -g                                 # C:\Program Files\nodejs\node_modules

npm list -g --depth=0                                  #查询全局模块安装路径

npm install react-router@3.*                           #安装指定版本的模块(该例表示第三版中最新的包)
npm install antd babel-plugin-import                   #同时安装多个模块

npm install                                            # 安装 package.json 中的包，当然前提是有 package.json 并且里面配置了相关包信息

npm install antd --save                                #​--save​ 将安装的模块信息记录在​ package.json​ 文件的dependencies属性下(生产)
npm install antd --save-dev                            #-​-save-dev 将模块信息记录到 ​package.json​ 文件的devDependencies属性下(开发)
```

```shell
#卸载
npm uninstall lodash                                   #只卸载模块， package.json 中的记录仍然存在
npm uninstall lodash --save                            #卸载模块的同时删除在 package.json 文件中的记录
npm uninstall lodash@3.*                               #卸载 lodash 模块 3.* 版本

#应用场景：
#dk 在项目中先安装了 lodash 4.17.4 版本的模块；后来发现这个版本太高，存在一些新 bug 没有解决，不适合项目中使用；
#dk 想要安装版本更加稳定的3.* 版本， 于是敲入指令 $ npm install lodash@3.*；
#到这里就注意了，虽然第二次安装了 3.* 版本，但是由于之前的 4.* 版本并没有卸载，此时在本地安装路径中可以发现有两个版本 lodash 的模块，
#而 npm 默认在使用时会优先调用高版本的模块。这时将之前版本进行卸载，$ npm install lodash，会默认卸载高版本的模块。
```

```shell
#更新
npm update lodash                                      #更新到小版本号最新的那个版本，但不会更新到大版本号

#例：lodash ​的版本号有：​3.9.1​、​3.10.1​、​4.13.1​ ， 当前已经安装的 ​lodash ​版本是 ​3.9.1​， 此时执行下列命令：
npm update lodash@4.13.1 --save                        #此时由于对大版本号进行更新，结果没有任何响应，依然是 ​3.9.1 ​版本
npm update lodash@3.10.* --save                        #此时并没有更改大版本号，更新结果为 ​lodash ​的版本变成了 ​3.10.1 ​版本

npm update lodash --save                               #更新模块的同时将更新信息记录到 ​package.json​ 文件中
```
<br/>
2. npm 版本规则

（1）npm 发布包的版本指定规则：使用 Npm 发布一个包的时候，往往要遵循 x.y.z 的规则，发布的第一个版本一般为 1.0.0。
- x 大版本号。引入新的变化，破坏向后兼容，x 值 +1 变成 2.0.0
- y 小版本号。增加一个新功能，且不影响已有功能，y 值 +1 变成 1.1.0
- z 补丁号。修改某个功能的 Bug 时，z 值 +1 变成 1.0.1

<br/>

（2）关于向后兼容与向前兼容：向前兼容和向后兼容可以用下面这个例子方便理解：
- 向后兼容：Windows 10要能运行为Windows 3.1开发的程序；
- 破坏向后兼容：新版本的系统不能运行老版本系统上的程序，可以理解为整容的跟以前完全不一样了；
- 向前兼容：Windows 3.1要能运行为Windows 10开发的程序。
<br/>
（3）package.json 中包版本 ~ 与 ^ 说明
- `~1.4.0`表示：`>=1.4.0 && < 1.5.0` 说明：小版本不变，补丁号可以取最大值
- `^1.4.0`表示：`>=1.4.0 && < 2.0.0` 说明：大版本号不变，小版本号可以取最大值


<br>

## 3. python

部分npm组件在安装时只支持python2版本，如果本地python环境变量是设置的python3，则会导致错误。

解决方法，安装时执行，指定python版本

npm install --python=python2

或者直接修改npm的python版本设置

npm config set python python2

这样npm install时，如果需要调用node-gyp编译，会使用指定的python执行。
