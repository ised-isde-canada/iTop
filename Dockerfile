FROM registry.apps.dev.openshift.ised-isde.canada.ca/ised-ci/sclorg-s2i-php:7.3

USER root

ENV COMPOSER_FILE=composer-installer

RUN curl -s -o $COMPOSER_FILE https://getcomposer.org/installer && \
    php <$COMPOSER_FILE

RUN yum update -y && \
    yum install -y \
        php-soap \
        php-mysqli \
        php-gd && \
    yum clean all

    
RUN ./composer.phar install --no-interaction --no-ansi --optimize-autoloader

COPY / /opt/app-root/src


RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src


USER 1001

ENTRYPOINT ["bin/run"]
