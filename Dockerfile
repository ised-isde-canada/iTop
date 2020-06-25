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

COPY / /opt/app-root/src

WORKDIR /opt/app-root/src

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

#do not run composer as root, according to the documentation
USER 1001
RUN ./composer.phar install --no-interaction --no-ansi --optimize-autoloader && \
    rm ./composer.phar
USER root

#ISED customizations go here

#Download toolkit.zip file
RUN curl -L -o toolkit.zip http://www.combodo.com/documentation/iTopDataModelToolkit-2.7.zip \
	#Unzip toolkit.zip file
	&& unzip toolkit.zip \
	#Remove toolkit.zip file
	&& rm toolkit.zip
	
#Transfer required extension files from the github repository into the iTop image
RUN mkdir /extensions

ADD https://github.com/ised-isde-canada/iTop/blob/develop/extensions/datamodel.applicationsolution-add-attribute.xml extensions/ && \
	https://github.com/ised-isde-canada/iTop/blob/develop/extensions/en.dict.applicationsolution-add-attribute.php extensions/ && \
	https://github.com/ised-isde-canada/iTop/blob/develop/extensions/model.applicationsolution-add-attribute.php extensions/ && \
	https://github.com/ised-isde-canada/iTop/blob/develop/extensions/module.applicationsolution-add-attribute.php extensions/

#end of ISED customizations

RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

USER 1001

ENTRYPOINT ["bin/run"]
