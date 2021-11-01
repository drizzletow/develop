# 一 建表、填充数据
CREATE TABLE department
(
    dep_id      int primary key,
    name    varchar(14),
    address varchar(13)
);
insert into department (id, name, address)
values (10, '服务部', '北京'),
       (20, '研发部', '上海'),
       (30, '销售部', '北京'),
       (40, '主管部', '北京'),
       (60, '神秘部门', '成都');

CREATE TABLE employee
(
    id        int,
    name      varchar(50),
    job       varchar(50),
    manager   int comment '管理员编号',
    hire_date date comment '雇佣时间',
    salary    double,
    benefits  double comment '福利、津贴',
    dep_id    int
);

insert into employee (id, name, job, manager, hire_date, salary, benefits, dep_id)
values (1001, '张三', '文员', 1006, '2019-1-1', 1000, 2010, 10),
       (1002, '李四', '程序员', 1006, '2019-2-1', 1100, 2000, 20),
       (1003, '王五', '程序员', 1006, '2019-3-1', 1020, 2011, 20),
       (1004, '赵六', '销售', 1006, '2019-4-1', 1010, 2002, 30),
       (1005, '张猛', '销售', 1006, '2019-5-1', 1001, 2003, 50),
       (1006, '谢娜', '主管', 1006, '2019-6-1', 1011, 2004, 40);

# 二 连表查询练习

# 1. 连表查询：生成笛卡尔积
select *
from department,
     employee;

# 连表查询：生成笛卡尔积，并用主外键关系做为条件来去除无用信息
select *
from employee,
     department
where department.dep_id = employee.dep_id;

# 上面查询结果会把两张表的所有列都查询出来，也许你不需要那么多列，这时可以指定要查询的列:
select e.name, e.job, e.salary, d.name
from employee as e,
     department as d
where d.id = e.dep_id;

# 2. 内连接: 上面的连接语句就是内连接，但它不是SQL标准中的查询方式
select e.name, e.job, e.salary, d.name
from employee as e
         inner join department as d
                    on d.id = e.dep_id;



# 外连接
# 左外连接，是先查询出左表（即以左表为主），然后查询右表，右表中满足条件的显示出来，不满足条件的显示NULL
select e.name, e.job, e.salary, d.name
from employee as e
         left outer join department as d
                         on d.id = e.dep_id;

# 右外连接， 先把右表中所有记录都查询出来，然后左表满足条件的显示，不满足显示NULL
select e.name, e.job, e.salary, d.name
from employee as e
         right outer join department as d
                          on d.id = e.dep_id;











