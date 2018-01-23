# From Ubuntu 16.04 image
FROM ubuntu:16.04

#Setting up Environment variables 
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

#Install apache, php7, zip, curl
RUN set -xe \
    && apt-get update \
    && apt-get install -y apache2 zip curl \
    && apt-get install -y php7.0 php7.0-* libapache2-mod-php7.0 

#Set working directory to /var/www/html
WORKDIR /var/www/html

#Clean up and chown of html directory
RUN set -xe \
    && apt-get install -y snmp \
    && apt-get clean \
    && rm /var/www/html/index.html \
    && chown -R www-data:www-data /var/www/html

# Enable apache mods.
RUN a2enmod php7.0
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

#Expose port 80
EXPOSE 80

# Run apache on docker run 
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
