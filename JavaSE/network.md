# 一 网络编程基础

## 1. IP、端口和协议

- **IP地址（Internet Protocol Address）**：是网络中设备的唯一标识

  - IPv4：每个IP地址长32bit，也就是4个字节。如：11000000 10101000 00000001 01000010，十进制为：192.168.1.66
  - IPv6：128位地址长度，每16个字节一组，分成8 组十六进制数

  ```java
  // java 关于IP地址的使用：
  // InetAddress inetAddress = InetAddress.getByName("LAPTOP-TS9EH1VR");
  InetAddress inetAddress = InetAddress.getByName("192.168.0.9");
  
  System.out.println(inetAddress.getHostName());     // LAPTOP-TS9EH1VR
  System.out.println(inetAddress.getHostAddress());  // 192.168.0.9
  ```

  

- **端口（port）**： 设备上应用程序（进程）的唯一标识

  - 端口用两个字节表示的整数，它的取值范围是0~65535

  - 0~1023之间的端口号用于一些知名的网络服务和应用，普通的应用程序需要使用1024以上的端口号

    

- **协议（Protocol）**：计算机网络中，连接和通信的规则被称为网络通信协议

  - **UDP协议（User Datagram Protocol)**：用户数据报协议 （不建立逻辑连接，不会确认接收端是否存在或收到）
  - **TCP协议（Transmission Control Protocol）**：传输控制协议 （建立可靠连接，提供无差错的数据传输）
  





## 2. UDP协议及通信

UDP是无连接通信协议，即在数据传输时，数据的发送端和接收端不建立逻辑连接

- 当一台 计算机向另外一台计算机发送数据时，发送端不会确认接收端是否存在，就会发出数据，同样接收端在 收到数据时，也不会向发送端反馈是否收到数据。 

- 使用UDP协议消耗资源小，通信效率高，通常会用于音频、视频和普通数据的传输

  例如视频会议通常采用UDP协议，因为这种情况即使偶尔丢失一两个数据包，也不会对接收结果产生太大影响

- 由于UDP的面向无连接性，不能保证数据的完整性，因此在传输重要数据时不建议使用UDP协议



**DatagramPacket与DatagramSocket**：

这两个类所有构成的网络链接是基于UDP协议，是一种不可靠的协议

- DatagramPacket：用于封装、存放数据

- DatagramSocket：用于接收或发送数据报

  

1. DatagramSocket类的构造方法和常用方法：

| 构造方法                                  | 说明                               |
| ----------------------------------------- | ---------------------------------- |
| DatagramSocket()                          | 默认使用本地地址和一个随机的端口号 |
| DatagramSocket(int port)                  | 使用本地地址、并指定端口号         |
| DatagramSocket(int port, InetAddress iad) | 指定地址和端口号                   |
| DatagramSocket(SocketAddress sad)         | 使用特定的Socket地址               |

| 常用方法                    | 说明       |
| --------------------------- | ---------- |
| send(DatagramPacket dp)     | 发送数据报 |
| recevie(DatagramPacket  dp) | 接收数据报 |
| close()                     | 关闭socket |



2. DatagramPacket类的常用构造方法：

| 常用构造方法                                                 | 说明                                   |
| ------------------------------------------------------------ | -------------------------------------- |
| DatagramPacket(byte[] buf,  int length)                      | 用于接收数据 (即数据存于字节数组buf中) |
| DatagramPacket(byte[] buf, int length, InetAddress address, int port) | 用于封装数据报、发送数据               |
| DatagramPacket(byte[] buf, int length, SocketAddress address) | 同上，但地址和端口号采用SocketAddress  |



例：使用java实现使用UDP协议的发送、接收客户端

	1. 发送数据客户端：可以一直接收键盘录入并发送数据，q退出
	2. 接收数据客户端：使用死循环，接收客户端的数据并打印到控制台

