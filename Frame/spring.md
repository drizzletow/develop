# 一 IoC Container

Spring Framework Introduction：https://spring.io/projects/spring-framework 

Spring Framework Documentation：https://spring.io/projects/spring-framework#learn

<br>

所有历史版本的PDF/HTML文档：https://docs.spring.io/spring-framework/docs/ 

Spring 的官方Github地址：https://github.com/spring-projects/spring-framework 



<br>



## 1. Introduction 

 the Inversion of Control (IoC) principle.

```bash

IoC is also known as dependency injection (DI). 
It is a process whereby objects define their dependencies (that is, the other objects they work with) only through constructor arguments, arguments to a factory method, or properties that are set on the object instance after it is constructed or returned from a factory method. 

The container then injects those dependencies when it creates the bean. 
This process is fundamentally the inverse (hence the name, Inversion of Control) of the bean itself controlling the instantiation or location of its dependencies by using direct construction of classes or a mechanism such as the Service Locator pattern.

```

<br>

```java

/**

1. 没有Spring框架时，我们需要自己创建User/Dao/Service，例如：

	UserSericeImpl userService = new UserServiceImpl();
	
2. 有了Spring框架，可以将原有Bean的创建工作转移给框架, 需要用时从Bean的容器中获取即可，
   这样便简化了开发工作（Bean的创建和使用分离了）
   
```

1. Spring框架管理Bean的创建工作，即由用户管理Bean转变为框架管理Bean，

   这个就叫**控制反转 - Inversion of Control (IoC)** 

2. Spring 框架托管创建的Bean放在哪里呢？ —— **IoC Container**;

3. Spring 框架为了更好让用户配置Bean，必然会引入**不同方式来配置Bean**

   ——  **xml配置，Java配置，注解配置**等

4. Spring 框架既然接管了Bean的创建，必然需要**管理整个Bean的生命周期**等；

5. 应用程序代码从Ioc Container中获取依赖的Bean，注入到应用程序中，

   这个过程叫 **依赖注入(Dependency Injection，DI)** ； 

   因此有人就说控制反转是通过依赖注入实现的，其实它们是同一个概念的不同角度描述。

   通俗来说就是**IoC是设计思想，DI是实现方式**

6. 在依赖注入时，有哪些方式呢？

   构造器方式，@Autowired, @Resource, @Qualifier... 

   同时Bean之间存在依赖（可能存在先后顺序问题，以及**循环依赖问题**等）

<br>



## 2. 依赖和约束

5个核心包+1个日志包

<font color='red'>**spring-context **</font>\ aop \ beans \ core \ expression  + spring-jcl

```xml

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
    <version>5.2.15.RELEASE</version>
</dependency>
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.12</version>
    <scope>test</scope>
</dependency>

```

<br>

**schema约束**：

官方文档：https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#xsd-schemas

```xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:util="http://www.springframework.org/schema/util"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/util https://www.springframework.org/schema/util/spring-util.xsd">

    <!-- bean definitions here -->
    <!--id属性：组件在容器中的唯一标识,单词通常是和实例相关的-->
    <!--name属性：省略不写，以id作为默认值-->
    <!--class属性：全限定类名-->
    <bean id="userService" class="com.xxx.service.UserServiceImpl"/>
    <bean id="orderService" class="com.xxx.service.OrderServiceImpl"/>
    
    
    
    <!--维护依赖关系-->
    <bean id="userService" class="com.xxx.service.UserServiceImpl">
        <!--property子标签的name属性值对应的就是set方法-->
        <!--ref属性：组件id-->
        <property name="userDao" ref="userDao"/>
	</bean>

	<bean id="orderService" class="com.xxx.service.OrderServiceImpl">
    	<property name="userDao" ref="userDao"/>
	</bean>

	<!--userDao组件-->
	<bean id="userDao" class="com.xxx.dao.UserDaoImpl"/>

</beans>

```

通常名字叫<font color='red'>**application(-xxx).xml**</font> .

<br>



## 3. 容器与实例化

BeanFactory是Spring框架中IoC容器的顶层接⼝,它只是⽤来定义⼀些基础功能,定义⼀些基础规范,

ApplicationContext是它的⼀个⼦接⼝，所以ApplicationContext是具备BeanFactory提供的全部功能
的。通常，我们称BeanFactory为SpringIOC的基础容器，ApplicationContext是容器的⾼级接⼝，⽐
BeanFactory要拥有更多的功能，⽐如说国际化⽀持和资源访问（xml，java配置类）等等

<br>

### 启动IoC容器

启动 IoC 容器的⽅式：

- Java环境下启动IoC容器

  ClassPathXmlApplicationContext：从类的根路径下加载配置⽂件（推荐使⽤）

  FileSystemXmlApplicationContext：从磁盘路径上加载配置⽂件

  AnnotationConfigApplicationContext：纯注解模式下启动Spring容器

  ```java
  
  // ClassPathXmlApplicationContext 使用示例
  @Test
  public void test() {
      // 通过容器取出Spring管理的实例
      ApplicationContext applicationContext = new ClassPathXmlApplicationContext("application.xml");
  
      //取出实例的方式
      //按照组件的id来取出组件
      UserService userService1 = (UserService) applicationContext.getBean("userService");
      UserService userService2 = (UserService) applicationContext.getBean("userService");
      UserService userService3 = (UserService) applicationContext.getBean("userService");
      UserService userService4 = (UserService) applicationContext.getBean("userService");
  
      userService1.sayHello();
  
      // 按照组件类型来取出 (可以写实现类，也可以写接口、更建议写接口）
      // 但是需要容器中只有一个该类型的组件（否则会出错）
      UserService userService5 = applicationContext.getBean(UserService.class);//泛型方法
  
      //按照类型和id来取出
      UserService userService6 = applicationContext.getBean("userService", UserService.class);
  }
  
  ```

  <br>

