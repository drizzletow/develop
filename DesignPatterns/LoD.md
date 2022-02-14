
 迪米特法则（Law of Demeter，LoD））也称为最少知识原则（Least Knowledge Principle，LKP）

## 迪米特法则的定义
Talk only to your immediate friends and not to strangers （只与直接的朋友通信。）

- 一个方法尽量不引入一个类中不存在的对象（当然，JDK API提供的类除外）
- 如果一个方法放在本类中，既不增加类间关系，也对本类不产生负面影响，那就放置在本类中

人和人之间是有距离的，太远关系逐渐疏远，最终形同陌路；太近就相互刺伤。对朋友关系描述最贴切的故事就是：两只刺猬取暖，太远取不到暖，太近刺伤了对方，必须保持一个既能取暖又不刺伤对方的距离。迪米特法则就是对这个距离进行描述，即使是朋友类之间也不能无话不说，无所不知。

## 迪米特法则的实现与注意事项
从迪米特法则的定义和特点可知，它强调以下两点：
- 从依赖者的角度来说，只依赖应该依赖的对象。
- 从被依赖者的角度说，只暴露应该暴露的方法。

<br/>

所以，在运用迪米特法则时要注意以下 6 点：
- 在类的划分上，应该创建弱耦合的类。类与类之间的耦合越弱，就越有利于实现可复用的目标。
- 在类的结构设计上，尽量降低类成员的访问权限。
- 在类的设计上，优先考虑将一个类设置成不变类。
- 在对其他类的引用上，将引用其他对象的次数降到最低。
- 不暴露类的属性成员，而应该提供相应的访问器（set 和 get 方法）。
- 谨慎使用序列化（Serializable）功能。