FROM centos/php-71-centos7

USER root


RUN yum update -y && \
    yum clean all && \
    yum install -y \
        php-soap \
        php-mysqli \
        php-gd && \
    yum clean all

USER 1001


