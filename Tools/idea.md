# 一 idea





# 二 常用快捷键




# 三 常用设置及问题



## 1. Cannot Download Sources

利用idea自动下载源码时，提示Cannot Download Sources、IDEA 出现Cannot Download Sources 的解决办法：

点击terminal，在其中命令台中 输入 ：

```
mvn dependency:resolve -Dclassifier=sources
```

如图：

![image-20211101162525695](vx_images/image-20211101162525695.png)

