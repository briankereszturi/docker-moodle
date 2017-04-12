FROM ubuntu:16.04
MAINTAINER Brian Kereszturi

# Install packages
RUN apt-get update && \
apt-get -y install curl supervisor apache2 libapache2-mod-php7.0 php7.0-pgsql pwgen php7.0-mcrypt php7.0-gd php7.0-curl php7.0-xmlrpc php7.0-intl php7.0-xml php7.0-zip php7.0-mbstring php7.0-soap

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
ADD ports_default /etc/apache2/ports.conf
RUN a2enmod rewrite

# Environment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

# Configure locales
RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales

RUN adduser --disabled-password --gecos moodle moodleuser

RUN mkdir /var/www/moodledata
RUN chmod 777 /var/www/moodledata

RUN rm -rf /var/www/html/*
RUN chmod 777 /var/www/html
ADD moodle /var/www/html

EXPOSE 3000
CMD ["/run.sh"]
