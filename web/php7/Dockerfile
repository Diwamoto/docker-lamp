FROM diwamoto0118/php7.3-apache-alpine:latest

RUN apk update && apk upgrade && apk --no-cache add tzdata vim git bash \
    # timezoneの設定
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apk del tzdata \
    # xdebugの設定
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20180731/opcache.so" >> /usr/local/lib/php.ini \
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20180731/xdebug.so" >> /usr/local/lib/php.ini \
    && echo "xdebug.mode = debug,develop" >> /usr/local/lib/php.ini \
    && echo "xdebug.start_with_request = no" >> /usr/local/lib/php.ini \
    && echo "xdebug.client_port = 9003" >> /usr/local/lib/php.ini \
    && echo "xdebug.client_host = 10.0.2.2" >> /usr/local/lib/php.ini \
    && mkdir /run/apache2 \
    && chmod 777 /run/apache2 \
    # mailhogの設定
    && curl -sSLO https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
    && chmod +x mhsendmail_linux_amd64 \
    && mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail \
    # Composerのinstall
    && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer \
    # 無駄ファイルを削除
    && rm -rf /tmp/* /var/cache/apk/*

    # 必要ファイルのコピー
COPY ./web/php7/httpd.conf /etc/apache2/
COPY ./web/vhost.conf /etc/apache2/conf.d/
COPY ./web/php7/php.ini /etc/php7/