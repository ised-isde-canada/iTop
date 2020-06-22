FROM php-s2i-71-graphviz:latest


RUN yum update -y && \
    yum clean all && \
    yum install -y \
        php-soap \
        php-mysqli \
        php-gd \