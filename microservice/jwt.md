# 一 微服务架构认证方案

## 1. 微服务架构下的认证

### 基于Session的认证

在分布式的环境下，基于session的认证会出现⼀个问题，每个应⽤服务都需要在session中存储⽤户身份信息，通过负载均衡将本地的请求分配到另⼀个应⽤服务需要将session信息带过去，否则会重新认证。我们可以使⽤Session共享、
Session黏贴等⽅案。

```bash

`方案1：Nginx负载均衡做 iphash，同一个用户的请求永远只给到同一个后台服务器。`
不足之处：
一个服务有若干个用户，有的用户活跃，向后端发起请求的次数比较频繁，而有的用户不活跃，那么基于这种iphash的解决方案的话就势必会造成负载不均衡，也就是说有的tomcat服务服务器压力大，而有的tomcat服务器压力不大，造成资源分配不均的情况。
其次就是假如有一个tomcat服务挂了，那么对于有一些用户来说，这个系统就挂了，失去了集群的意义。

`方案2：基于tomcat广播的session复制`
不足之处：
每一个tomcat都需要维护一个大的session，会造成内存资源紧张。大量复制session占用服务器带宽

`方案3： 将session数据，以能够共享的方式存储`，比如存储到Mysql，或者Redis数据库中
不足之处：
存储和访问session数据时，还要多访问一次数据库，或涉及到网络，或IO过程

```

即便通过上面的种种方式、解决了部分问题，但是Session⽅案任有缺点，⽐如基于cookie，移动端不能有效使⽤等

<br>

基于session的身份认证特点：
1. Sessions：每次用户认证通过以后，服务器需要创建一条记录来保存用户信息，通常是在内存中。那么随着认证通过的用户越来越多，服务器在这里的开销就会越来越大。
2. Scalability：由于session是在内存中的，这就带来一些扩展性的问题。
3. CSRF：用户很容易受到CSRF的攻击

```bash

CSRF:跨站请求伪造(早期的攻击方式)
假设一个网站用户Bob正在浏览聊天论坛，而同时另一个用户Alice也在此论坛中，并且后者刚发布了一个具有Bob银行链接的图片信息。正常情况下，Bob点击图片链接访问银行，银行会让Bob登录

假如Bob在此之前刚好登录过了银行，浏览器中还有cookie，那么此时银行可能认为点击这个图片访问银行是Bob发出的，所以会正常给出响应。假如这个链接是一个Alice伪造的转账的请求，那么Bob可能就会收到经济损失

```



<br>



### 基于token的认证

基于token的认证⽅式，服务端不⽤存储认证数据，易维护扩展性强， 客户端可以把token 存在任意地⽅，并且可以实现web和app统⼀认证机制。其缺点也很明显，token由于⾃包含信息，因此⼀般数据量较⼤，⽽且每次请求 都需要传递，因此⽐较占带宽。另外，token的签名验签操作也会给cpu带来额外的处理负担。

<br>

使用JWT能够解决session带来的问题，基于Token的身份认证，大概流程如下：
1. 客户端使用用户名、密码请求登录
2. 服务器收到请求去验证用户名和密码
3. 验证成功之后服务端会签发一个token，再把这个token发送给客户端
4. 客户端收到token以后可以把它存储起来，存到客户端内存或者其他地方
5. 客户端每次向服务器请求资源的时候需要带着服务器签发的token
6. 服务端收到请求，然后去验证客户端请求里面带着的token，如果验证成功，就向客户端返回请求的数据

<br>

基于JWT的身份认证方式特点：
1. JWT是把用户信息保存在客户端，基于token的方式将用户状态分散到了各个客户端中，可以减轻服务端的内存压力。
2. session的状态存储在服务端，客户端只有sessionId，而token的状态是存储在客户端，这就使得服务器端并未存储用户登录状态，是无状态的，因为是无状态的，所以便于集群的扩容。
3. 安全性方便
Token不是cookie。每次请求的时候token都会被发送，可以作为请求参数发送，可以放在请求头里面发送，也可以放在cookie里面被发送。即使在你的实现中将token存储到客户端的cookie中，这个cookie也只是一种存储机制，而非身份认证机制。没有基于会话的信息可以操作，因为我们没有会话



<br>



## 2. Spring Cloud OAuth2

