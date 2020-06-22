FROM registry.apps.dev.openshift.ised-isde.canada.ca/ised-ci/php-s2i-71-graphviz

USER root


RUN yum update -y && \
    yum clean all && \
    yum install -y \
        php-soap \
        php-mysqli \
        php-gd && \
    yum clean all


COPY / /opt/app-root/src

RUN composer.phar install --no-interaction --no-ansi --optimize-autoloader

USER 1001

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
