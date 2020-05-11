FROM ubuntu16.04-base AS ubuntu-hadoop

# update apt-get
RUN apt-get update \
    && rm -rf /var/lib/apt/lists/*

# jdk environment
ENV JAVA_HOME /usr/lib/jvm/jdk1.8.0_121
ENV PATH $JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH

# hadoop 
ENV HADOOP_VERSION 2.7.3
ENV HADOOP_HOME /usr/local/hadoop
ENV PATH $HADOOP_HOME/bin:$PATH
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop 
ENV YARN_HOME /usr/local/hadoop 
ENV YARN_CONF_DIR ${YARN_HOME}/etc/hadoop 

# software install path
ENV JDK_INSTALL_PATH /usr/lib/jvm
ENV USR_LOCAL_PATH /usr/local

# step1 add hadoop user
RUN useradd -m hadoop -s /bin/bash
RUN echo 'hadoop:hadoop' | chpasswd
RUN adduser hadoop sudo

# step2 hostname,hosts modify
# 请参考外部文件手动修改
# RUN echo $(grep $(HOSTNAME) /etc/hostname | cut -f1) $(HOSTNAME) >> /etc/hostname

# step3 ssh 
# 请参考外部文件手动修改

# step4 jdk install
# (1) make java install path
RUN sudo mkdir -p "${JDK_INSTALL_PATH}"
RUN sudo chown -R hadoop:hadoop "${JDK_INSTALL_PATH}"

# (2) uncompress jdk
ADD ./src/software/jdk-8u121-linux-x64.tar.gz ${JDK_INSTALL_PATH}

# step5 uncompress hadoop
ADD ./src/software/hadoop-2.7.3.tar.gz ${USR_LOCAL_PATH}
RUN sudo mv ${USR_LOCAL_PATH}/hadoop-2.7.3 ${USR_LOCAL_PATH}/hadoop

# copy configuration
ADD ./conf/* ${HADOOP_HOME}/etc/hadoop/

RUN sudo chown -R hadoop:hadoop ${HADOOP_HOME}
RUN sudo chown -R hadoop:hadoop ${HADOOP_HOME}/etc/hadoop/

# NameNode format
# WORKDIR ${HADOOP_HOME}
# RUN ./bin/hdfs namenode -format

# environment setting for hadoop user
RUN echo "export PATH=$PATH">>/home/hadoop/.bashrc

USER root
WORKDIR /root