```java
public class ReceiveClient {
    public static void main(String[] args) throws IOException {
        DatagramSocket datagramSocket = new DatagramSocket(11111);

        while (true) {
            // 创建用于接收数据的数据包
            byte[] bytes = new byte[1024];
            DatagramPacket datagramPacket = new DatagramPacket(bytes, bytes.length);
            datagramSocket.receive(datagramPacket);
            // 解析数据并输出
            String content = new String(datagramPacket.getData(), 0, datagramPacket.getLength());
            System.out.println(content);
        }
    }
}
```

```java
public class SendClient {
    public static void main(String[] args) throws Exception {
        DatagramSocket datagramSocket = new DatagramSocket();

        // 自行封装键盘录入
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
        String content;
        while ((content = bufferedReader.readLine())!= null){
            if("q".equals(content)) break;  // 输入q退出
            // 封装待发送的数据包
            byte[] bytes = content.getBytes();
            DatagramPacket datagramPacket = new DatagramPacket(bytes, bytes.length, 
                                                InetAddress.getByName("127.0.0.1"), 11111);
            datagramSocket.send(datagramPacket);  //调用DatagramSocket对象的方法发送数据
        }
        datagramSocket.close();  //关闭发送端
    }
}
```

![image-20211019232420186](vx_images/image-20211019232420186.png)





## 3. TCP协议及通信

TCP协议是面向连接的通信协议，即传输数据之前，在发送端和接收端建立逻辑连接，然后再传输数 据，它提供了两台计算机之间可靠无差错的数据传输。

- 在TCP连接中必须要明确客户端与服务器端，由客户端向服务端发出连接请求，每次连接的创建都需要经过“三次握手” 
- 三次握手：TCP协议中，在发送数据的准备阶段，客户端与服务器之间的三次交互，以保证连接的可靠 
  - 第一次握手，客户端向服务器端发出连接请求，等待服务器确认 
  - 第二次握手，服务器端向客户端回送一个响应，通知客户端收到了连接请求 
  - 第三次握手，客户端再次向服务器端发送确认信息，确认连接 
- 完成三次握手，连接建立后，客户端和服务器就可以开始进行数据传输了。由于这种面向连接的特性， TCP协议可以保证传输数据的安全，所以应用十分广泛。例如上传文件、下载文件、浏览网页等



**客户端—Socket类**：

| 构造方法                              | 说明             |
| ------------------------------------- | ---------------- |
| Socket(InetAddress address, int port) | 指定IP和端口号   |
| Socket(String host, int port)         | 指定主机和端口号 |

| 常用方法                       | 说明       |
| ------------------------------ | ---------- |
| InputStream getInputStream()   | 返回输入流 |
| OutputStream getOutputStream() | 返回输出流 |



**服务器端—ServerSocket类**：

| 构造方法                | 说明                             |
| ----------------------- | -------------------------------- |
| ServletSocket(int port) | 创建绑定到指定端口的服务器Socket |

| 常用方法        | 说明                             |
| --------------- | -------------------------------- |
| Socket accept() | 监听要连接到此的Socket、并接收它 |



例：使用Socket和ServerSocket实现数据的发送、接收

 	1. 发送数据（客户端）：可以一直接收键盘录入并发送数据，q退出
 	2. 接收数据（服务端）：接收客户端的数据并打印到控制台

```java
public class Server {
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(11111);

        Socket socket = serverSocket.accept();
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        String content;
        while ((content = bufferedReader.readLine()) != null){
            System.out.println(content);
        }
        serverSocket.close();
    }
}
```

```java
public class Client {
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("192.168.0.9", 11111);

        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(System.in));
        BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
        String content;
        while ((content = bufferedReader.readLine()) != null){
            if("q".equals(content)) break;
            bufferedWriter.write(content);
            bufferedWriter.newLine();
            bufferedWriter.flush();
        }
        socket.close();
    }
}
```

![image-20211020020651130](vx_images/image-20211020020651130.png)





