## 1. JDBC体系结构

JDBC（Java DataBase Connectivity, java数据库连接）是一种用于执行SQL语句的Java API

- DriverManager： 管理数据库驱动程序列表、使用通信子协议将来自java应用程序的连接请求与适当的数据库驱动程序匹配
- Driver: 处理与数据库服务器的通信（使用 DriverManager对象来管理这种类型的对象）
- Connection：具有用于联系数据库的所有方法。连接对象表示通信上下文，与数据库的所有通信仅通过连接对象
- Statement：使用 从此接口创建的对象将SQL语句提交到数据库。除了执行存储过程之外，一些派生接口还接受参数
- ResultSet：在使用Statement对象执行SQL查询后，这些对象保存从数据库检索的数据。它作为一 个迭代器，允许我们移动其数据
- SQLException：此类处理数据库应用程序中发生的任何错误



## 2. JDBC使用步骤

使用之前需要导入jdbc的驱动包， 普通java项目参照：[IDEA导入jar包说明](JavaSE/detail/jar包导入.md) ， maven项目导入：

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.26</version>
</dependency>
```



JDBC使用步骤：

**1. 导入包**：需要导入包含数据库编程所需的JDBC类的包、大多数情况下，使用 `import java.sql.*` 就足够 了

**2. 注册JDBC驱动程序**：初始化驱动程序，以便打开与数据库的通信通道 

- 注册驱动程序最常见的方法是使用Java的`Class.forName()`方法
- 第二种方法是使用静态`DriverManager.registerDriver() `方法

```java
Class.forName("com.mysql.cj.jdbc.Driver");

DriverManager.registerDriver( new com.mysql.cj.jdbc.Driver() );
```

常用数据库驱动程序名称：

| 数据库 | JDBC驱动程序名称                | URL格式                                                    |
| ------ | ------------------------------- | ---------------------------------------------------------- |
| MYSQL8 | com.mysql.cj.jdbc.Driver        | jdbc:mysql://hostname:3306/databaseName?serverTimezone=UTC |
| MySQL  | com.mysql.jdbc.Driver           | jdbc:mysql://hostname:3306/databaseName                    |
| ORACLE | oracle.jdbc.driver.OracleDriver | jdbc:oracle:thin:@hostname:port Number：databaseName       |
| DB2    | com.ibm.db2.jdbc.net.DB2Driver  | jdbc:db2:hostname:port Number / databaseName               |
| SYBASE | com.sybase.jdbc.SybDriver       | jdbc:sybase:Tds:hostname:port Number / databaseName        |

**3. 打开连接**：使用`DriverManager.getConnection()`方法创建一个Connection对象，该对象表示与数据库的物理连接

```java
// 三个重载的DriverManager.getConnection()方法
DriverManager.getConnection(String url);
DriverManager.getConnection(String url，Properties prop);
DriverManager.getConnection(String url，String user，String password);

