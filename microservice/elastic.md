# 一 Elasticsearch基础概念

**Elasticsearch 是一个分布式、RESTful 风格的搜索和数据分析引擎**，其在 [DB-Engines](https://link.juejin.cn/?target=https%3A%2F%2Fdb-engines.com%2Fen%2Franking%2Fsearch%2Bengine) “兵器”排行榜中`长期位列第一`。

除了搜索领域外，Elasticsearch 与 Kibana、Logstash 组成的 ELK 系统还可以应用到日志采集、分析、监控等领域。

1. ES是elaticsearch简写， Elasticsearch是一个开源的高扩展的分布式全文检索引擎，它可以**近乎实时的存储**、检索数据；

   本身扩展性很好，可以扩展到上百台服务器，处理PB级别的数据。 

2. Elasticsearch也使用Java开发并使用Lucene作为其核心来实现所有索引和搜索的功能，但是它的目的是通过简单的RESTful API来隐藏Lucene的复杂性，从而让全文搜索变得简单。

简单来说 `ElasticSearch` 就是一个搜索框架、是一个基于 JSON 的分布式搜索和分析引擎。

<br>



## 1. ES基础概念详解

对于搜索这个词我们并不陌生，当我们输入关键词后，返回含有该关键词的所有信息结果。

在我们平时用到最多的便是数据库搜索：

```sql

SELECT * FROM USE WHERE NAME LIKE %demo%

```

但是用数据库做搜索存在着许多弊端，例如：

- **存储问题**：当数据量大的时候就必须进行分库分表。
- **性能问题**：当数据量过大时，使用`LIKE`会对上亿条数据进行逐行扫描，性能受到严重影响。
- **不能分词**：当我们搜索 **游戏本电脑** 的时候，只会返回完全和关键词一样的数据，如果搜索 **游戏电脑**，那么是不是就会没有数据返回。

因此基于以上问题，`ElasticSearch`出现了。它是使用 **Java** 开发的，基于 **Lucene**、分布式、通过 **Restful** 方式进行交互的近实时搜索平台框架。它的优点如下：

- 分布式的搜索引擎和数据分析引擎
- 全文检索，结构化检索和数据分析
- 对海量数据进行近实时的处理



<br>



### ES中的基本概念

1）节点（Node）	

​    运行了**单个实例的ES主机称为节点**，它是集群的一个成员，可以存储数据、参与集群索引及搜索操作。

​	节点通过为其配置的ES集群名称确定其所要加入的集群。

2）集群（cluster）

​    ES可以作为一个独立的单个搜索服务器。不过，一般为了处理大型数据集，实现容错和高可用性，

​	ES可以运行在许多互相合作的服务器上。这些服务器的集合称为集群。



3）分片（Shard）

​    ES的“分片(shard)”机制可将一个索引内部的数据分布地存储于多个节点，它通过**将一个索引切分为多个**底层物理的

​	Lucene索引完成**索引数据的分割存储**功能，这每一个物理的Lucene索引称为一个分片(shard)。

​    这样的好处是可以**把一个大的索引拆分成多个，分布到不同的节点上**。降低单服务器的压力，构成分布式搜索，

​	**提高整体检索的效率（分片数的最优值与硬件参数和数据量大小有关）** 。

​	分片的数量**只能在索引创建前指定，并且索引创建后不能更改。** 



4）副本（Replica）

​    副本是一个分片的**精确复制**，每个分片可以有零个或多个副本。

​	副本的作用一是**提高系统的容错性**，当某个节点某个分片损坏或丢失时可以从副本中恢复。

​	二是**提高es的查询效率**，es会自动对搜索请求进行负载均衡。

<br>



### ES的数据架构

1）索引（index）

ES将数据存储于一个或多个索引中，索引是具有类似特性的文档的集合。类比传统的关系型数据库领域来说，**索引相当于SQL中的一个数据库。** 一个ES集群中可以按需创建任意数目的索引，但根据不同的硬件配置，**索引数有一个建议范围**（这个知识点我们以后进行详细讲解）。



2）类型（Type） 

类型是索引内部的逻辑分区(category/partition)，然而其意义完全取决于用户需求。因此，一个索引内部可定义一个或多个类型(type)。一般来说，类型就是为那些拥有相同的域的文档做的预定义。类比传统的关系型数据库领域来说，**类型相当于“表”**。

**特别注意的是，**根据官网信息：在Elasticsearch 6.0.0或更高版本中创建的索引**只能包含一个映射类型**。在5.x中创建的具有多种映射类型的索引将继续像在Elasticsearch 6.x中一样工作。**类型将在Elasticsearch 7.0.0中的API中弃用，并在8.0.0中完全删除。**



3）文档（Document）

​    文档是Lucene索引和搜索的原子单位，它是包含了一个或多个域的容器，基于JSON格式进行表示。文档由一个或多个域组成，每个域拥有一个名字及一个或多个值，有多个值的域通常称为“多值域”。每个文档可以存储不同的域集，但同一类型下的文档至应该有某种程度上的相似之处。**相当于mysql表中的row**。



4）映射（Mapping）

​    映射是定义文档及其包含的字段如何存储和索引的过程。例如，使用映射来定义：

- - 哪些字符串字段应该被视为全文字段。
  - 哪些字段包含数字、日期或地理位置。
  - 文档中所有字段的值是否应该被索引到catch-all _all字段中。
  - 日期值的格式。
  - 用于控制动态添加字段的映射的自定义规则。

​    **每个索引都有一个映射类型，它决定了文档的索引方式。**



5）与 mysql 的对比

传统关系型数据库和Elasticsearch的区别, **不恰当的 mysql 和 Elasticsearch 对比**：

| RDBMS（关系型数据库） | Elasticsearch      |
| --------------------- | ------------------ |
| Database(数据库)      | Index              |
| Table  （表）         | Index (原来的Type) |
| Row（一行数据）       | Document （文档）  |
| Column （数据列）     | Filed （字段）     |
| Schema （约束）       | Mapping （映射）   |
| SQL                   | DSL                |

在 7.0之前，一个Index可以设置多个Types，但目前Type己经被Deprecated，7.0开始，一个索引只能创建一个Type - “_doc”



<br>



## 2. Index索引操作

**Index**就相当于数据库中的数据表，`ElasticSearch`会索引所有字段，经过处理后写入一个反向索引（Inverted Index）。

查找数据的时候，直接查找该索引。所以，`ElasticSearch`数据管理的顶层单位就叫做 **Index（索引）** 

**注：** 每个 **Index** 的名字必须是小写。索引是文档的容器，是一类文档的集合

- Index 体现了逻辑空间的概念：每个索引都有自己的 Mapping 定义，用于定义包含的文档的字段名和类型
- Shard 体现了物理空间的概念，索引中的数据在Shard上
- Mapping 定义文档字段的类型
- Setting 定义不同的数据分布（分片）.



### 索引创建及映射

```bash

# 创建索引名为 demo_index 的索引
PUT /demo_index?pretty
{
# 索引设置
  "settings": {
    "index": { 
      "number_of_shards": 1,    # 分片数量设置为1，默认为5
      "number_of_replicas": 1   # 副本数量设置为1，默认为1
    }
  },
# 映射配置
  "mappings": {  
    "_doc": {                # 类型名，强烈建议设置为 _doc
      "dynamic": false,      # 动态映射配置
# 字段属性配置
      "properties": {
        "id": {
          "type": "integer"   # 表示字段id，类型为integer
        },
        "name": {
          "type": "text",
          "analyzer": "ik_max_word",     # 存储时的分词器
          "search_analyzer": "ik_smart"  # 查询时的分词器
        },
        "createAt": {
          "type": "date"
        }
      }
    }
  }
}

# 返回值如下：
{
  "acknowledged": true,         # 是否成功创建了索引
  "shards_acknowledged": true,
  "index": "tehero_index"
}

```

<br>

### 查询索引信息

```bash

GET /demo_index       # 索引名，可以同时检索多个索引或所有索引 如：
GET /*    
GET /demo_index,other_index

GET /_cat/indices?v  #查看所有 index

```

<br>



### 索引更新与删除

```bash

# 修改副本数
PUT /demo_index/_settings
{
    "index" : {
        "number_of_replicas" : 2
    }
}

# 修改分片刷新时间,默认为1s
PUT /demo_index/_settings
{
    "index" : {
        "refresh_interval" : "2s"
    }
}

# 新增字段 age
PUT /demo_index/_mapping/_doc
{
  "properties": {
    "age": {
      "type": "integer"
    }
  }
}


# 删除索引
DELETE /demo_index

# 验证索引是否存在 (不存在则返回：404 - Not Found)
HEAD demo_index

```



<br>



## 3. Document文档

- Elasticsearch 是面向文档的，文档是所有可搜索数据的最小单位, 常见文档如：
  - 日志文件中的日志项
  - 一本电影的具体信息/一张唱片的详细信息
  - MP3播放器里的一首歌/ 一篇PDF文档中的具体内容
- 文档会被序列化成JSON格式，保存在Elasticsearch中
  - JSON对象由字段组成
  - 每个字段都有对应的字段类型（字符串/数值/布尔/日期/二进制/范围类型)
