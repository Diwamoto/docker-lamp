FROM php:7.2-apache
    # 必要ファイルのコピー
COPY ./web/ssl/ /etc/apache2/ssl/
COPY ./web/ssl/ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY ./web/vhost.conf /etc/apache2/sites-available/vhost.conf
COPY ./web/php7/php.ini /usr/local/etc/php/php.ini
    # apache 基本設定
RUN groupmod -g 1000 www-data && usermod -u 1000 www-data
RUN apt-get update \
    && apt-get install -y vim wget unzip lsb-release libicu-dev mailutils \
    libssl-dev libmcrypt-dev openssl ssl-cert default-mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo_mysql mysqli intl mbstring\
    # ssl設定
    && a2enmod ssl \
    && a2ensite default-ssl \
    && a2enmod rewrite \
    && a2enmod proxy \
    && a2enmod proxy_http \
    # mailhog 設定
    && curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
    && chmod +x mhsendmail_linux_amd64 \
    && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail \
    && echo 'sendmail_path = "/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025"' > /usr/local/etc/php/conf.d/sendmail.ini \
    # apache その他設定
    && ln -s /etc/apache2/mods-available/vhost_alias.load /etc/apache2/mods-enabled \
    && echo ServerName $HOSTNAME > /etc/apache2/conf-available/fqdn.conf \
    && a2enconf fqdn \
    && a2enmod headers \
    && a2enmod include \
    # xdebug の有効化
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.default_enable = 1" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart = 1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port = 9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
    # GD関連のインストール
    && apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    # Composerのinstall
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer \
    # バーチャルホストの有効化
    && a2ensite vhost.conf