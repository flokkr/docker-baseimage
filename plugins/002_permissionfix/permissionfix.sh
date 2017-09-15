#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -n "$PERMISSION_FIX" ]; then
   sudo chown $(id -u):$(id -g) -R /data
fi

call-next-plugin "$@"
