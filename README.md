# docker-lamp

docker でphp+apache+db(mysql or postgres)+mailhog+phpmyadminな環境を作りました。
docker-machine上で動かすので

## 起動方法

起動にはvirtualboxが必要になりますのでインストールをお願いいたします。
初回起動時には`init.sh`を実行すればdocker-machine含めて全て必要な設定を行ってくれます。
次回以降は`docker-compose up -d`と入力すれば起動できます。
ローカル環境のssl化も済んでいるので、プロジェクトフォルダにphpのプロジェクトを配置して、
`https://{プロジェクト名}.localhost`で接続できます。最強！！


## ssl化手順

(以下の手順は全てinitssl.shを実行することで一発でできます。)

まず、ローカルにmkcertをinstallします。

```
brew install mkcert
mkcert -install
```

その後、ssl/hostnamesにssl化したいドメインを打ち込みます。改行可です。
そしたら
`mkcert -cert-file ./keys/server.crt -key-file ./keys/server.key $(cat ./hostnames)`
で必要なファイルができるのでもう一度docker-compose buildをお願いします。
virtualhostの設定はssl.confにvhost.confの中身をコピーしてポートを443に変えてやればオーケーです。
