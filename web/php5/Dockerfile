FROM php:5.6.28-apache

    #初期設定
RUN apt-get update \
    && apt-get -y install vim wget unzip lsb-release libicu-dev mysql-client ssmtp mailutils openssl ssl-cert \
    && docker-php-ext-install pdo_mysql mysqli intl

    # 必要なファイルのコピー
COPY ./web/ssl/ /etc/apache2/ssl/
COPY ./web/ssl/ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ./web/vhost.conf /etc/apache2/sites-available/vhost.conf
COPY ./web/php5/php.ini /usr/local/etc/php/

    # ssl設定
RUN a2enmod ssl \
    && a2ensite default-ssl \
    && a2enmod rewrite \
    # mailhog 設定
    && curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
    && chmod +x mhsendmail_linux_amd64 \
    && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail \
    && echo 'sendmail_path = "/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025"' > /usr/local/etc/php/conf.d/sendmail.ini \
    && ln -s /etc/apache2/mods-available/vhost_alias.load /etc/apache2/mods-enabled \
    && echo ServerName $HOSTNAME > /etc/apache2/conf-available/fqdn.conf && a2enconf fqdn \
    && a2enmod headers \
    && a2enmod include \
    # xdebug の有効化
    && pecl install xdebug-2.5.5 \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.default_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart = 1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port = 9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host = host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
    # GD関連のインストール
    && apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    # Composerのinstall
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer \
    # vhostの有効化
    && a2ensite vhost.conf