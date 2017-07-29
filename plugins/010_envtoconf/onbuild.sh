#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
wget https://github.com/elek/envtoconf/releases/download/1.1.1/linux_amd64_envtoconf -O $DIR/envtoconf
chmod +x $DIR/envtoconf
