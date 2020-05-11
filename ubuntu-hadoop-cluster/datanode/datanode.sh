#!/bin/bash
touch /home/hadoop/datanode.log

##&& hdfs namenode -format 
sudo tailf /home/hadoop/datanode.log 