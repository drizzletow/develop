# 一 ELK的部署与配置

## 1. ES的安装与配置

elasticsearch: https://www.elastic.co/cn/downloads/elasticsearch

```shell

cd /home/software/
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-linux-x86_64.tar.gz

tar -zxvf elasticsearch-7.12.1-linux-x86_64.tar.gz
mv elasticsearch-7.12.1 /usr/local/

cd /usr/local/elasticsearch-7.12.1/
mkdir data

```

<br>

启动ES前需要注意的相关配置：

```shell

# 1. elasticsearch初步配置
vim /usr/local/elasticsearch-7.12.1/config/elasticsearch.yml

path.data: /usr/local/elasticsearch-7.12.1/data
path.logs: /usr/local/elasticsearch-7.12.1/logs

network.host: 0.0.0.0

node.name: node-1
cluster.initial_master_nodes: ["node-1"]

 #开启跨域
http.cors.enable:true          
http.cors.allow-origin:"*"


# 2. 根据服务器内存规格设置合适的内存大小
vim /usr/local/elasticsearch-7.12.1/config/jvm.options

-Xms512m
-Xmx512m



# 3. 设置elasticsearch使用其自带的jdk版本

vim /usr/local/elasticsearch-7.12.1/bin/elasticsearch

# 指定jdk11
export ES_JAVA_HOME=/usr/local/elasticsearch-7.12.1/jdk
export PATH=$ES_JAVA_HOME/bin:$PATH

# 添加jdk判断
if [ -x "$ES_JAVA_HOME/bin/java" ]; then
        JAVA="/usr/local/elasticsearch-7.12.1/jdk/bin/java"
else
        JAVA=`which java`
fi


# 4. 其他配置

vim /etc/security/limits.conf  #添加如下配置：

* soft nofile 100001
* hard nofile 100002
root soft nofile 100001
root hard nofile 100002

* soft nproc 4096
* hard nproc 4096



vim /etc/sysctl.conf     #添加如下配置：

vm.max_map_count=444444


# 修改后要记得刷新一下
sysctl -p

```

<br>

elasticsearch启动和运行（不能使用root用户运行）

```shell

useradd esuser
chown -R esuser:esuser /usr/local/elasticsearch-7.12.1/
su esuser

cd /usr/local/elasticsearch-7.12.1/bin
./elasticsearch            #前台运行  加 -d 后台运行    前台运行时ctrl+c即可关闭，后台运行时通过进程关闭

ps -ef|grep elasticsearch  #查看进程，有较多的数据 用jps试试
jps
kill 9318

```

在服务器安装 后，可以在本地浏览器（chrome）安装 `ElasticSearch Head` 插件，通过浏览器访问ES



<br>



## 2. 中文分词器—ik

