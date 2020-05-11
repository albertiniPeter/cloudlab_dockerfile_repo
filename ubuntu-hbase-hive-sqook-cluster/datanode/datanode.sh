#!/bin/bash
touch /home/log/hadoop-hbase-datanode.log

##&& hdfs namenode -format 
sudo tailf /home/log/hadoop-hbase-datanode.log 