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


#do not run composer as root, according to the documentation

COPY / /opt/app-root/src
RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

USER 1001
RUN ./composer.phar install --no-interaction --no-ansi --optimize-autoloader
USER root

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src


USER 1001

ENTRYPOINT ["bin/run"]