- Web环境下启动IoC容器

  从xml启动容器或从配置类启动容器



<br>



### 构造方法实例化

**Bean的实例化**：容器要管理组件，组件是如何完成实例化的？

> 1. 构造方法
>    1. 有参构造
>    2. <font color='red'>**无参构造**</font>
> 2. 工厂
>    1. 静态工厂 → 简单工厂
>    2. 实例工厂 → 简单工厂
>    3. FactoryBean 

```xml

<bean id="no" class="com.xxx.bean.NoParamConstructorBean"/>

<!--默认使用无参构造方法，新增了有参构造方法，默认的无参构造方法就没了-->
<!--constructor-arg子标签 → 有参构造方法-->
<!--name属性：有参构造方法的形参名-->
<bean id="has" class="com.xxx.bean.HasParamConstructorBean">
    <constructor-arg name="username" value="zhangsan"/>
    <constructor-arg name="password" value="123465"/>
</bean>

```

<br>

```java

public class NoParamConstructorBean {
    public NoParamConstructorBean() {
        System.out.println("无参构造");
    }
}
public class HasParamConstructorBean {
    String username;
    String password;

    public HasParamConstructorBean(String username, String password) {
        this.username = username;
        this.password = password;
        System.out.println("有参构造方法：" + username + " → " + password);
    }
}

```

<br>



## 4. 工厂实例化



### 静态工厂和实例工厂

```java

// 实例工厂
public class InstanceFactory {
    public Car getInstance() {
        Car car = new Car();
        car.setType("instance");
        return car;
    }
}

// 静态工厂
public class StaticFactory {

    public static Car getInstance() {
        Car car = new Car();
        car.setType("static");
        return car;
    }
}

```

<br>

```xml

<!--静态工厂-->
<!--factory-method属性：生产方法-->
<!--如果包含了factory-method属性：组件类型并不是class属性对应的类型，而是factory-method属性对应的方法的返回值类型-->
<bean id="carFromStaticFactory" class="com.xxx.factory.StaticFactory" factory-method="getInstance"/>

<!--实例工厂-->
<bean id="instanceFactory" class="com.xxx.factory.InstanceFactory"/>
<bean id="carFromInstanceFactory" factory-bean="instanceFactory" factory-method="getInstance"/>

```



```java

@Test
public void test() {
    //静态工厂直接使用生产方法 → 类、方法
    Car car1 = StaticFactory.getInstance();

    //实例工厂需要先获得工厂的实例 
    InstanceFactory instanceFactory = new InstanceFactory();
    Car car2 = instanceFactory.getInstance();
}

```

<br>

### FactoryBean接口

```xml

<!--  Spring内置了对FactoryBean支持 → Spring会检查类是否有实现FactoryBean接口 -->
<!-- 取出组件时取出的是FactoryBean的getObject方法的返回值 -->

<bean id="userServiceProxy" class="com.xxx.proxy.ServiceProxyFactoryBean">
    <property name="clazz" value="com.xxx.service.UserServiceImpl"/>
</bean>

```

<br>

```java

// 该类能够提供一个service的代理组件，并且从单元测试类中取出该组件能够实现事务
public class ServiceProxyFactoryBean implements FactoryBean<Object> {
    String clazz;

    @Override
    public boolean isSingleton() {
        return true;
    }

    @Override
    public Object getObject() throws Exception {
        Class<?> cls = Class.forName(clazz);
        Object obj = cls.newInstance();
        return Enhancer.create(cls, new MethodInterceptor() {
            @Override
            public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
                SqlSession sqlSession = MyBatisUtil.getSqlSession();
                Field[] declaredFields = cls.getDeclaredFields();
                for (Field field : declaredFields) {
                    if (field.getName().contains("Mapper")) {
                        field.setAccessible(true);
                        Class<?> type = field.getType();
                        Object mapper = sqlSession.getMapper(type);
                        field.set(obj, mapper);
                    }
                }
                 Object invoke = method.invoke(obj, objects);
                // Object invoke = methodProxy.invoke(obj, objects);
                sqlSession.commit();
                sqlSession.close();
                return invoke;
            }
        });
    }

    @Override
    public Class<?> getObjectType() {
        return UserServiceImpl.class;
    }

    public void setClazz(String clazz) {
        this.clazz = clazz;
    }
}

```

<br>

```java

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:application.xml")
public class MyTest {

    // 取出的是ServiceProxyFactoryBean提供的组件
    @Qualifier("userServiceProxy")
    @Autowired
    UserService userService;

    @Test
    public void testSelect(){
        String name = userService.queryNameById(1);
        System.out.println(name);
    }

    @Test
    public void testInsert() {
        User user = new User();
        user.setUsername("fahai");
        user.setPassword("nohair");
        user.setAge(33);
        int insert = userService.insertUser(user);
        System.out.println("insert = " + insert);
    }

}

```



<br>



## 5. 作用域scope







## 6. 生命周期









# 二 AOP













# 四 常见问题

## 1. BeanFactory和FactoryBean