OAuth（开放授权）是⼀个开放协议/标准，允许⽤户授权第三⽅应⽤访问他们存储在另外的服务提供者上的信息，⽽不需要将⽤户名和密码提供给第三⽅应⽤或分享他们数据的所有内容。

```bash

结合“使⽤QQ登录xx博客”这个场景拆分理解上述那句话
⽤户：我们⾃⼰
第三⽅应⽤：xx博客⽹
另外的服务提供者：QQ

```

OAuth2是OAuth协议的延续版本，但不向后兼容OAuth1，即完全废⽌了OAuth1。



**注意：使⽤OAuth2解决问题的本质是，引⼊了⼀个认证授权层，认证授权层连接了资源的拥有者，在授权层⾥⾯，资源的拥有者可以给第三⽅应⽤授权去访问我们的某些受保护资源**。

<br>



**OAuth2的使用情景**：

**第三方授权登录的场景**：⽐如，我们经常登录⼀些⽹站或者应⽤的时候，可以选择使⽤第三⽅授权登录的⽅式，⽐如：微信授权登录、QQ授权登录、微博授权登录等，这是典型的 OAuth2 使⽤场景。

**单点登录的场景**：如果项⽬中有很多微服务或者公司内部有很多服务，可以专⻔做⼀个认证中⼼（充当认证平台⻆⾊），所有的服务都要到这个认证中⼼做认证，只做⼀次登录，就可以在多个授权范围内的服务中⾃由串⾏。



<br>



### 第三方授权登录

**协议角色和流程**：

资源所有者（Resource Owner）：可以理解为⽤户⾃⼰

客户端（Client）：我们想登陆的⽹站或应⽤，⽐如xx博客⽹

认证服务器（Authorization Server）：可以理解为微信或者QQ

资源服务器（Resource Server）：可以理解为微信或者QQ

<br>

下面我们就以微信登陆为列子，来说说Oauth2的运用实现，以及一般在项目中，Oauth2这种思想可以帮我们解决哪些问题

```bash

- 首先用户，登陆我们的客户端，点击微信登陆

- 系统请求微信的授权系统，响应一个二维码给用户，用户扫码后点击同意

- 微信的授权服务器会对该微信用户进行验证

- 验证通过后，返回一个询问页面，是否授权给某某系统

- 用户点击确认，认证服务就会颁发一个授权码给客户端，并重定向我们的系统

- 此时我们的客户端获得授权码，根据授权码去微信的认证服务申请令牌

- 微信的认证服务器认证通过后，会颁发一个令牌给我们的系统

- 当系统拿到令牌时，也就是微信登陆成功之时

- 该令牌代表着我们的系统，有权访问该微信用户在微信中的个人信息数据

- 我们的客户端携带令牌去微信的资源服务器获取该微信用户的个人信息

- 微信资源服务器校验该令牌的合法性，通过后响应该用户的微信个人信息数据给我们的客户端

```



<br>



### 单点登录的场景

传统的多点登录系统中，每个站点都实现了本站专用的帐号数据库和登录模块。各站点的登录状态相互不认可，各站点需要逐一手工登录。

单点登录，英文是 Single Sign On，缩写为 SSO。 多个站点共用一台认证授权服务器。用户经由其中任何一个站点登录后，可以免登录访问其他所有站点。而且，各站点间可以通过该登录状态直接交互。






<br>



### 颁发Token授权方式

OAuth2的颁发Token授权⽅式：

1）**授权码（authorization-code）**  

2）**密码式（password）**提供⽤户名+密码换取token令牌

3）隐藏式（implicit）

4）客户端凭证（client credentials）

授权码模式使⽤到了回调地址，是最复杂的授权⽅式，微博、微信、QQ等第三⽅登录就是这种模式。



<br>



# 二 JSON Web Token(JWT)

JSON Web Token（JWT）是⼀个开放的⾏业标准（RFC 7519），它定义了⼀种简介的、⾃包含的协议格式，⽤于 在通信双⽅传递json对象，传递的信息经过数字签名可以被验证和信任。JWT可以使⽤HMAC算法或使⽤RSA的公 钥/私钥对来签名，防⽌被篡改。



## 1. JWT的令牌结构

JWT令牌由三部分组成，每部分中间使⽤点（.）分隔，⽐如：xxxxx.yyyyy.zzzzz

