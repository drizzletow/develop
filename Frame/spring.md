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

<font color='red'>**spring-context **</font>\ aop \ beans \ core \ expression  + spring-jcl

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
            public Object intercept(Object o, Method method, Object[] objects, 
                                    MethodProxy methodProxy) throws Throwable {
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

singleton：单例  → 每一次取出组件都是同一个实例 → <font color='red'> 绝大多数场景用的都是默认的作用域singleton</font>

prototype：原型 → 每一次取出组件都是新的实例

不管取出组件的方式是按照id还是按照类型取出

```xml

<!--scope属性：作用域-->
<bean id="default" class="com.xxx.bean.DefaultBean"/>
<bean id="singleton" class="com.xxx.bean.SingletonBean" scope="singleton"/>
<bean id="prototype" class="com.xxx.bean.PrototypeBean" scope="prototype"/>

```



<br>



## 6. Spring生命周期

Spring容器中的组件的生命周期 :  在组件可用状态之前可以使用哪一些方法，在组件可用之后可以使用哪一些方法

```bash

1. Bean的实例化

2. 设置参数（set方法）

3. Aware 
   1). BeanNameAware → setBeanName
   2). BeanFactoryAware → setBeanFactory
   3). ApplicationContextAware → setApplicationContext
   
4. BeanPostProcessor的before

5. init-method、InitializingBean提供的afterPropertiesSet

6. BeanPostProcessor的after

7. Bean作为容器中的组件是可用的


# 组件到达可用状态之前一定会执行的：Bean的实例化

# 当前组件实现接口才会执行的：Aware的3个方法、InitializingBean的afterPropertiesSet方法

# 单独指定：init-method

# 通用的（不仅仅针对当前组件）：BeanPostProcessor的before和after



容器关闭之前: 

 👉 destory-method、
 
 👉 DisposableBean提供的destroy

```

<br>



**BeanPostProcessor**：

<font color='red'>**如果容器中有组件实现了BeanPostProcessor接口，那么其他的所有的组件都会执行BeanPostProcessor的方法**</font> . 

```java

public class CommonBeanPostProcessor implements BeanPostProcessor {
    
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) 
        throws BeansException {

        //如果我传入的是LifecycleBean，我能不能给他替换成代理对象呢？
        //返回的时候能不能换成动态代理的对象呢？

        return bean;
    }

    // 和before一摸一样，只有执行顺序不同
    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        // 返回值如果写的是return null 👉 相当于return bean
        return null;
    }
}

```

<br>

生命周期及相关接口示例：

```java

public class LifeCycleBean implements BeanNameAware, BeanFactoryAware, ApplicationContextAware,
        InitializingBean,DisposableBean {

    private String name;

    private String beanName;
    private BeanFactory beanFactory;
    private ApplicationContext applicationContext;

    // 无参构造，Bean实例化时调用
    public LifeCycleBean() {
        System.out.println("Constructor");
    }

    // setter
    public void setName(String name) {
        this.name = name;
        System.out.println("Setter");
    }

    // BeanNameAware
    @Override
    public void setBeanName(String name) {
        this.beanName = name;
        System.out.println("BeanNameAware——setBeanName(), beanName = " + beanName);
    }

    // BeanFactoryAware
    @Override
    public void setBeanFactory(BeanFactory beanFactory) throws BeansException {
        this.beanFactory = beanFactory;
        System.out.println("BeanFactoryAware——setBeanFactory, beanFactory = " + beanFactory);
    }

    // ApplicationContextAware
    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        this.applicationContext = applicationContext;
        System.out.println("ApplicationContextAware——setApplicationContext");
    }


    @Override
    public void afterPropertiesSet() throws Exception {
        System.out.println("afterPropertiesSet() of InitializingBean");
    }
    
    @PostConstruct
    public void customInit(){
        System.out.println("customInit");
    }

    @PreDestroy
    public void customDestroy() {
        System.out.println("customDestroy");
    }

    @Override
    public void destroy() throws Exception {
        System.out.println("destroy() of DisposableBean");
    }

}

```

spring配置文件：

```xml

<bean id="lifeCycleBean" class="cn.itdrizzle.bean.LifeCycleBean">
    <property name="name" value="zhangsan111"/>
</bean>

```

<br>



## 7. Spring单元测试

为了在测试类中使用注解注入组件，可以使用spring-test：

引入依赖：

```xml

<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-test</artifactId>
    <version>5.2.15.RELEASE</version>
    <scope>test</scope>
</dependency>

```

<br>

使用注解：

```java

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:application.xml")
public class OrderServiceTest {

    @Autowired
    OrderService orderService;

    @Test
    public void testHello(){
        orderService.sayHello();
    }

    @Test
    public void testInsertOrder(){
        Order order = new Order();
        order.setProductName("Iphone18");
        order.setUsername("zhangshan233");
        order.setPrice(999);

        orderService.insertOrder(order);
    }
}

```



<br>



# 二 动态代理和工厂

## 1. JDK动态代理



<br>

## 2. CGLIB动态代理



<br>

## 3. 工厂设计模式



<br>

# 三 AOP with Spring

Spring AOP defaults to using standard JDK dynamic proxies for AOP proxies.

Spring AOP can also use CGLIB proxies. This is necessary to proxy classes rather than interfaces.

 By default, CGLIB is used if a business object does not implement an interface. 

<br>

## 1. AOP Concepts

<span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**AOP就是对容器中的组件的特定方法做一个特定的增强**</span>

**核心术语**：

Target：目标类、委托类（目标类组件、委托类组件）

Proxy：新产生的代理类

<font color='gray'>**Weaver：织入 → 右委托类对象生成代理对象的过程**</font> .

<font color='red'>**Pointcut**</font>：切入点 → 指定增强哪些方法 

<font color='red'>**Advice**</font>：通知 → 方法按照什么样的方式来增强 → <span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**特定的增强**</span> → when do what

<font color='red'>**Aspect**</font>：切面 = 切入点(pointcut) + 通知(advice)

JoinPoint：连接点 →  增强过程中提供的对象 → 通过该对象提供的方法可以获得增强过程中的一些值

<br>



## 2. Spring AOP

半自动的 SpringAOP：

通知组件需要实现接口： <span style='color:yellow;background:red;font-size:文字大小;font-family:字体;'>**MethodInterceptor**</span> 

Advice（通知组件）做的事情 和 JDK动态代理的InvocationHandler相似：

```java

@Component
public class CountExecutionTimeAdvice implements MethodInterceptor {
    @Override
    public Object invoke(MethodInvocation methodInvocation) throws Throwable {
        long start = System.currentTimeMillis();
        //执行委托类的方法 → method.invoke(target,args)
        Object proceed = methodInvocation.proceed();
        long over = System.currentTimeMillis();
        System.out.println(methodInvocation.getMethod().getName() + "方法的执行时间：" + (over - start));
        
        return proceed;
    }
}

```

<br>

Spring配置文件：application.xml

```xml

<bean id="userServiceProxy" class="org.springframework.aop.framework.ProxyFactoryBean">
    <property name="target" ref="userServiceImpl"/>
    <property name="interceptorNames" value="countExecutionTimeAdvice"/>
</bean>

```

<br>

测试示例：

```java

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:application.xml")
public class MyTest {

    @Autowired
    @Qualifier("userServiceProxy")
    UserService userService;

    @Test
    public void mytest1() {
        userService.sayHello();
    }
}

```



<br>



## 3. Full AspectJ

全自动的 AspectJ

导入依赖：

```xml

<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.7</version>
</dependency>

```

<br>



### Pointcut切入点

官方文档：https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema-pointcuts

划定增强范围，即指定增强哪些方法

<span style='color:blue;font-size:24px;font-family:字体;'>**注意：增强的方法的范围不能超过容器中的组件里的方法的范围，不是容器中的组件里的方法，就不能指定**</span> . 

<font color='red'>**最大范围：容器中的组件里的所有方法**</font>

```xml

<aop:config>
    <aop:pointcut id="mypointcut" expression=""/>
</aop:config>

```

标准的Aspectj Aop的pointcut的表达式类型是很丰富的，但是Spring Aop只支持其中的9种，外加Spring Aop自己扩充的一种一共是10种类型的表达式，分别如下

```bash

1. execution：一般用于指定方法的执行，用的最多。
2. within：指定某些类型的全部方法执行，也可用来指定一个包。
3. this：Spring Aop是基于代理的，生成的bean也是一个代理对象，this就是这个代理对象，
         当这个对象可以转换为指定的类型时，对应的切入点就是它了，Spring Aop将生效。
4. target：当被代理的对象可以转换为指定的类型时，对应的切入点就是它了，Spring Aop将生效。
5. args：当执行的方法的参数是指定类型时生效。
6. @target：当代理的目标对象上拥有指定的注解时生效。
7. @args：当执行的方法参数类型上拥有指定的注解时生效。
8. @within：与@target类似，看官方文档和网上的说法都是@within只需要目标对象的类或者父类上有指定的注解，
            则@within会生效，而@target则是必须是目标对象的类上有指定的注解。
            这两者都是只要目标类或父类上有指定的注解即可。
9. @annotation：当执行的方法上拥有指定的注解时生效。
10. bean：当调用的方法是指定的bean的方法时生效。

```

<br>



**execution** 

```bash

execution（ <修饰符模式>？ <返回值类型模式>  <方法名模式>（<参数模式> ）<异常模式>？）

# 除了返回类型模式，方法名模式和参数模式外，其它项都是可选的

```

<br>

| 模式 | 描述 |
| - | - |
| 修饰符 | public 表示public 级别方法。 可以不写，不写表示匹配所有的方法（public,private,protected等级别的方法） |
| 返回值类型 | 表示方法返回值的类型，  * 表示全部 （注意：类名要写全限定类名） |
| 包名 + 方法名 | 表示具体的包名，可以使用通配符，中间可以使用 `两个点`  省略，但包名开头和方法名不能省略 |
| 方法参数 | 省略不写代表无参方法，`*` 代表单个任意类型的参数, `..`  代表任意数量的任意类型的参数 |
| 异常 | 表示全部 |

**execution表达式的局限性**：

如果要增强的这些方法之间没有啥联系，如果强行建立联系，有可能把不需要增强的方法也划定到范围了

这是可以考虑使用 下面的 `@annotation` 的方式

<br>



**@annotation** 

需要自定义注解，直接将切入点和要增强的方法耦合起来 ，这是一种更精细的切入点的管理 → 指哪打哪

注解增加在组件中的哪一个方法上，哪一个方法就被增加到切入点的范围

使用示例：

```java

// 自定义一个新的注解
@Target(ElementType.METHOD)           // 注解可以出现在什么位置 → 方法上
@Retention(RetentionPolicy.RUNTIME)   // 注解在何时生效 → 运行时
public @interface CountTime {
    
}


// 在需要增强的方法上使用该注解即可
@CountTime
@Override
public String serviceMethod(User user) {
	// logic
}

```

<br>

当然，不要忘记在配置文件中 配置 该注解为 pointcut

```xml

<aop:config>

    <!--annotation-->
    <aop:pointcut id="mypointcut" expression="@annotation(com.xxx.anno.CountTime)"/>

    <aop:advisor advice-ref="countExecutionTimeAdvice" pointcut-ref="mypointcut"/>
    
</aop:config>

```



<br>

### Advice通知/增强

**方式一：通常配合Advisor使用**：

```java

@Component
public class CountExecutionTimeAdvice implements MethodInterceptor {
    @Override
    public Object invoke(MethodInvocation methodInvocation) throws Throwable {
        long start = System.currentTimeMillis();
        //执行委托类的方法 → 类似于method.invoke(target,args)
        Object proceed = methodInvocation.proceed();
        long over = System.currentTimeMillis();
        System.out.println(methodInvocation.getMethod().getName() + "方法的执行时间：" + (over - start));

        return proceed;
    }
}

```

<br>

**方式二：通常配合Aspect使用**：

```java

@Component
public class CustomAspect {

    //切面类中的方法名任意写

    public void mybefore(JoinPoint joinPoint) {
        System.out.println("before targetMethod");
    }

    public void myafter() {
        System.out.println("after targetMethod");
    }

    //around通知方法类似于InvocationHandler的invoke方法、类似于MethodInterceptor的invoke
    public Object around(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        
        // 从此处开始到调用 proceed() 方法，相当于 before 部分
        System.out.println("around的前半部分");
        
        Object proceed = null;
        try {
            proceed = proceedingJoinPoint.proceed(args);
            
            // ... 次处的代码相当于 afterReturning
            
        } catch (Throwable e) {
            // ... 次处的代码相当于 afterThrowing
        } finally {
            // .. 次处的代码相当于 after
        }
        
        
        System.out.println("around的后半部分");

        return proceed;
    }

    //委托类方法的返回值以形参的方式传入AfterReturning通知方法里
    public void afterReturning(Object result) {
        System.out.println("委托类方法执行的结果：" + result);
    }

    //委托类方法抛出的异常以形参的方式传入AfterThrowing通知方法里
    public void afterThrowing(Exception exception) {
        System.out.println("afterThrowing接收到的异常：" + exception.getMessage());
    }
}

```



<br>

### Advisor和Aspect

advisor —— advice + pointcut ：

```xml

<aop:config>
    <aop:pointcut id="mypointcut" expression="@annotation(com.xxx.anno.CountTime)"/>

    <aop:advisor advice-ref="countExecutionTimeAdvice" pointcut-ref="mypointcut"/>
    
</aop:config>

```

<br>

Aspect —— advice + point ：

```xml

<aop:config>
    <aop:pointcut id="servicePointcut" expression="execution(* com..service..*(..))"/>
    
    <!-- advice + pointcut -->
    <aop:aspect ref="customAspect">
        <aop:before method="mybefore" pointcut-ref="servicePointcut"/>
        <aop:after method="myafter" pointcut-ref="servicePointcut"/>
        <aop:around method="around" pointcut-ref="servicePointcut"/>
        
        <!--returning属性：method属性对应的方法中的哪一个形参接收到委托类方法的返回值-->
        <aop:after-returning method="afterReturning" pointcut-ref="servicePointcut"
                             returning="result"/>

        <!--throwing属性：method属性对应的方法中的哪一个形参接收到委托类方法抛出的异常-->
        <aop:after-throwing method="afterThrowing" pointcut-ref="servicePointcut"
                            throwing="exception"/>
    </aop:aspect>
    
</aop:config>

```



<br>

### JoinPoint连接点

JoinPoint出现在Before通知或Around通知里 → 直接在形参里写JoinPoint

通过joinPoint可以拿到增强过程中的各种参数：

- 委托类对象
- 代理对象
- 方法
- 参数

```java

public void mybefore(JoinPoint joinPoint) {
    System.out.println("before");
    Object proxy = joinPoint.getThis();      //代理类对象
    Object target = joinPoint.getTarget();   //委托类对象
    System.out.println("代理类：" + proxy.getClass());
    System.out.println("委托类："+ target.getClass());

    String methodName = joinPoint.getSignature().getName();
    System.out.println("方法名：" + methodName);

    Object[] args = joinPoint.getArgs();
    System.out.println("参数：" + Arrays.asList(args));
}

public Object around(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
    System.out.println("around通知的前半部分");
    // 通过连接点获取方法参数，并进行修改
    Object[] args = proceedingJoinPoint.getArgs();
    if ("add".equals(proceedingJoinPoint.getSignature().getName())) {
        args[0] = 2;
        args[1] = 10;
    }
    Object proceed = proceedingJoinPoint.proceed(args);
    System.out.println("around通知的后半部分");

    return proceed;
}

```

<br>

## 4. AspectJ注解

开启注解支持：

Enabling @AspectJ Support with Java Configuration

```java
@Configuration
@EnableAspectJAutoProxy
public class AppConfig {

}

```

To enable @AspectJ support with XML-based configuration：

```xml

<aop:aspectj-autoproxy/>

```

<br>

```java

@Component
@Aspect                       // 指定组件为切面组件
public class CustomAspect {

    // 切入点 pointcut 以方法的形式体现出来
    // 方法名作为切入点(point)id、@Pointcut注解的value属性里写的是切入点表达式
    @Pointcut("execution(* com..service..*(..))")
    public void mypointcut() {
    }
    
    // 引用切入点方法
    @After("mypointcut()")
    public void myafter() {
        // 
    }
    
    // 也可以直接写切入点表达式
    @Before("execution(* com..service..*(..))")
	public void mybefore(JoinPoint joinPoint) {
        // 
    }
    
}

```



<br>

# 四 Spring+Mybatis



## 1. mybatis-spring

mybatis-spring文档介绍：http://mybatis.org/spring/zh/index.html 

```xml
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
    <version>2.0.6</version>
</dependency>

```







## 2. sm的整合流程







## 3. Spring事务管理









<br>



# 五 Spring常见问题

## 1. BeanFactory和FactoryBean
