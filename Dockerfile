FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y install software-properties-common

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y apache2 curl git zip rsync wget php7.3 redis-tools && a2enmod php7.3
RUN update-alternatives --set php /usr/bin/php7.3
RUN apt-get install -y php7.3-xmlrpc php7.3-gd php7.3-mbstring php7.3-bcmath php7.3-mysql php7.3-dom php7.3-curl php7.3-redis php7.3-zip

RUN wget -O composer-setup.php https://getcomposer.org/installer
RUN php composer-setup.php --install-dir=/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN a2enmod rewrite headers

EXPOSE 80

COPY build/000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN a2enmod status
RUN apt-get update
RUN apt-get install links -y

COPY ./src /var/www
COPY ./composer.json /var/www/composer.json
WORKDIR /var/www

RUN chown -R www-data:www-data /var/www

CMD /usr/sbin/apache2ctl -D FOREGROUND
