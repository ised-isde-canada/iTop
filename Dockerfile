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

COPY extensions/AddEmailEnabledField/datamodel.applicationsolution-add-email-enabled-field.xml extensions/AddEmailEnabledField
COPY extensions/AddEmailEnabledField/en.dict.applicationsolution-add-email-enabled-field.php extensions/AddEmailEnabledField
COPY extensions/AddEmailEnabledField/model.applicationsolution-add-email-enabled-field.php extensions/AddEmailEnabledField
COPY extensions/AddEmailEnabledField/module.applicationsolution-add-email-enabled-field.php extensions/AddEmailEnabledField

COPY extensions/AddEmailProtocolField/datamodel.applicationsolution-add-email-protocol-field.xml extensions/AddEmailProtocolField
COPY extensions/AddEmailProtocolField/en.dict.applicationsolution-add-email-protocol-field.php extensions/AddEmailProtocolField
COPY extensions/AddEmailProtocolField/model.applicationsolution-add-email-protocol-field.php extensions/AddEmailProtocolField
COPY extensions/AddEmailProtocolField/module.applicationsolution-add-email-protocol-field.php extensions/AddEmailProtocolField

#end of ISED customizations
	
RUN chgrp -R 0 /opt/app-root/src && \
    chmod -R g=u+wx /opt/app-root/src

USER 1001

ENTRYPOINT ["bin/run"]
