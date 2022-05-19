# 一 RestTemplate

RestTemplate 是从 Spring3.0 开始支持的一个 HTTP 请求工具，它提供了常见的REST请求方案的模版，例如 GET 请求、POST 请求、PUT 请求、DELETE 请求以及一些通用的请求执行方法 exchange 以及 execute。

RestTemplate 继承自 InterceptingHttpAccessor 并且实现了 RestOperations 接口，其中 RestOperations 接口定义了基本的 RESTful 操作，这些操作在 RestTemplate 中都得到了实现。

```bash

`RestTemplate`: The original Spring REST client with a synchronous, template method API.

-> RestTemplate 是一个同步的 Rest API 客户端

```

Spring官网文档：https://docs.spring.io/spring-framework/docs/5.1.9.RELEASE/spring-framework-reference/integration.html#rest-resttemplate

<br>



## 1. 创建RestTemplate

创建 RestTemplate对象时可以通过 ClientHttpRequestFactory 这个请求工厂，统一设置请求的超时时间，设置代理以及一些其他细节 (当然也可以不做任何设置，直接 `new RestTemplate()` 即可 )

```java

@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate(@Qualifier("myFactory") ClientHttpRequestFactory factory){
        RestTemplate restTemplate = new RestTemplate(factory);
        return restTemplate;
    }

    @Bean("myFactory")
    public ClientHttpRequestFactory simpleClientHttpRequestFactory(){
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setReadTimeout(5000);
        factory.setConnectTimeout(15000);
        // 设置代理
        //factory.setProxy(null);
        return factory;
    }
}

```

通过上面代码配置后，我们直接在代码中注入 RestTemplate 就可以使用了。



<br>



## 2. RestTemplate接口调用





### Header和Cookie







<br>



## 3. **HttpMessageConverter** 



<br>



## 4. 拦截器Interceptor







<br>



# 二 服务调用的负载均衡

## 1. Ribbon负载均衡







<br>



## 2. LoadBalancer







<br>



# 三 面向接口的服务调用



## 1. OpenFeign

Spring Cloud OpenFeign：https://spring.io/projects/spring-cloud-openfeign