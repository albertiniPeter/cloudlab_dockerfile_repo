FROM ubuntu-hadoop-base

USER root

# root user password modify
RUN echo 'root:root' | chpasswd

ADD ./datanode.sh /datanode.sh
RUN sudo chmod a+x /datanode.sh

CMD ["/datanode.sh"]

WORKDIR /root