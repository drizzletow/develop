
 接口隔离原则（Interface Segregation Principle，ISP）


 ## 接口隔离原则的定义
- Clients should not be forced to depend upon interfaces that they don't use.（客户端不应该依赖它不需要的接口。）
- The dependency of one class to another one should depend on the smallest possible interface.（类间的依赖关系应该建立在最小的接口上。）

## 实践与应用
接口隔离原则是对接口的定义，同时也是对类的定义，接口和类尽量使用原子接口或原子类来组装。但是，这个原子该怎么划分是设计模式中的一大难题，在实践中可以根据以下几个规则来衡量：
- 一个接口只服务于一个子模块或业务逻辑；
- 通过业务逻辑压缩接口中的public方法，接口时常去回顾，尽量让接口达到“满身筋骨肉”，而不是“肥嘟嘟”的一大堆方法；
- 已经被污染了的接口，尽量去修改，若变更的风险较大，则采用适配器模式进行转化处理；
- 了解环境，拒绝盲从。每个项目或产品都有特定的环境因素，别看到大师是这样做的你就照抄。千万别，环境不同，接口拆分的标准就不同。深入了解业务逻辑，最好的接口设计就出自你的手中！


<br/>

接口分为两种：
- 实例接口（Object Interface），在Java中声明一个类，然后用new关键字产生一个实例，它是对一个类型的事物的描述，这是一种接口。
    比如你定义Person这个类，然后使用 ```Person zhangSan=new Person()``` 产生了一个实例，这个实例要遵从的标准就是Person这个类，Person类就是zhangSan的接口。疑惑？看不懂？不要紧，那是因为让Java语言浸染的时间太长了，只要知道从这个角度来看，Java中的类也是一种接口。
- 类接口（Class Interface），Java中经常使用的interface关键字定义的接口