- 每个文档都有一个Unique 0
  - 你可以自己指定ID
  - 或者通过Elasticsearch自动生成

​	一个**document**就像数据库中的一条记录。通常以**json**格式显示。多个**document**存储于一个索引（**Index**）中

<br>



### 添加与查询方法

Add documents to a data stream： [官方文档（7.16）](https://www.elastic.co/guide/en/elasticsearch/reference/current/use-a-data-stream.html#add-documents-to-a-data-stream) . 

```bash

# 添加一个Document ( PUT 方式 需要指定文档ID)
PUT /employee/_doc/1
{
    "id":"1",
    "name":"小黄",
    "department":{
        "id":"1",
        "deptName":"搬砖部",
        "describe":"努力搬好每一块砖"
    }
}

# 添加一个Document （ POST 方式 自动生成文档ID）
POST /employee/_doc
{
    "id":"22",
    "name":"小明",
    "department":{
        "id":"1",
        "deptName":"搬砖部",
        "describe":"努力搬好每一块砖"
    }
}






```

简单的查询使用：

```bash

# 查询一条document记录
GET /employee/_doc/1

# 搜索 （获取索引下的所有数据）
GET /employee/_doc/_search

```



<br>



### 更新与删除方法

```bash

# 更新一条Document记录信息（存在则更新；不存在则新增：注意更新要带上所有信息）
PUT /employee/_doc/1
{
    "id":"1",
    "name":"kunkun",
    "department":{
        "id":"1",
        "deptName":"篮球部",
        "describe":"jijjjjj"
    }
}

# 局部更新操作：POST /{index}/_update/{id}
POST /employee/_update/1
{
  "doc":{
    "name":"ikun"  
  }
}

# 根据查询条件id=10，修改name="更新后的name"（版本冲突而不会导致_update_by_query 中止）
POST demo_index/_update_by_query
{
  "script": {
    "source": "ctx._source.name = params.name",
    "lang": "painless",
    "params":{
      "name":"更新后的name"
    }
  },
  "query": {
    "term": {
      "id": "10"
    }
  }
}


# 删除Document (根据id，删除单个数据)
DELETE /employee/_doc/1

# delete by query
POST demo_index/_delete_by_query
{
  "query": {
    "match": {
     "age": "2"
    }
  }
}

```

<br>



### 文档的元数据

元数据，用于标注文档的相关信息

```bash
# 通过 GET 方法，可以获取到一条文档信息, 其中出现 8 个字段
GET /employee/_doc/1

{
  "_index" : "employee",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 4,
  "_seq_no" : 3,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "id" : "1",
    "name" : "ikun1",
    "department" : {
      "id" : "1",
      "deptName" : "篮球部",
      "describe" : "jijjjjj"
    }
  }
}

```

- **_index**  ：文档所属的索引名称

- **_type** ：文档所属的类型名, 在 **es9** 只有会删除此字段，因此不用关注，默认都为 **_doc** . 

- **_id**：文档的唯一标志，类似于表中的主键ID，可以用来标识和定义一个文档。可以手动生成，也可以自动生成

- **_source**：文档的原始JSON数据， 插入数据的所有字段和值

- **_version**:  文档的版本信息

  这里的版本号是在 **全量替换** 、 **局部更新**和 **删除** 操作时，版本号都会加 **1**，例如上面 ID 为 1 的员工信息版本包为4，说明这条记录已经更新了 4 次。

- **_seq_no**：序列号, 作用与 **version** 类似，当数据发生变更时，值就会加 **1** . 

​	<br>

- **_alk** ：整合所有字段内容到该字段，已被废除

- **_score**:  相关性打分 



<br>

## 4. ES的数据类型

Field datatypes：Elasticsearch supports a number of different datatypes for the fields in a document:

https://www.elastic.co/guide/en/elasticsearch/reference/6.8/mapping-types.html#_core_datatypes 



### Core datatypes

- **string** 

  [`text`](https://www.elastic.co/guide/en/elasticsearch/reference/current/text.html) and [`keyword`](https://www.elastic.co/guide/en/elasticsearch/reference/current/keyword.html) . （**text——会分词**  ,  **keywor——不会分词**）

- **[Numeric datatypes](https://www.elastic.co/guide/en/elasticsearch/reference/current/number.html)**

  `long`, `integer`, `short`, `byte`, `double`, `float`, `half_float`, `scaled_float`

- **[Date datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/date.html)**

  `date`

- **[Boolean datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/boolean.html)**

  `boolean`

- **[Binary datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/binary.html)**

  `binary`

- **[Range datatypes](https://www.elastic.co/guide/en/elasticsearch/reference/current/range.html)**

  `integer_range`, `float_range`, `long_range`, `double_range`, `date_range`, `ip_range`

### Complex datatypes

- **[Object datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/object.html)**

  `object` for single JSON objects

- **[Nested datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/nested.html)**

  `nested` for arrays of JSON objects

### Geo datatypes

- **[Geo-point datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/geo-point.html)**

  `geo_point` for lat/lon points

- **[Geo-Shape datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/geo-shape.html)**

  `geo_shape` for complex shapes like polygons

### Specialised datatypes

- **[IP datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/ip.html)**

  `ip` for IPv4 and IPv6 addresses

- **[Completion datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-suggesters-completion.html)**

  `completion` to provide auto-complete suggestions

- **[Token count datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/token-count.html)**

  `token_count` to count the number of tokens in a string

- **[`mapper-murmur3`](https://www.elastic.co/guide/en/elasticsearch/plugins/current/mapper-murmur3.html)**

  `murmur3` to compute hashes of values at index-time and store them in the index

- **[`mapper-annotated-text`](https://www.elastic.co/guide/en/elasticsearch/plugins/current/mapper-annotated-text.html)**

  `annotated-text` to index text containing special markup (typically used for identifying named entities)

- **[Percolator type](https://www.elastic.co/guide/en/elasticsearch/reference/current/percolator.html)**

  Accepts queries from the query-dsl

- **[`join` datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/parent-join.html)**

  Defines parent/child relation for documents within the same index

- **[Alias datatype](https://www.elastic.co/guide/en/elasticsearch/reference/current/alias.html)**

  Defines an alias to an existing field.

### Arrays数组类型

In Elasticsearch, arrays do not require a dedicated field datatype. Any field can contain zero or more values by default, however, all values in the array must be of the same datatype. See [Arrays](https://www.elastic.co/guide/en/elasticsearch/reference/current/array.html).



It is often useful to index the same field in different ways for different purposes. 

For instance, a `string` field could be mapped as a `text` field for full-text search, and as a `keyword` field for sorting or aggregations. 

Alternatively, you could index a text field with the [`standard` analyzer](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-standard-analyzer.html), the [`english`](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lang-analyzer.html#english-analyzer) analyzer, and the [`french` analyzer](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lang-analyzer.html#french-analyzer).

This is the purpose of *multi-fields*. Most datatypes support multi-fields via the [`fields`](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html) parameter.



<br>



## 5. 批量操作BulkAPI



```bash

# 批量操作
POST _bulk
{ "index" : { "_index" : "hero_test1", "_type" : "_doc", "_id" : "1" } }
{ "this_is_field1" : "this_is_index_value" }
{ "delete" : { "_index" : "hero_test1", "_type" : "_doc", "_id" : "2" } }
{ "create" : { "_index" : "hero_test1", "_type" : "_doc", "_id" : "3" } }
{ "this_is_field3" : "this_is_create_value" }
{ "update" : {"_id" : "1", "_type" : "_doc", "_index" : "tehero_test1"} }
{ "doc" : {"this_is_field2" : "this_is_update_value"} }

# 查询所有数据
GET /tehero_test1/_doc/_search

```



<br>



## 6. 倒排索引和分词器

倒排索引是 Elasticsearch 中非常**重要的索引结构**，是从**文档单词到文档 ID** 的映射过程



倒排序索引包含两个部分：

- **》单词词典：**记录所有文档单词，记录单词到倒排列表的关联关系
- 》**倒排列表：**记录单词与对应文档结合，由倒排索引项组成

倒排索引项：

- 》**文档**
- 》**词频 TF** - 单词在文档中出现的次数，用于相关性评分
- 》**位置（Position）-** 单词在文档中分词的位置，用于phrase query
- 》**偏移（Offset）**- 记录单词开始结束的位置，实现高亮显示

有关倒排索引的工作主要包括2个过程：1、创建倒排索引；2、倒排索引搜索

<br>



**Analysis分词**：

Analysis：即文本分析，是把**全文本转化为一系列单词（term/token）的过程**，也叫分词；

在Elasticsearch 中可通**过内置分词器实现分词，也可以按需定制分词器**。



<br>



# 二 ELK的部署与配置

`ELK`是一个免费开源的日志分析架构技术栈总称，其中包含三大基础组件，分别是 `ElasticSearch`、`Logstash`、`Kibana`。`ELK`在实际开发中不仅仅使用于日志分析，它还可以支持其他任何数据搜索、分析和收集的场景，其中日志分析和收集更具有代表性

## 1. Linux环境安装ELK

### Elasticsearch的安装

elasticsearch: https://www.elastic.co/cn/downloads/elasticsearch

```shell

cd ~/software/
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.3-linux-x86_64.tar.gz

tar -zxvf elasticsearch-7.16.3-linux-x86_64.tar.gz -C /usr/local/elastic

cd /usr/local/elastic
mv elasticsearch-7.16.3 elasticsearch
mkdir elasticsearch/data

```

<br>

启动ES前需要注意的相关配置：

```shell

# 1. elasticsearch初步配置
vim /usr/local/elastic/elasticsearch/config/elasticsearch.yml

path.data: /usr/local/elastic/elasticsearch/data
path.logs: /usr/local/elastic/elasticsearch/logs

network.host: 0.0.0.0

node.name: es-node-1
cluster.initial_master_nodes: ["es-node-1"]

 #开启跨域
http.cors.enable:true          
http.cors.allow-origin:"*"


# 2. 根据服务器内存规格设置合适的内存大小
vim /usr/local/elastic/elasticsearch/config/jvm.options

-Xms512m
-Xmx512m



# 3. 设置elasticsearch使用其自带的jdk版本

vim /usr/local/elastic/elasticsearch/bin/elasticsearch

# 指定jdk11
export ES_JAVA_HOME=/usr/local/elastic/elasticsearch/jdk
export PATH=$ES_JAVA_HOME/bin:$PATH

# 添加jdk判断
if [ -x "$ES_JAVA_HOME/bin/java" ]; then
        JAVA="/usr/local/elastic/elasticsearch/jdk/bin/java"
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
chown -R esuser:esuser /usr/local/elastic/elasticsearch/
su esuser

cd /usr/local/elastic/elasticsearch/bin
./elasticsearch            #前台运行  加 -d 后台运行    前台运行时ctrl+c即可关闭，后台运行时通过进程关闭

ps -ef|grep elasticsearch  #查看进程，有较多的数据 用jps试试
jps
kill 9318

```

在服务器安装 后，可以在本地浏览器（chrome）安装 `ElasticSearch Head` 插件，通过浏览器访问ES



<br>



### logstash和kibana

**安装Kibana**：(安装完成后访问：http://192.168.5.92:5601/)

```bash

# 修改kibana配置文件
vim ./config/kibana.yml

server.port: 5601
server.host: "0.0.0.0"
server.name: "kibana"
elasticsearch.hosts: ["http://127.0.0.1:9200"]
elasticsearch.requestTimeout: 99999


# 切换到kibana的bin目录启动kibana
cd /usr/local/elastic/kibana/bin/
nohup ./kibana --allow-root &

# 关闭 Kibana
netstat -tunlp|grep 5601   # 查询kibana进程
kill -9 xxx

```

<br>

**安装Logstash**：

logstash下config文件夹下添加 `test.conf` 文件内容：

```properties

input {
  tcp {
    mode => "server"
    host => "0.0.0.0"
    port => 4560
    codec => json_lines
  }
  file {
    type => "flow"
    path => "/usr/local/elastic/logstash/logs/*.txt"
    discover_interval => 5
    start_position => "beginning" 
  }
}

output {
  elasticsearch {
    hosts => "127.0.0.1:9200"
    index => "logstash-%{+YYYY.MM.dd}"
  }
}

```

启动 logstash:  `nohup ./logstash -f ../config/test.conf &`    , 暴露出 4560 端口接受日志 

<br>



### 中文分词器—ik

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



## 2. Docker-compose

使用docker-compose安装 ` ELK ( elasticsearch + Logstash + kibana )`：

在 `/docker/data/elastic` 目录下（自定义的elk数据及配置存放目录）， 先创建 `docker-compose.yaml` 文件 

```yaml

# elk.yml
version: '3'
services:
  elasticsearch:
    image: elasticsearch:7.16.3
    container_name: elasticsearch
    restart: always
    environment:
      # 开启内存锁定
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - "TAKE_FILE_OWNERSHIP=true"
      # 指定单节点启动
      - discovery.type=single-node
    ulimits:
      # 取消内存相关限制  用于开启内存锁定
      memlock:
        soft: -1
        hard: -1
    volumes:
      - ./es/data:/usr/share/elasticsearch/data
      - ./es/logs:/usr/share/elasticsearch/logs
      - ./es/plugins:/usr/share/elasticsearch/plugins
      - ./es/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml #配置文件挂载
    ports:
      - "9200:9200"
  kibana:
    image: kibana:7.16.3
    container_name: kibana
    restart: always
    depends_on:
      - elasticsearch #kibana在elasticsearch启动之后再启动
    environment:
      ELASTICSEARCH_HOSTS: http://elasticsearch:9200
      I18N_LOCALE: zh-CN
    ports:
      - "5601:5601"
  logstash:
    image: logstash:7.16.3
    container_name: logstash
    restart: always
    depends_on:
      - elasticsearch #logstash在elasticsearch启动之后再启动
    links:
      - elasticsearch:es #可以用es这个域名,访问elasticsearch服务
    environment:
      XPACK_MONITORING_ENABLED: "false"
      pipeline.batch.size: 10
    volumes:
      - ./logstash/conf/logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    ports:
      - "4560:4560" #设置端口

```

<br>

创建 elasticsearch 目录 创建 data，config，plugins 目录

```bash

sudo mkdir -p /docker/data/elastic/es/{config,data,logs,plugins}

```

/docker/data/elastic/es/config 文件夹下创建 elasticsearch.yml

```properties

network.host: 0.0.0.0  #允许访问的网络
http.cors.enabled: true #跨域配置
http.cors.allow-origin: "*"
#xpack.security.enabled: true  #开启密码配置

```

<br>

/docker/data/elastic/logstash/conf 文件夹下创建 xxxx.conf

```properties

input {
  tcp {
    mode => "server"
    host => "0.0.0.0"
    port => 4560
    codec => json_lines
  }
  file {
    type => "flow"
    path => "/docker/data/elastic/logstash/logs/*.txt"
    discover_interval => 5
    start_position => "beginning" 
  }
}

output {
  elasticsearch {
    hosts => "es:9200"
    index => "logstash-%{+YYYY.MM.dd}"
  }
}

```

<br>

在docker-compose.yml 文件所在目录，执行下列命令，启动elk

```bash

docker-compose up -d   # 进行启动

```

<br>

IK中文分词器：

```bash

# 将Linux 中的 ik 目录复制到 elasticsearch 容器中
sudo docker cp /home/drizzle/Software/elk/ik elasticsearch:/usr/share/elasticsearch/plugins/

# 重启容器即可
sudo docker restart elasticsearch

```

<br>



## 3. ELK集群化部署







<br>



# 三 Elasticsearch及搜索





<br>



## 1. DSL搜索





<br>




## 2. RestHighLevelClient
官方文档：https://www.elastic.co/guide/en/elasticsearch/client/java-rest/current/java-rest-high.html

引入ElasticSearch的依赖 ，注意版本一致

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
    <version>2.5.2</version>
</dependency>
```

<br>

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

<br>

### 索引IndexAPI

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

<br>

### Document API

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

<br>

### 批处理BulkAPI

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



### 搜索相关的API

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



## 3. Java API Client

在Elasticsearch7.15版本之后，Elasticsearch官⽅宣布弃⽤了它的⾼级客户端RestHighLevelClient。

同时推出了全新的Java API客户端Elasticsearch Java API Client。

Elasticsearch Java API Client ⽀持除 Vector tile search API 和 Find structure API 之外的所有 Elasticsearch API。

且⽀持所有API数据类型，并且不再有原始JsonValue属性。

它是针对Elasticsearch8.0及之后版本的客户端，⽬前Elasticsearch已经更新⾄8版本，所以我们需要了解新的Elasticsearch Java API Client的使⽤⽅法。

官方文档：https://www.elastic.co/guide/en/elasticsearch/client/java-api-client/current/index.html

<br>



环境要求：⾸先，你的项⽬需要⽀持Java8或以上，并且你的项⽬需要有⼀个Json对象映射库，⽐如Jackson等

```xml

<dependency>
    <groupId>co.elastic.clients</groupId>
    <artifactId>elasticsearch-java</artifactId>
    <version>8.1.3</version>
    <exclusions>
        <exclusion>
            <groupId>jakarta.json</groupId>
            <artifactId>jakarta.json-api</artifactId>
        </exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>jakarta.json</groupId>
    <artifactId>jakarta.json-api</artifactId>
    <version>2.1.0</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.13.3</version>
</dependency>

```

<br>

创建连接：

```java

// 创建低级客户端
RestClient restClient = RestClient.builder(new HttpHost("localhost", 9200)).build();

// 使⽤Jackson映射器创建传输层
ElasticsearchTransport transport = new RestClientTransport(restClient, new JacksonJsonpMapper());

// 创建API客户端
ElasticsearchClient client = new ElasticsearchClient(transport);

```

<br>







<br>



# 四 LogStash数据同步

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



# 五 kibana图形界面管理

Kibana 是一个可扩展的用户界面，您可以借助它对数据进行可视化分析。



管理索引

- Kibana > 左侧菜单Stack Manager > 索引管理

  

开发工具，rest api

- 根据名称查索引： GET /_cat/indices/kibana*?v&s=index
- 状态索引查询：GET /_cat/indices?v&health=green
- 根据文档个数限制：GET /_cat/indices?v&s=docs.count:desc
- 查看索引占用内存：GET /_cat/indices?v&h=i,tm&s=tm:desc
- 查看索引各种字段：GET /_cat/indices/kibana*?pri&v&h=health,index,pri,rep,docs,count,mt



<br>



