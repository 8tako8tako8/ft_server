FROM debian:buster

ENV AUTOINDEX on

# Install nginx, mariaDB, php, and utils
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
        nginx \
        openssl \
        mariadb-server \
        mariadb-client \
        php-cgi \
        php-common \
        php-fpm \
        php-pear \
        php-mbstring \
        php-zip \
        php-net-socket \
        php-gd \
        php-xml-util \
        php-gettext \
        php-mysql \
        php-bcmath \
        unzip \
        wget \
        git \
        vim

# Install openssl and Entrykit
RUN openssl req -x509 -nodes -days 365 -subj "/C=JP/ST=JAPAN/L=Tokyo/O=42tokyo/OU=Student/CN=localhost" \
    -newkey rsa:2048 -keyout /etc/ssl/server.key -out /etc/ssl/server.crt \
    && wget https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz \
    && tar -xvzf entrykit_0.4.0_Linux_x86_64.tgz \
    && rm entrykit_0.4.0_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

# Install phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz \
    && tar -xvzf phpMyAdmin-5.0.4-all-languages.tar.gz \
    && rm phpMyAdmin-5.0.4-all-languages.tar.gz \
    && mv phpMyAdmin-5.0.4-all-languages phpmyadmin \
    && mv phpmyadmin/ /var/www/html/ \
    && cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php \
    && chmod 660 /var/www/html/phpmyadmin/config.inc.php \
    && chown -R www-data:www-data /var/www/html/phpmyadmin

# copy wordpress
COPY ./srcs/wordpress/srcs /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress

COPY ./srcs/nginx/default.tmpl /etc/nginx/sites-available/
COPY ./srcs/entrypoint.sh /tmp/
RUN chmod 744 /tmp/entrypoint.sh

ENTRYPOINT ["render", "/etc/nginx/sites-available/default", "--", "bash", "entrypoint.sh"]