安装ik分词器（[github地址](https://github.com/medcl/elasticsearch-analysis-ik/releases)，注意需要与elasticsearch版本一致）

```shell
cd /home/software/

unzip elasticsearch-analysis-ik-7.12.1.zip -d /usr/local/elasticsearch-7.12.1/plugins/ik  #需要重启es

```



自定义中文词库

```shell
vim /usr/local/elasticsearch-7.12.1/plugins/ik/config/IKAnalyzer.cfg.xml

#配置自己的词库文件名
<entry key="ext_dict">custom.dic</entry>

#添加，修改词库
vim /usr/local/elasticsearch-7.12.1/plugins/ik/config/custom.dic

```



<br>



## 4. Docker部署ELK

### elasticsearch

```bash

# 下载镜像
docker search elasticsearch
docker pull elasticsearch:7.16.3

# 创建数据、数据和日志的挂载目录
sudo mkdir -p /docker/data/elk/es/{config,data,logs}


# 赋予权限, docker中elasticsearch的用户UID是1000.
sudo chown -R 1000:1000 /docker/data/elk/es


# 创建配置文件
cd /docker/data/elk/es/config
sudo vim elasticsearch.yml
#-----------------------配置内容----------------------------------
cluster.name: "my-es"
network.host: 0.0.0.0
http.port: 9200


# 运行elasticsearch
通过镜像，启动一个容器，并将9200和9300端口映射到本机（elasticsearch的默认端口是9200，我们把宿主环境9200端口映射到Docker容器中的9200端口）。此处建议给容器设置固定ip，我这里没设置。

sudo docker run -it -d -p 9200:9200 -p 9300:9300 --name es --restart=always -e ES_JAVA_OPTS="-Xms2g -Xmx2g" -e "discovery.type=single-node"  -v /docker/data/elk/es/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v /docker/data/elk/es/data:/usr/share/elasticsearch/data -v /docker/data/elk/es/logs:/usr/share/elasticsearch/logs elasticsearch:7.16.3

```

验证安装是否成功：浏览器访问 http://localhost:9200 ，或者命令行：`curl http://localhost:9200` . 



IK分词器：

```bash

# 将Linux 中的 ik 目录复制到es容器中
sudo docker cp /home/drizzle/Software/elk/ik es:/usr/share/elasticsearch/plugins/

# 重启容器即可
sudo docker restart es

```

<br>



### 部署kibana

```bash

# 下载镜像
sudo docker pull kibana:7.16.3

# 获取elasticsearch容器ip: 172.17.0.6
sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' es

# 新建配置文件
sudo mkdir /docker/data/elk/kibana
sudo touch /docker/data/elk/kibana/kibana.yml
sudo vim /docker/data/elk/kibana/kibana.yml

#Default Kibana configuration for docker target
server.name: kibana
server.host: "0"
elasticsearch.hosts: ["http://172.17.0.6:9200"]
xpack.monitoring.ui.container.elasticsearch.enabled: true


# run kibana
sudo docker run -d --restart=always --log-driver json-file --log-opt max-size=100m --log-opt max-file=2 --name kibana -p 5601:5601 -v /docker/data/elk/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml kibana:7.16.3

```

浏览器上输入：http://localhost:5601，如无法访问进容器检查配置是否生效

<br>



### 部署logstash

```bash

# 获取logstash镜像
sudo docker pull logstash:7.16.3

# 新建logstash.yml、logstash.conf等配置文件 （此处先配置logstash直接采集本地数据发送至es）
sudo mkdir /docker/data/elk/logstash
sudo mkdir /docker/data/elk/logstash/conf.d

sudo vim /docker/data/elk/logstash/logstash.yml

http.host: "0.0.0.0"
xpack.monitoring.elasticsearch.hosts: [ "http://172.17.0.6:9200" ]
xpack.monitoring.elasticsearch.username: elastic
xpack.monitoring.elasticsearch.password: changeme
path.config: /docker/data/elk/logstash/conf.d/*.conf
path.logs: /var/log/logstash

sudo vim /docker/data/elk/logstash/conf.d/syslog.conf 

input {
  syslog {
    type => "system-syslog"
    port => 5044
  }
}
output {
  elasticsearch {
    hosts => ["192.168.5.106:9200"]           # 定义es服务器的ip
    index => "system-syslog-%{+YYYY.MM}"       # 定义索引
  }
}


# run logstash
docker run -d --restart=always --log-driver json-file --log-opt max-size=100m --log-opt max-file=2 -p 5044:5044 --name logstash -v /docker/data/elk/logstash/logstash.yml:/usr/share/logstash/config/logstash.yml -v /docker/data/elk/logstash/conf.d/:/data/docker/logstash/conf.d/ logstash:7.16.3

```





<br>



# 二 Elasticsearch

Elasticsearch 是一个基于 JSON 的分布式搜索和分析引擎。



## 2. dsl搜索






## 4. SpringBoot整合ES
官方文档：https://www.elastic.co/guide/en/elasticsearch/client/java-rest/7.12/java-rest-high.html

引入ElasticSearch的依赖 ，注意版本一致

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
    <version>2.5.2</version>
</dependency>
```



配置`application.yaml`文件 （自动注入）

```yaml

spring:
  elasticsearch:
    rest:
      uris: http://139.155.174.119:9200
      
```
```java
@Autowired
private RestHighLevelClient client;
```



**（1）Index API**

```java
//创建索引
@Test
public void createIndex() throws IOException {
    CreateIndexRequest request = new CreateIndexRequest("index_demo");
    CreateIndexResponse indexResponse = client.indices().create(request, RequestOptions.DEFAULT);
    System.out.println(indexResponse.isAcknowledged());
}

//判断索引是否存在
@Test
public void existIndex() throws IOException {
    GetIndexRequest request = new GetIndexRequest("index_demo");
    Boolean exists = client.indices().exists(request, RequestOptions.DEFAULT);
    System.out.println(exists);
}

//删除索引
@Test
public void deleteIndex() throws IOException {
    DeleteIndexRequest request = new DeleteIndexRequest("index_demo");
    AcknowledgedResponse delete = client.indices().delete(request, RequestOptions.DEFAULT);
    System.out.println(delete.isAcknowledged());
}
```

**（2）Document API**
```java
//添加文档
@Test
public void addDocument() throws IOException {
    User user = new User("tom", 18);

    IndexRequest indexRequest = new IndexRequest("index_demo");
    indexRequest.id("1001");
    indexRequest.timeout(TimeValue.timeValueSeconds(1));
    //indexRequest.timeout("1s");
    indexRequest.source(JSONUtil.toJsonStr(user), XContentType.JSON);

    IndexResponse indexResponse = client.index(indexRequest, RequestOptions.DEFAULT);
    System.out.println(indexResponse.status());
    System.out.println(indexResponse.toString());
}

//更新文档信息
@Test
public void updateDocument() throws IOException {
    UpdateRequest request = new UpdateRequest("index_demo", "1001");
    request.timeout(TimeValue.timeValueSeconds(1));

    User user = new User("jack", 17);
    request.doc(JSONUtil.toJsonStr(user), XContentType.JSON);

    UpdateResponse response = client.update(request, RequestOptions.DEFAULT);
    System.out.println(response.status());
    System.out.println(response);
}

//删除文档记录
@Test
public void deleteDocument() throws IOException {
    DeleteRequest request = new DeleteRequest("index_demo", "1001");
    request.timeout("1s");
    DeleteResponse deleteResponse = client.delete(request, RequestOptions.DEFAULT);
    System.out.println(deleteResponse.status());
}

//判断文档是否存在
@Test
public void existDocument() throws IOException {
    GetRequest request = new GetRequest("index_demo", "1001");
    //不获取返回的 _source 上下文
    request.fetchSourceContext(new FetchSourceContext(false));
    request.storedFields("_none_");

    boolean exists = client.exists(request, RequestOptions.DEFAULT);
    System.out.println(exists);

}

//获取文档信息
@Test
public void getDocument() throws IOException {
    GetRequest request = new GetRequest("index_demo", "1001");
    GetResponse getResponse = client.get(request, RequestOptions.DEFAULT);
    System.out.println(getResponse.getSourceAsString());
}
```

**（3）Bulk批处理**

```java
//批量处理（以add为例）
@Test
public void addBulkDocument() throws IOException {
    BulkRequest bulkRequest = new BulkRequest("index_demo");
    bulkRequest.timeout("10s");

    List<User> userList = new ArrayList<>();
    userList.add(new User("neil" , 18));
    userList.add(new User("lili" , 16));
    userList.add(new User("zhangsan" , 22));
    userList.add(new User("wangwu" , 19));
    userList.add(new User("tow" , 21));

    for (int i = 0; i < userList.size(); i++) {
        bulkRequest.add(new IndexRequest().id("100"+(i+1)).source(JSONUtil.toJsonStr(userList.get(i)),XContentType.JSON));
    }

    BulkResponse bulkResponse = client.bulk(bulkRequest, RequestOptions.DEFAULT);
    System.out.println(bulkResponse.hasFailures());
}
```

**（4）搜索**
```java
@Test
public void searchDocument() throws IOException {
    //构建搜索请求和搜索条件
    SearchRequest searchRequest = new SearchRequest("index_demo");
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();

    //搜索条件
    //TermQueryBuilder termQueryBuilder = QueryBuilders.termQuery("name", "zhangsan"); //精确搜索
    MatchAllQueryBuilder matchAllQueryBuilder = QueryBuilders.matchAllQuery();  //匹配所有

    searchSourceBuilder.query(matchAllQueryBuilder);
    searchSourceBuilder.timeout(new TimeValue(60, TimeUnit.SECONDS));

    searchRequest.source(searchSourceBuilder);
    SearchResponse searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);

    for (SearchHit documentFields : searchResponse.getHits()) {
        System.out.println(documentFields.getSourceAsMap());
    }
}
```



<br>



# 二 LogStash数据同步

下载安装 （ [logstash官网](https://www.elastic.co/cn/downloads/logstash) ）

```shell
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.12.1-linux-x86_64.tar.gz

