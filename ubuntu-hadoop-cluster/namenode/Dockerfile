FROM ubuntu-hadoop-base

USER root

# root user password modify
RUN echo 'root:root' | chpasswd

# NameNode format
# WORKDIR ${HADOOP_HOME}
# RUN sudo ./bin/hdfs namenode -format -Y

ADD ./namenode.sh /namenode.sh
RUN sudo chmod a+x /namenode.sh

CMD ["/namenode.sh"]

WORKDIR /root