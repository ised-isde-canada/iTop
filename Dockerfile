FROM centos/php-71-centos7


RUN yum update -y && \
    yum clean all && \
    yum install -y \
        php-soap \
        php-mysqli \
        php-gd \