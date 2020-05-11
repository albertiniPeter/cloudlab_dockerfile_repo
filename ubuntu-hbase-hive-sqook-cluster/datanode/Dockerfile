FROM ubuntu-bigdata-cluster-base

# update apt-get
RUN apt-get update \
    && rm -rf /var/lib/apt/lists/*
    
# switch root user
USER root

# root user password modify
RUN echo 'root:root' | chpasswd

# ADD ./datanode.sh /datanode.sh
# RUN sudo chmod a+x /datanode.sh

# CMD ["/datanode.sh"]

WORKDIR /root