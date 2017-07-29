#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
wget https://github.com/elek/consul-launcher/releases/download/1.2/linux_amd64_consul-launcher -O $DIR/consul-launcher
chmod +x $DIR/consul-launcher
