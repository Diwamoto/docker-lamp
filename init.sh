# docker-machineのインストール
curl -L https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
chmod +x /usr/local/bin/docker-machine

# docker-machineの作成
docker-machine create —driver virtualbox default
docker-machine env default
eval $(docker-machine env default)

# 必要ポートの開放
vboxmanage controlvm default natpf1 "web,tcp,,80,,80"
vboxmanage controlvm default natpf1 "mysql,tcp,,3306,,80"
vboxmanage controlvm default natpf1 "phpmyadmin,tcp,,8080,,8080"
vboxmanage controlvm default natpf1 "mailhog,tcp,,80,,80"
vboxmanage controlvm default natpf1 "xdebug,tcp,,9003,,9003"

# ローカルホストのhttps化
cd ./web/ssl/
./initssl.sh

# 設定ファイルの準備
cd ../php7
cp httpd.conf.default httpd.conf
cp php.ini.default php.ini

# dnsmasqの準備
brew install dnsmasq
sudo touch /etc/resolver/localhost
sudo echo 'nameserver 127.0.0.1' > /etc/resolver/localhost
sudo echo 'address=/localhost/127.0.0.1' >> /usr/local/etc/dnsmasq.conf
brew services restart dnsmasq

# dockerコンテナの起動
cd ../..
docker-compose up -d