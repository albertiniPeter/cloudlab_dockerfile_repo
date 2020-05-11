FROM ubuntu-bigdata-cluster-base

# update apt-get
RUN apt-get update \
    && rm -rf /var/lib/apt/lists/*

# switch root user
USER root

# root user password modify
RUN echo 'root:root' | chpasswd

# ADD ./namenode.sh /namenode.sh
# RUN sudo chmod a+x /namenode.sh

# CMD ["/namenode.sh"]

WORKDIR /root