#!/bin/bash
touch /home/hadoop/namenode.log

##&& hdfs namenode -format 
sudo tailf /home/hadoop/namenode.log 