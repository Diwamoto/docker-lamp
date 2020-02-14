# docker-lamp

docker でphp+apache+db(mysql or postgres)+mailhog+phpmyadminな環境を作りました。
もちろんdocker-sync対応なのでmac環境でも使えると思います。

## 起動方法

docker,docker-compose,docker-syncはinstall済みであると仮定します。

`docker-sync-stack start`
で起動できます。終わり。

## 自分のローカルプロジェクトフォルダをdockerと同期する方法

docker-sync.ymlにて、

```docker-sync.yml
version: '2'

options:
  max-attempt: 2

syncs:
  sync-volume:
    src: '' <-- ここの部分を自分のプロジェクトフォルダに変えましょう。
    sync_strategy: 'native_osx'
    sync_userid: '33'
    monit_interval: 1
```

これで対応するフォルダに{フォルダ名}.localhostでアクセスできます。hostsファイルの設定も要りません。vhostの設定もいらないのです。
メールは一括でlocalhost:8025に飛びます。これもいつかmailhog.localhostにしてしまおうと思います。pmaも。


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