```bash
HMACSHA256(
    base64UrlEncode(header) + "." +
    base64UrlEncode(payload),
    secret)
    
# 一个典型的JWT看起来是这个样子的：
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ3bGd6cyIsImV4cCI6MTU4Nzk3MzY1NywidXNlciI6Ijk2MkYxODkwNTVFMzRFNzVERjVGMzQ0QTgxODNCODdGIn0.APehq9dxRiilgTOGyuz9qtZxvPDIJ5QIIVUCLYeX1QE

```

base64UrlEncode(header)：jwt令牌的第⼀部分。
base64UrlEncode(payload)：jwt令牌的第⼆部分。
secret：签名所使⽤的密钥

<br>



### Header头部

包括令牌的类型（即JWT）及使⽤的哈希算法（如HMAC SHA256或RSA），例如

```json

{
    "alg": "HS256",
    "typ": "JWT"
}

```

- type：声明类型，这里是jwt
- alg：声明加密的算法 通常直接使用 HMAC SHA256

将上边的内容使⽤Base64Url编码，得到⼀个字符串就是JWT令牌的第⼀部分。

<br>



### Payload负载

第⼆部分是负载，内容也是⼀个json对象，它是存放有效信息的地⽅

它可以存放jwt提供的现成字段，⽐ 如：iss（签发者）,exp（过期时间戳）, sub（⾯向的⽤户）等，也可⾃定义字段。 

此部分不建议存放敏感信息，因为此部分可以解码还原原始内容。 

最后将第⼆部分负载使⽤Base64Url编码，得到⼀个字符串就是JWT令牌的第⼆部分。 ⼀个例⼦：

```json

{
    "sub": "1234567890",
    "name": "John Doe",
    "iat": 1516239022
}

```

- iss: jwt签发者
- sub: jwt所面向的用户
- aud: 接收jwt的一方
- exp: jwt的过期时间，这个过期时间必须要大于签发时间
- nbf: 定义在什么时间之前，该jwt都是不可用的
- iat: jwt的签发时间
- jti: jwt的唯一身份标识，主要用来作为一次性token, 从而回避重放攻击
- claim：jwt存放信息的地方



<br>

### Signature签名

第三部分是签名，此部分⽤于防⽌jwt内容被篡改。 这个部分使⽤base64url将前两部分进⾏编码，编码后使⽤点（.）连接组成字符串，最后使⽤header中声明 签名算法进⾏签名。



Signature签名的生成：

首先需要指定一个secret，该secret仅仅保存在服务器中，保证不能让其他用户知道。然后使用Header指定的算法对Header和Payload进行计算，然后就得出一个签名哈希。也就是Signature。

那么Application Server如何进行验证呢？可以利用JWT前两段，用同一套哈希算法和同一个secret计算一个签名值，然后把计算出来的签名值和收到的JWT第三段比较，如果相同则认证通过。



<br>



## 2. JWT的签名验证





<br>



## 3. JWT的基本使用

首先引入Maven依赖：

```xml

<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>

```

<br>

基于Spring的JWT使用示例：

新建一个JWT工具类（也可以直接使用 `Jwts` 构建 ）：

```java

public class JwtUtil {
    private static final String SECRET_KEY = "sdffgsldfkjsldfjlsd";

    /**
     * 构建一个JWT字符串
     * @param subject 发行者
     * @param ttlMillis 过期时间(毫秒)
     * @param map 保存的数据
     * @author itdrizzle
     * @date 2022/5/17 21:19
     * @return {@link String}
     */
    public static String createJWT(String id, String subject, Long ttlMillis, Map<String, Object> map) {
        JwtBuilder jwtBuilder = Jwts.builder()
                .setSubject(subject) // 发行者
                .setId(id)
                .setIssuedAt(new Date())
                .signWith(SignatureAlgorithm.HS256, SECRET_KEY);
        if (!CollectionUtils.isEmpty(map)) {
            jwtBuilder.setClaims(map);
        }
        if (ttlMillis > 0) {
            jwtBuilder.setExpiration(new Date(System.currentTimeMillis() + ttlMillis));
        }
        return jwtBuilder.compact();
    }

    /**
     * 解析 JWT 字符串
     * @param jwtString JWT String
     * @author itdrizzle
     * @date 2022/5/17 21:20
     * @return {@link Claims}
     */
    public static Claims parseJWT(String jwtString) {
        return Jwts.parser()
                .setSigningKey(SECRET_KEY)
                .parseClaimsJws(jwtString)
                .getBody();
    }
}

```

