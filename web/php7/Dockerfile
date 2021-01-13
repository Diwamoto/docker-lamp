FROM diwamoto0118/php7.3-apache-alpine:latest

    # apache 基本設定
RUN apk update && apk upgrade && apk add \
	vim git tar curl less openssl tzdata apache2-ssl\
    php7-json php7-gd php7-pecl-xdebug php7-mysqli php7-opcache\
    && cp /usr/bin/php7 /usr/bin/php \
    # timezoneの設定
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apk del tzdata \
    # xdebugの設定
    && echo "zend_extension=/usr/lib/php7/modules/xdebug.so" > /etc/php7/conf.d/xdebug.ini \
    && echo "xdebug.mode = debug,develop" >> /etc/php7/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request = no" >> /etc/php7/conf.d/xdebug.ini \
    && echo "xdebug.client_port = 9003" >> /etc/php7/conf.d/xdebug.ini \
    && echo "xdebug.client_host = 10.0.2.2" >> /etc/php7/conf.d/xdebug.ini \
    && echo "xdebug.log" >> /etc/php7/conf.d/xdebug.ini \
    # mailhogの設定
    && curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
    && chmod +x mhsendmail_linux_amd64 \
    && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail \
    # Composerのinstall
    && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer \
    && rm -rf /tmp/* /var/cache/apk/*

    # 必要ファイルのコピー
COPY ./web/php7/httpd.conf /etc/apache2/
COPY ./web/vhost.conf /etc/apache2/conf.d/
COPY ./web/php7/php.ini /etc/php7/