tar -zxvf logstash-7.12.1-linux-x86_64.tar.gz

mv logstash-7.12.1 /usr/local/
```



[mysql-connector](https://downloads.mysql.com/archives/c-j/)

```shell
wget https://cdn.mysql.com/archives/mysql-connector-java-8.0/mysql-connector-java-8.0.23.tar.gz

tar -zxvf mysql-connector-java-8.0.23.tar.gz

cp mysql-connector-java-8.0.23/mysql-connector-java-8.0.23.jar /usr/local/logstash-7.12.1/sync/
```



同步数据配置

```shell
cd /usr/local/logstash-7.12.1/

mkdir sync
cd sync/
vim logstash-db-sync.conf
```
```json
input {
    jdbc {
        # 设置 MySql/MariaDB 数据库url以及数据库名称
        jdbc_connection_string => "jdbc:mysql://localhost:3306/foodie-shop?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai"
        # 用户名和密码
        jdbc_user => "root"
        jdbc_password => "root"
        # 数据库驱动所在位置，可以是绝对路径或者相对路径
        jdbc_driver_library => "/usr/local/logstash-7.12.1/sync/mysql-connector-java-8.0.23.jar"
        # 驱动类名
        jdbc_driver_class => "com.mysql.cj.jdbc.Driver"
        # 开启分页
        jdbc_paging_enabled => "true"
        # 分页每页数量，可以自定义
        jdbc_page_size => "1000"
        # 执行的sql文件路径
        statement_filepath => "/usr/local/logstash-7.12.1/sync/foodie-items.sql"
        # 设置定时任务间隔  含义：分、时、天、月、年，全部为*默认含义为每分钟跑一次任务
        schedule => "* * * * *"
        # 索引类型
        type => "_doc"
        # 是否开启记录上次追踪的结果，也就是上次更新的时间，这个会记录到 last_run_metadata_path 的文件
        use_column_value => true
        # 记录上一次追踪的结果值
        last_run_metadata_path => "/usr/local/logstash-7.12.1/sync/track_time"
        # 如果 use_column_value 为true， 配置本参数，追踪的 column 名，可以是自增id或者时间
        tracking_column => "updated_time"
        # tracking_column 对应字段的类型
        tracking_column_type => "timestamp"
        # 是否清除 last_run_metadata_path 的记录，true则每次都从头开始查询所有的数据库记录
        clean_run => false
        # 数据库字段名称大写转小写
        lowercase_column_names => false
    }
}
output {
    elasticsearch {
        # es地址
        hosts => ["139.155.174.119:9200"]
        # 同步的索引名
        index => "foodie-items"
        # 设置_docID和数据相同
        document_id => "%{id}"
        # document_id => "%{itemId}"
    }
    # 日志输出
    stdout {
        codec => json_lines
    }
}
```

```shell
vim foodie-items.sql
```
```sql
SELECT
    i.id as itemId,
    i.item_name as itemName,
    i.sell_counts as sellCounts,
    ii.url as imgUrl,
    tempSpec.price_discount as price,
    i.updated_time as updated_time
FROM
    items i
LEFT JOIN  items_img ii on i.id = ii.item_id
LEFT JOIN
    (SELECT item_id,MIN(price_discount) as price_discount from items_spec GROUP BY item_id) tempSpec
on
    i.id = tempSpec.item_id
WHERE
    ii.is_main = 1
    AND i.updated_time >= :sql_last_value
```

- 启动运行和关闭





<br>



# 三 kibana

Kibana 是一个可扩展的用户界面，您可以借助它对数据进行可视化分析。

