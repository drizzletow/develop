### 标题
```md
# This is an <h1> tag
## This is an <h2> tag
###### This is an <h6> tag
```

**注意**：

- `#`之后需要至少一个空格；
- 一个标题应该占一整行；

### 强调
```md
*This text will be italic*  
_This text will be italic_  

**This text will be bold**  
__This text will be bold__
```


**注意**：

- VNote推荐使用`*`；
- 如果渲染错误，请尝试在第一个`*`之前以及最后一个`*`之后添加一个空格。如果被标记的文本是以全角符号开始或结尾，一般都需要前后添加一个空格；
- VNote提供快捷键`Ctrl+I`和`Ctrl+B`来插入斜体和粗体；

### 空一行
```
<br />
```

### 列表
#### 无序列表
```md
* Item 1  
只是一段在Item 1下面的文字。需要注意上面一行结尾有两个空格。
* Item 2
    * Item 2a
    * Item 2b
* Item 3

使用一个空行来来结束一个列表。
```

#### 有序列表
```md
1. Item 1
1. Item 2  
注意，列表前面的序号其实是无关紧要的，渲染时Markdown会自动修改该序号。
3. Item 3
    1. Item 3a
    2. Item 3b
4. Item 4
```

### 表格
```md
| col 1 | col 2 | col 3 |
| :-: | :-: | :-: |
| cell1 | cell2 | cell3 |
| cell4 | cell5 | cell6 |
```

### 图片和链接
```md
![Image Alt Text](/url/to/image.png "Optional Text")

![Image Alt Text](/url/to/image.png "Image specified with width and height" =800x600)

![Image Alt Text](/url/to/image.png =800x600)

![Image Alt Text](/url/to/image.png "Image specified with width" =800x)

![Image Alt Text](/url/to/image.png "Image specified with height" =x600)

[Link Text](/url/of/the/link)
```

**注意**：

- VNote不推荐使用参考式的图片链接。VNote不会预览这些图片。
- 声明图片尺寸只在 **markdown-it** 中支持。

### 块引用
```md
As VNote suggests:

> VNote is the best Markdown note-taking application
> ever.  
>
> THere is two spaces after `ever.` above to insert a
> new line.
```

**注意**：

- `>`标记后面需要至少一个空格；
- 多行连续的引用可以只在第一行添加标记；

### 代码块
    ```lang
    This is a fenced code block.
    ```

    ~~~
    This is another fenced code block.
    ~~~

**注意**：

- `lang`用于指定代码块的代码语言，可选；如果不指定，VNote不会尝试高亮代码；

### 图表

> 需要在`Markdown`菜单中启用Flowchart.js或Mermaid或WaveDrom，并重新打开当前标签页。

VNote支持使用以下引擎来绘制图表。您需要使用代码块，并标明特定语言，然后在代码块里面定义图表。

- [Flowchart.js](http://flowchart.js.org/)，语言为`flow`或`flowchart`；
- [Mermaid](https://mermaidjs.github.io/)，语言为`mermaid`；
- [WaveDrom](https://wavedrom.com/)，数字时序图，语言为`wavedrom`；

例如，

    ```flowchart
    st=>start: Start:>http://www.google.com[blank]
    e=>end:>http://www.google.com
    op1=>operation: My Operation
    sub1=>subroutine: My Subroutine
    cond=>condition: Yes
    or No?:>http://www.google.com
    io=>inputoutput: catch something...

    st->op1->cond
    cond(yes)->io->e
    cond(no)->sub1(right)->op1
    ```

#### UML

> 需要在设置中启用PlantUML。如果使用在线的PlantUML服务器，请注意隐私问题；如果使用本地PlantUML，可能需要安装Java运行时、PlantUML以及Graphviz。

VNote支持 [PlantUML](http://plantuml.com/) 来实现UML图表。您需要使用代码块，并标明语言为`puml`，然后在代码块里面定义图表。

    ```puml
    @startuml
    Bob -> Alice : hello
    @enduml
    ```

#### Graphviz

> 需要在设置中启用Graphviz。

VNote支持 [Graphviz](http://www.graphviz.org/) 来绘制图表。您需要使用代码块，并标明语言为`dot`，然后在代码块里面定义图表。

### 数学公式

> 需要在`Markdown`菜单中启用MathJax，并重启VNote。

VNote通过 [MathJax](https://www.mathjax.org/) 来支持数学公式。默认的**块公式**的分隔符是`$$...$$`，**行内公式**的分隔符是`$...$`。

- 行内公式不能跨多行；
- 形如`3$abc$`/`$abc$4`/`$ abc$`和`$abc $`的不会被解析为公式；
- 使用`\`转义`$`；
- 开始的`$$`之前以及结束的`$$`之后都只允许出现空格字符；

VNote也可以使用标明语言`mathjax`的代码块来实现块公式。

    ```mathjax
    $$
    J(\theta) = \frac 1 2 \sum_{i=1}^m (h_\theta(x^{(i)})-y^{(i)})^2
    $$
    ```

块公式支持公式序号：

    $$vnote x markdown = awesome$$ (1.2.1)

### 行内代码
```md
Here is a `inline code`.
```

如果想输入一个 `` ` ``，需要使用两个 `` ` `` 来括住它，例如 ``` `` ` `` ```。 要输入两个 `` ` ``，则需要使用三个 `` ` ``。

### 删除线
```md
Here is a ~~text~~ with strikethrough.
```

**注意**：

- VNote提供快捷键`Ctrl+D`来插入带有删除线的文本；

### 任务列表
```md
- [x] this is a complete item.
- [ ] this is an incomplete item.
```

### 脚注
```md
This is a footnote [^1].

[^1]: Here is the detail of the footnote.
```

### 上标和下标

> 需要在`Markdown`菜单中启用上标和下标并使用`Markdown-it`渲染引擎。

```md
This is the 1^st^ superscript.

This is the H~2~O subscript.
```

### 警告
使用`Markdown-it`渲染引擎时，可以添加警告信息。

```md
::: alert-info

这是一个信息文本。

:::

::: alert-danger

这是一个危险文本。

:::
```

可用的一些警告形式如下：

```
alert-primary
alert-secondary
alert-success
alert-info
alert-warning
alert-danger
alert-light
alert-dark
```

### 换行和段落
如果需要换行，您应该在当前行末尾添加两个空格，然后换行。VNote提供快捷键`Shift+Enter`来辅助用户输入两个空格并换行。

如果需要一个新的段落，您应该先插入一个空行然后才输入新的段落的文本。

一般来说，您应该在一个块元素（例如代码块、列表和块引用）后面插入一个空行来显式结束该元素。
