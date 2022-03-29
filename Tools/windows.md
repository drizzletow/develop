# 一 CMD命令



## T





code 



explore





<br/>





<br/>



# 二 Terminal

Windows 终端概述 ：https://docs.microsoft.com/zh-cn/windows/terminal/



<br/>



## 1. 安装gsudo

gsudo：管理员打开工具

GitHub：https://github.com/gerardog/gsudo

<br/>

```shell
# 安装方式：

1. 下载解压，配置环境变量即可


2. 通过 PowerShell 命令安装

winget install gsudo

```



Windows terminal默认是非管理员打开的，安装 gsudo 后 在powershell 或cmd设置项下将命令行改为

```shell
gsudo.exe powershell.exe -nologo  #或

gsudo.exe cmd.exe 
```

`-nologo`  参数作用是去掉启动时前面那一串版权声明等信息, 可以不加

如果不想要默认管理员打开, 上面命令行处可以不改, 在需要管理员权限的命令前加上sudo再运行就可以, 跟Linux一样



<br/>



## 2. 添加GitBash

从设置  `打开JSON文件` ，在 ` "profiles" --> "defaults"  -->  "list"` 中添加新的配置：

```JSON
"profiles": 
{
    "defaults": {},
    "list": 
    [
        {
            "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b7}",
            "hidden": false,
            "name": "Git Bash",
            "commandline": "gsudo \"C:\\Program Files\\Git\\bin\\bash.exe\"",
            "colorScheme":"One Half Dark",
            "icon": "C:\\Program Files\\Git\\mingw64\\share\\git\\git-for-windows.ico"
        }

    ]
}
```

 

注意： commandline 中 需要的是git安装目录下的  bin 下的 bash.exe，而不是 Git-Bash.exe



<br/>



## 3. 毛玻璃特效

下载字体：https://github.com/microsoft/cascadia-code/releases

解压后安装所有 ttf 字体 （为所有用户安装）



修改 JSON 文件：

```JSON
{
    "commandline": "gsudo.exe powershell.exe -nologo",
    // "commandline": "powershell.exe",
    "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "hidden": false,
    "name": "Windows PowerShell",
    // 添加如下内容
    "acrylicOpacity": 0.7,
    "colorScheme" : "Frost",
    "cursorColor" : "#000000",
    "fontFace" : "Cascadia Code PL",
    "useAcrylic": true
}
```



<br/>



## 4. Oh-My-Posh

官方文档和介绍：

https://ohmyposh.dev/docs/windows

https://www.powershellgallery.com/packages/oh-my-posh

<br/>



**安装字体**：

自定义命令提示符通常使用字形（图形符号）来设置提示符的样式。若要在终端中查看所有字形，

建议安装 [Nerd Font](https://www.nerdfonts.com/font-downloads)，进入网站，点击 Downloads 进入下载页面，随便下载一款字体，

推荐使用 **DejaVuSansMono Nerd Font** 或者 **Cousine Nerd Font**，这两款字体比较全，适配也还不错。

下载后解压安装字体即可

<br/>



**安装 oh-my-posh** ： 

以管理员方式打开 PowerShell  （注意网络不好可能会安装失败）

```shell
winget install JanDeDobbeleer.OhMyPosh
```

![image-20220327093741984](vx_images/image-20220327093741984.png)

<br/>

```shell

# 初始化 （只对当前打开的终端生效）

oh-my-posh init pwsh --config "E:\Package\Other\Terminal\oh-my-posh\themes\jandedobbeleer.omp.json" | Invoke-Expression

```

<br/>

```shell
# 配置永久生效 

code $profile   

# 该命令会使用VScode打开文件，将上述初始化命令加入其中即可 （配置后每次打开Powershell都会执行脚本文件中的命令）

```

<br/>

```shell

# 命令行自动补全和提示

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

```

<br/ >

最后设置一下字体和配色即可（修改JSON或在terminal界面中直接设置）：

```json 
"fontFace" : "DejaVuSansMono Nerd Font",
```

<br/>



```shell

# 常用提示符主题

honukai.omp.json

iterm2.omp.json

bubbles.omp.json

bubblesline.omp.json

capr4n.omp.json

cloud-native-azure.omp.json

di4am0nd.omp.json

grandpa-style.omp.json

hunk.omp.json

microverse-power.omp.json

# COOL

free-ukraine.omp.json

jv_sitecorian.omp.json

```

更多选择参照：https://ohmyposh.dev/docs/themes





<br/>





# 三 PowerShell

下载： https://docs.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-on-windows





## 1. SSH

```shell

ssh username@hostip



```













