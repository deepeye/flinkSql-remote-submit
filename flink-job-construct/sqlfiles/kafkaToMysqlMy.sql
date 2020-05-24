--{"user_id": "543462", "item_id":"1715", "category_id": "1464116", "behavior": "pv", "ts": "2017-11-26T01:00:00Z"}
--{"user_id": "662867", "item_id":"2244074", "category_id": "1575622", "behavior": "pv", "ts": "2017-11-26T01:00:00Z"}

CREATE TABLE user_log (
    user_id VARCHAR,
    item_id VARCHAR,
    category_id VARCHAR,
    behavior VARCHAR,
    ts TIMESTAMP
) WITH(
    'connector.type' = 'kafka',-- 使用 kafka connector
    'connector.version' = 'universal',-- kafka 版本，universal 支持 0.11 以上的版本
    'connector.topic' = 'test',-- kafka topic
--    'connector.startup-mode' = 'earliest-offset',-- 从起始 offset 开始读取
    'connector.startup-mode' = 'latest-offset',-- 从最新 offset 开始读取
    'connector.properties.0.key' = 'bootstrap.servers',-- 连接信息
    'connector.properties.0.value' = 'hd1-tech-vpc-back-flink-hangzhou-prod-002:9092',
    'connector.properties.1.key' = 'group.id',
    'connector.properties.1.value' = 'testGroup',
    'format.type' = 'json',-- 数据源格式为 json
    'update-mode' = 'append',
    'format.derive-schema' = 'true'-- 从 DDL schema 确定 json 解析规则
);

CREATE TABLE user_behavior_sink (
    user_id VARCHAR,
    item_id VARCHAR,
    category_id VARCHAR,
    behavior VARCHAR
) WITH (
    'connector.type' = 'jdbc', -- 使用 jdbc connector
    'connector.url' = 'jdbc:mysql://rm-bp11ogsh57b088q97.mysql.rds.aliyuncs.com:3306/poster_data_analysis', -- jdbc url
--    'connector.url' = 'jdbc:mysql://localhost:3306/hot_data_analysis', -- jdbc url
    'connector.table' = 'user_behavior_sink', -- 表名
    'connector.username' = 'bigdata_root', -- 用户名
    'connector.password' = 'CGr5oeh73@#$%^&e385CaZWnh8-test', -- 密码
    'connector.write.flush.max-rows' = '1' -- 默认5000条，为了演示改为1条
);

INSERT INTO user_behavior_sink
SELECT
  user_id,
  item_id,
  category_id,
  behavior
FROM user_log;