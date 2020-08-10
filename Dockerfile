FROM registry.access.redhat.com/ubi8/php-73

USER root

ENV COMPOSER_FILE=composer-installer

RUN curl -s -o $COMPOSER_FILE https://getcomposer.org/installer && \
    php <$COMPOSER_FILE

RUN yum update -y && \
    yum install -y \
        php-soap \
        php-mysqli \
        php-gd \
	php-pecl-zip && \
    yum clean all

#RUN yum repolist

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

COPY extensions/ModifyStatusField/datamodel.applicationsolution-add-attribute.xml extensions/ModifyStatusField
COPY extensions/ModifyStatusField/en.dict.applicationsolution-add-attribute.php extensions/ModifyStatusField
COPY extensions/ModifyStatusField/model.applicationsolution-add-attribute.php extensions/ModifyStatusField
COPY extensions/ModifyStatusField/module.applicationsolution-add-attribute.php extensions/ModifyStatusField

COPY extensions/AddPortfolioField/datamodel.applicationsolution-add-portfolio-field.xml extensions/AddPortfolioField
COPY extensions/AddPortfolioField/en.dict.applicationsolution-add-portfolio-field.php extensions/AddPortfolioField
COPY extensions/AddPortfolioField/model.applicationsolution-add-portfolio-field.php extensions/AddPortfolioField
COPY extensions/AddPortfolioField/module.applicationsolution-add-portfolio-field.php extensions/AddPortfolioField

COPY extensions/AddPresentAPMField/datamodel.applicationsolution-add-present-apm-field.xml extensions/AddPresentAPMField
COPY extensions/AddPresentAPMField/en.dict.applicationsolution-add-present-apm-field.php extensions/AddPresentAPMField
COPY extensions/AddPresentAPMField/model.applicationsolution-add-present-apm-field.php extensions/AddPresentAPMField
COPY extensions/AddPresentAPMField/module.applicationsolution-add-present-apm-field.php extensions/AddPresentAPMField

COPY extensions/AddJIRAIDField/datamodel.applicationsolution-add-jira-depID.xml extensions/AddJIRAIDField
COPY extensions/AddJIRAIDField/en.dict.applicationsolution-add-jira-depID.php extensions/AddJIRAIDField
COPY extensions/AddJIRAIDField/model.applicationsolution-add-jira-depID.php extensions/AddJIRAIDField
COPY extensions/AddJIRAIDField/module.applicationsolution-add-jira-depID.php extensions/AddJIRAIDField

#end of ISED customizations
#29 dependency
RUN yum update -y \
	&& wget http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/l/lasi-1.1.3-4.fc33.i686.rpm \
	&& yum install -y lasi-1.1.3-4.fc33.i686.rpm \
	&& yum clean all
	
RUN yum update -y \
	&& wget http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/l/libXaw-1.0.13-15.fc33.i686.rpm \
	&& yum install -y libXaw-1.0.13-15.fc33.i686.rpm \
	&& yum clean all
	
RUN yum update -y \
	&& wget http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/g/glibc-common-2.32-1.fc33.x86_64.rpm \
	#&& yum install -y glibc-common-2.32-1.fc33.x86_64.rpm \
	&& rpm -i --nodeps glibc-common-2.32-1.fc33.x86_64.rpm \
	&& yum clean all
	
RUN yum update -y \
	&& wget http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/g/glibc-all-langpacks-2.32-1.fc33.x86_64.rpm \
	&& yum install -y glibc-all-langpacks-2.32-1.fc33.x86_64.rpm \
	&& yum clean all

RUN yum update -y \
	&& wget http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/g/glibc-2.32-1.fc33.i686.rpm \
	&& yum install -y glibc-2.32-1.fc33.i686.rpm \
	&& yum clean all

RUN yum update -y \
	&& wget http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/x/xorg-x11-fonts-ISO8859-1-100dpi-7.5-25.fc33.noarch.rpm \
	&& yum install -y xorg-x11-fonts-ISO8859-1-100dpi-7.5-25.fc33.noarch.rpm \
	&& yum clean all

RUN yum update -y \
	&& wget http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/g/gts-0.7.6-38.20121130.fc33.i686.rpm \
	&& yum install -y gts-0.7.6-38.20121130.fc33.i686.rpm \
	&& yum clean all

#Graphviz Installation
RUN yum update -y \
	&& wget http://rpmfind.net/linux/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/g/graphviz-2.44.0-12.fc33.i686.rpm \
	&& yum install -y graphviz-2.44.0-12.fc33.i686.rpm \
	&& yum clean all
	
RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

USER 1001

ENTRYPOINT ["bin/run"]