// 常用
Connection connection = DriverManager.getConnection(url, username, password);
```

**4. 执行查询**：使用类型为Statement的对象来构建和提交SQL语句到数据库

```java
// 使用Statement对象来构建和提交SQL语句
statement = connection.createStatement();
ResultSet resultSet = statement.executeQuery("select name from product");
while(resultSet.next()){
    System.out.println(resultSet.getString("name"));
}
```

创建Statement对象后，可以使用它来执行一个SQL语句，其中有三个执行方法之一：

- `boolean execute(String SQL)`：如果可以检索到ResultSet对象，则返回一个布尔值true; 否则返 回false
- `int executeUpdate(String SQL)`：INSERT，UPDATE或DELETE语句
- `ResultSet executeQuery(String SQL)`：SELECT语句、返回一个ResultSet对象

```java
// 使用PreparedStatement对象来构建和提交SQL语句
String sql = "select * from product where name=? and price=?";
preparedStatement = connection.prepareStatement(sql);
preparedStatement.setString(1, "Lemon");
preparedStatement.setInt(2, 11);
ResultSet priceSet = preparedStatement.executeQuery();
while (priceSet.next()){
    System.out.println("Lemon price: "+priceSet.getInt("price"));
}
```

**5. 从结果集中提取数据**：使用相应的 `ResultSet.getXXX()`方法从结果集中检索数据

**6. 释放资源**：需要明确地关闭所有数据库资源，而不依赖于jc

```java
// 代码示例：
public class JDBCDemo {
    public static void main(String[] args) {
        String driver = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://192.168.16.122:3306/mydb?serverTimezone=UTC ";
        String username = "root";
        String password = "root";

        Connection connection =null;
        Statement statement = null;
        PreparedStatement preparedStatement = null;
        try {
            // 注册驱动程序
            Class.forName(driver);
            // 打开连接
            connection = DriverManager.getConnection(url, username, password);

            // 使用Statement来构建和提交SQL语句
            statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("select name from product");
            while(resultSet.next()){
                System.out.println(resultSet.getString("name"));
            }
            // 使用PreparedStatement来构建和提交SQL语句
            String sql = "select * from product where name=? and price=?";
            preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, "Lemon");
            preparedStatement.setInt(2, 11);
            ResultSet priceSet = preparedStatement.executeQuery();
            while (priceSet.next()){
                System.out.println("Lemon price: "+priceSet.getInt("price"));
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if(preparedStatement!=null) preparedStatement.close();  
                if(statement!=null) statement.close();
                if(connection!=null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
```



## 3. 封装JDBC工具类

主要用于避免重复繁琐的获取连接、释放资源问题

```java
public class JDBCUtils {
    private static String driver;
    private static String username;
    private static String password;
    private static String url;

    private Connection connection;
    private PreparedStatement preparedStatement;
    private ResultSet resultSet;
    private int count;

    // 1. 读取数据库配置信息、注册驱动
    static {
        try {
            // InputStream stream = JDBCUtils.class.getClassLoader().getResourceAsStream("db.properties");
            // 反射在这里读不到文件
            // 关于java项目读文件的问题参照博客：https://blog.csdn.net/drizzletowne/article/details/120887844
            FileInputStream stream = new FileInputStream("db.properties");
            Properties properties = new Properties();
            properties.load(stream);
            driver = properties.getProperty("driver");
            username = properties.getProperty("username");
            password = properties.getProperty("password");
            url = properties.getProperty("url");
            Class.forName(driver);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // 2. 获得数据库连接
    public Connection getConnection(){
        try {
            connection = DriverManager.getConnection(url, username, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }

    // 3. PreparedStatement
    public PreparedStatement getPreparedStatement(String sql){
        try {
            preparedStatement = getConnection().prepareStatement(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return preparedStatement;
    }

    // 4. 绑定参数
    public void setParam(List list){
        if(list!=null && list.size() > 0){
            for (int i = 0; i < list.size(); i++) {
                try {
                    preparedStatement.setObject(i+1, list.get(i));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // 5. 增删改
    public int update(String sql, List list){
        getPreparedStatement(sql);
        setParam(list);
        try {
            count = preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // 6. 查询
    public ResultSet query(String sql, List list){
        getPreparedStatement(sql);
        setParam(list);
        try {
            resultSet = preparedStatement.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return resultSet;
    }

    // 7. 关闭资源
    public void close(){
        try {
            if(resultSet != null) resultSet.close();
            if(preparedStatement != null) preparedStatement.close();
            if(connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

```java
// 自定义 JDBC 工具类的使用案例：
public class Demo {
    public static void main(String[] args) throws SQLException {
        JDBCUtils db = new JDBCUtils();

        String sql = "select * from product where name=? and price=?";
        List<Object> params = new ArrayList<>();
        params.add("Apple");
        params.add(11);
        ResultSet resultSet = db.query(sql, params);
        while (resultSet.next()){
            System.out.println(resultSet.getInt("id"));
        }
        db.close();
    }
}
```

相较于前面的例子，这样的使用方式已经简洁了很多~



## 4. 事务与批处理

JDBC驱动程序默认使用自动提交模式、要启用手动事务支持、需要使用Connection对象的 `setAutoCommit()`方法

```java
try{
    //Assume a valid connection object conn
    conn.setAutoCommit(false);
    Statement stmt = conn.createStatement();
    String SQL = "INSERT INTO Employees values (106, 20, 'Rita', 'Tez')";
    stmt.executeUpdate(SQL);
    //Submit a malformed SQL statement that breaks
    String SQL = "INSERTED IN Employees VALUES (107, 22, 'Sita', 'Singh')";
    stmt.executeUpdate(SQL);
    // If there is no error.
    conn.commit();
}catch(SQLException se){
    // If there is any error.
    conn.rollback();
}
```



新的JDBC 3.0 Savepoint接口为您提供了额外的事务控制、可以在事务中定义逻辑回滚点：

如果通过保存点发生错误，则可以使用回滚方法 来撤消更改 

Connection对象有两种新的方法来帮助您管理保存点 

- `setSavepoint(String savepointName)`：定义新的保存点、返回一个Savepoint对象
- `releaseSavepoint(Savepoint savepointName)`：删除保存点、它需要一个Savepoint 对象作为参数

```java
try{
    //Assume a valid connection object conn
    conn.setAutoCommit(false);
    Statement stmt = conn.createStatement();
    
    Savepoint savepoint1 = conn.setSavepoint("Savepoint1");
    String SQL = "INSERT INTO Employees VALUES (106, 20, 'Rita', 'Tez')";
    stmt.executeUpdate(SQL);
    String SQL = "INSERTED IN Employees VALUES (107, 22, 'Sita', 'Tez')";
    stmt.executeUpdate(SQL);
    conn.commit();
}catch(SQLException se){
	conn.rollback(savepoint1);  // 必须是没有commit前使用的,即执行到commit之前要发生异常，这个语句才有意义
}

```



**批处理**：

批量处理：即将相关的SQL语句分组到批处理中，并通过对数据库的一次调用提交它们。

当需要一次向数据库发送多个SQL语句时，可以减少连接数据库的开销，从而提高性能。

```java
//  Statement批处理
Statement stmt = conn.createStatement();
conn.setAutoCommit(false);

//sql1
String SQL = "INSERT INTO Employees (id, first, last, age) VALUES(200,'Zia','Ali', 30)";
stmt.addBatch(SQL);
//sql2
String SQL = "INSERT INTO Employees (id, first, last, age) VALUES(201,'Raj','Kumar', 35)";
stmt.addBatch(SQL);
//sql3
String SQL = "UPDATE Employees SET age = 35 WHERE id = 100";
stmt.addBatch(SQL);

int[] count = stmt.executeBatch();
conn.commit();
```

```java
// PreparedStatement批处理
String SQL = "INSERT INTO Employees (id, first, last, age) VALUES(?, ?, ?, ?)";
PreparedStatement pstmt = conn.prepareStatement(SQL);
conn.setAutoCommit(false);

// Set the variables
pstmt.setInt( 1, 400 );
pstmt.setString( 2, "Pappu" );
pstmt.setString( 3, "Singh" );
pstmt.setInt( 4, 33 );
// Add it to the batch
pstmt.addBatch();

// Set the variables
pstmt.setInt( 1, 401 );
pstmt.setString( 2, "Pawan" );
pstmt.setString( 3, "Singh" );
pstmt.setInt( 4, 31 );
// Add it to the batch
pstmt.addBatch();

//add more batches......

//Create an int[] to hold returned values
int[] count = stmt.executeBatch();
//Explicitly commit statements to apply changes
conn.commit();
```



## 5. 数据库连接池

数据连接池原理： 连接池基本的思想是在系统初始化的时候，将数据库连接作为对象存储在内存中

- 当用户需要访问数据库时，并非建立一个新的连接，而是从连接池中取出一个已建立的空闲连接对象
- 使用完毕后，用户也并非将连接关闭，而是将连接放回连接池中，以供下一个请求访问使用

而连接的建立、断开都由连接池自身来管理。同时，还可以通过设置连接池的参数来控制连接池中的初始连接数、连接的上下限数 以及每个连接的最大使用次数、最大空闲时间等等，也可以通过其自身的管理机制来监视数据库连接的 数量、使用情况等。



**5.1 DBCP连接池**：

DBCP是一个依赖`Jakarta commons-pool`对象池机制的数据库连接池. DBCP可以直接的在应用程序中使用 (Tomcat的数据源使用的就是DBCP)

使用DBCP需要导入的jar包：`commons-dbcp.jar` 、`commons-pool.jar` 

```xml
<!--maven导入依赖：会自动导入其需要的jar,比如commons-pool.jar -->
<dependency>
    <groupId>commons-dbcp</groupId>
    <artifactId>commons-dbcp</artifactId>
    <version>1.4</version>
</dependency>
```

```properties
# 连接设置 ( db.properties )
driverClassName=com.mysql.cj.jdbc.Driver
url=jdbc:mysql://localhost:3306/m
username=root
password=root
#<!-- 初始化连接 -->
initialSize=10
#最大连接数量
maxActive=50
#<!-- 最大空闲连接 -->
maxIdle=20
#<!-- 最小空闲连接 -->
minIdle=5
#<!-- 超时等待时间以毫秒为单位 6000毫秒/1000等于60秒 -->
maxWait=6000
```

```java
// DButils工具类:
// 1.创建dbcp的工具类对象
static BasicDataSource datasource=new BasicDataSource();
// 2.加载驱动
static {
    try {
        // 2.1. 加载属性文件
        ResourceBundle bundle = ResourceBundle.getBundle("db");
        driverClass = bundle.getString("driverclass");
        url = bundle.getString("url");
        username = bundle.getString("uname");
        password = bundle.getString("upass");
        init=bundle.getString("initsize");
        // 2.2.将驱动地址等信息传递给dbcp
        datasource.setDriverClassName(driverClass);
        datasource.setUrl(url);
        datasource.setUsername(username);
        datasource.setPassword(password);
        datasource.setInitialSize(Integer.parseInt(init));
    } catch (Exception e) {
        e.printStackTrace();
    }
}
// 3.获得连接
public static Connection getConn() {
    try {
    	con= datasource.getConnection();
    } catch (SQLException e) {
    	e.printStackTrace();
    }
    return con;
}

```



**5.2 C3P0连接池**：  

c3p0与dbcp区别： 

- dbcp没有自动回收空闲连接的功能、 c3p0有自动回收空闲连接功能 
- dbcp需要手动设置配置文件、 c3p0不需要手动设置

使用C3P0需要导入jar包：` c3p0-0.9.1.2.jar` 、 maven依赖：

```xml
<dependency>
    <groupId>com.mchange</groupId>
    <artifactId>c3p0</artifactId>
    <version>0.9.5.5</version>
</dependency>
```

c3p0是在外部添加配置文件,工具直接进行应用,因为直接引用,所以要求固定的命名和文件位置

- 文件位置:  src
- 文件命名: `c3p0-config.xml / c3p0-config.properties`

```xml
<!-- c3p0-config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<c3p0-config>
    <!-- 默认配置，如果没有指定则使用这个配置 -->
    <default-config>
        <!-- 基本配置 -->
        <property name="driverClass">com.mysql.jdbc.Driver</property>
        <property name="jdbcUrl">jdbc:mysql://localhost:3306/day2</property>
        <property name="user">root</property>
        <property name="password">111</property>
        <!--扩展配置-->
        <!-- 连接超过30秒报错-->
        <property name="checkoutTimeout">30000</property>
        <!--30秒检查空闲连接 -->
        <property name="idleConnectionTestPeriod">30</property>
        <property name="initialPoolSize">10</property>
        <!-- 30秒不适用丢弃-->
        <property name="maxIdleTime">30</property>
        <property name="maxPoolSize">100</property>
        <property name="minPoolSize">10</property>
        <property name="maxStatements">200</property>
    </default-config>
    <!-- 命名的配置 -->
    <named-config name="abc">
        <property name="driverClass">com.mysql.jdbc.Driver</property>
        <property name="jdbcUrl">jdbc:mysql://localhost:3306/day2</property>
        <property name="user">root</property>
        <property name="password">111</property>
        <!-- 如果池中数据连接不够时一次增长多少个 -->
        <property name="acquireIncrement">5</property>
        <property name="initialPoolSize">20</property>
        <property name="minPoolSize">10</property>
        <property name="maxPoolSize">40</property>
        <property name="maxStatements">20</property>
        <property name="maxStatementsPerConnection">5</property>
    </named-config>
</c3p0-config>
```

注意: 

c3p0的配置文件内部可以包含命名配置文件和默认配置文件! 默认是选择默认配置! 

如果需要切换命名配置可以在创建c3p0连接池的时候填入命名即可!

```java
Connection con=null;
ComboPooledDataSource db = new ComboPooledDataSource("abc"); // 使用自命名的配置文件

public Connection getCon(){
    try {
    	con=db.getConnection();
    } catch (SQLException e) {
    	e.printStackTrace();
    }
    return con;
}
```



**5.3 Druid连接池**：  

Druid针对Oracle和MySql做了特别优化、提供了MySql、Oracle、Postgresql、SQL-92的SQL的完整支持，这是一个手写的高性能SQL Parser，支持Visitor模式，使得分析SQL的抽象语法树很方便。

使用Druid需要导入jar包：

```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
    <version>1.1.23</version>
</dependency>
```

```java
public class DruidUtils {
    //声明连接池对象
    private static DruidDataSource ds;
    static{
        ///实例化数据库连接池对象
        ds=new DruidDataSource();
        //实例化配置对象
        Properties properties=new Properties();
        try {
            //加载配置文件内容
            properties.load(DruidUtils.class.getResourceAsStream("config.properties"));
            //设置驱动类全称
            ds.setDriverClassName(properties.getProperty("driverClassName"));
            //设置连接的数据库
            ds.setUrl(properties.getProperty("url"));
            //设置用户名
            ds.setUsername(properties.getProperty("username"));
            //设置密码
            ds.setPassword(properties.getProperty("password"));
            //设置最大连接数量
            ds.setMaxActive(Integer.parseInt(properties.getProperty("maxActive")));
        } catch (IOException e) {
        	e.printStackTrace();
        }
    }
    //获取连接对象
    public static Connection getConnection() {
        try {
        	return ds.getConnection();
        } catch (SQLException e) {
        	e.printStackTrace();
        }
        return null;
    }
}
```

注: 在Druid连接池的配置中，driverClassName可配可不配，如果不配置会根据url自动识别dbType(数 据库类型)，然后选择相应的driverClassName。

