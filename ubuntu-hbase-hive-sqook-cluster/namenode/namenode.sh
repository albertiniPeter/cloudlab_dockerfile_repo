#!/bin/bash

# hive对mysql初始化元数据
USER hadoop
WORKDIR /usr/local/hive/bin
RUN ./schematool -dbType mysql -initSchema