<br>

测试示例：

```java

public class JwtTest {
    @Test
    public void testJwt() {
        HashMap<String, Object> map = new HashMap<>();
        map.put("username", "zhangsan");
        map.put("age", 18);

        String id = UUID.randomUUID().toString();

        String jwtStr = JwtUtil.createJWT(id, "user profile", 3600000L, map);
        System.out.println(jwtStr);
        // eyJhbGciOiJIUzI1NiJ9.
        // eyJleHAiOjE2NTI3OTc3MzksImFnZSI6MTgsInVzZXJuYW1lIjoiemhhbmdzYW4ifQ.
        // pamFZ44vDIM9SuaKDP81njaOZ8PQmGLcWDTEB4RI3ow

        Claims claims = JwtUtil.parseJWT(jwtStr);
        System.out.println(claims);
        //{exp=1652797739, age=18, username=zhangsan}
    }
}

```



<br>



## 4. JWT的优缺点

**JWT的优点**: 

- json格式的通用性，所以JWT可以跨语言支持，比如Java、JavaScript、PHP、Node等等。
- 可以利用Payload存储一些非敏感的信息。
- 便于传输，JWT结构简单，字节占用小。
- 不需要在服务端保存会话信息，易于应用的扩展。

<br>



**JWT的缺点**: 

- 默认情况下JWT是未加密的，任何人都可以解读其内容，因此不要构建隐私信息字段，存放保密信息，以防止信息泄露。

  安全性没法保证，所以jwt里不能存储敏感数据。因为jwt的payload并没有加密，只是用Base64编码而已。

- 无法中途废弃。因为一旦签发了一个jwt，在到期之前始终都是有效的，如果用户信息发生更新了，只能等旧的jwt过期后重新签发新的jwt。

- 续签问题。当签发的jwt保存在客户端，客户端一直在操作页面，按道理应该一直为客户端续长有效时间，否则当jwt有效期到了就会导致用户需要重新登录。那么怎么为jwt续签呢？最简单粗暴就是每次签发新的jwt，但是由于过于暴力，会影响性能。如果要优雅一点，又要引入Redis解决，但是这又把无状态的jwt硬生生变成了有状态的，违背了初衷。

- JWT本身包含认证信息，因此一旦信息泄露，任何人都可以获得令牌的所有权限。为了减少盗用，JWT的有效期不宜设置太长。对于某些重要操作，用户在使用时应该每次都进行进行身份验证。为了减少盗用和窃取，JWT不建议使用HTTP协议来传输代码，而是使用加密的HTTPS协议进行传输。

任何技术都不是完美的，所以我们得用辩证思维去看待任何一项技术。

<br>



# 三 OAuth2 + JWT 认证实现

## 1. 统一认证服务思路

Spring Cloud OAuth2 是 Spring Cloud 体系对OAuth2协议的实现，可以⽤来做多个微服务的统⼀认证（验证身份合法性）授权（验证权限）。通过向OAuth2服务（统⼀认证授权服务）发送某个类型的grant_type进⾏集中认证和授权，从⽽获得access_token（访问令牌），⽽这个token是受其他微服务信任的。

![image-20220517165035004](vx_images/image-20220517165035004.png)

注意：使⽤OAuth2解决问题的本质是，引⼊了⼀个认证授权层，认证授权层连接了资源的拥有者，在授权层⾥⾯，资源的拥有者可以给第三⽅应⽤授权去访问我们的某些受保护资源，在我们统⼀认证的场景中，Resource Server其实就是我们的各种受保护的微服务，微服务中的各种API访问接⼝就是资源，发起http请求的浏览器就是Client客户端（对应为第三⽅应⽤）



```bash

Spring Security + Oauth2：认证授权方案(使用非JWT的Token):

- 用户携带账号密码 (或者三方登陆 )请求认证服务等，请求用户认证

- 认证通过后，颁发身份令牌可客户端，并将身份令牌储存在Redis中

- 用户携带身份令牌请求资源服务，必经网关

- 网关获取客户端带来的令牌和Redis中的令牌进行比对校验

- 校验通过，服务转发，资源服务器获取到令牌，根据令牌完成授权

- 资源服务通过授权后响应数据给客户端

```



<br>



## 2. Authorization Server

认证服务器（Authorization Server），负责颁发token



