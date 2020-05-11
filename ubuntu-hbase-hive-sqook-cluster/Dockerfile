FROM ubuntu-hadoop-base AS ubuntu-hadoop-base

# 设置阿里云源，并设置语言、时区，安装基本工具
# RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list 

# update apt-get
RUN apt-get update \
    && rm -rf /var/lib/apt/lists/*
    
# hbase environment
ENV HBASE_HOME /usr/local/hbase
ENV PATH $PATH:$HBASE_HOME/bin
# hive environment
ENV HIVE_HOME /usr/local/hive
ENV PATH $PATH:$HIVE_HOME/bin
# sqoop environment
ENV SQOOP_HOME /usr/local/sqoop
ENV PATH $PATH:$SQOOP_HOME/bin
ENV CLASSPATH $CLASSPATH:$SQOOP_HOME/lib

# software install path
ENV USR_LOCAL_PATH /usr/local

# install software
# install hbase
ADD ./src/software/hbase-1.3.1-bin.tar.gz ${USR_LOCAL_PATH}
RUN sudo mv ${USR_LOCAL_PATH}/hbase-1.3.1 ${USR_LOCAL_PATH}/hbase
# install hive
ADD ./src/software/apache-hive-1.2.1-bin.tar.gz ${USR_LOCAL_PATH}
RUN sudo mv ${USR_LOCAL_PATH}/apache-hive-1.2.1-bin ${USR_LOCAL_PATH}/hive
# install sqoop
ADD ./src/software/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz ${USR_LOCAL_PATH}
RUN sudo mv ${USR_LOCAL_PATH}/sqoop-1.4.7.bin__hadoop-2.6.0 ${USR_LOCAL_PATH}/sqoop

# copy hbase configuration
ADD ./conf/hbase/* ${HBASE_HOME}/conf/
# copy hive configuration
ADD ./conf/hive/* ${HIVE_HOME}/conf/

# copy sqoop sqoop-env.sh
ADD ./conf/sqoop/sqoop-env.sh ${SQOOP_HOME}/conf/
# copy sqoop configure-sqoop
ADD ./conf/sqoop/configure-sqoop ${SQOOP_HOME}/bin/

# copy mysql drive
COPY [ "./src/software/mysql-connector-java-5.1.39-bin.jar", "${HIVE_HOME}/lib" ]
COPY [ "./src/software/mysql-connector-java-5.1.39-bin.jar", "${SQOOP_HOME}/lib" ]
# copy jline-2.12.jar
COPY [ "./src/software/jline-2.12.jar", "/usr/local/hadoop/share/hadoop/yarn/lib" ]

# permission hbase dir
RUN sudo chown -R hadoop:hadoop ${HBASE_HOME}
# permission hive dir
RUN sudo chown -R hadoop:hadoop ${HIVE_HOME}
# permission sqoop dir
RUN sudo chown -R hadoop:hadoop ${SQOOP_HOME}
# permission jline-2.12.jar in hadoop dir
RUN sudo chown -R hadoop:hadoop /usr/local/hadoop/share/hadoop/yarn/lib/jline-2.12.jar

# environment setting for hadoop user
RUN echo "export PATH=$PATH">>/home/hadoop/.bashrc

USER root
WORKDIR /root