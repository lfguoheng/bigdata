-- create database if not exists
CREATE DATABASE IF NOT EXISTS events;
-- use database - events
USE events;

-- check if user_friend table exists
DROP TABLE IF EXISTS user_friend;
-- create user_friend table
CREATE EXTERNAL TABLE user_friend(row_key STRING, user_id STRING, friend_id STRING)
    STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
    WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key, uf:user_id, uf:friend_id')
    TBLPROPERTIES ('hbase.table.name' = 'user_friend');

-- check if events table exists
DROP TABLE IF EXISTS user_friend_count;
-- Adjust the heap size for the execution
set hive.tez.container.size=2048;
set hive.tez.java.opts=-Xmx1700m;
-- create user_friend_count table
CREATE TABLE user_friend_count AS 
    SELECT 
        user_id, 
        count(*) AS friend_count 
    FROM user_friend 
    GROUP BY user_id; 
