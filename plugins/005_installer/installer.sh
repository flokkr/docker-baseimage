#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for INSTALLER in $(env | grep INSTALLER_); do
		  KEY=$(echo $INSTALLER | awk -F '=' '{print $1}')
		  COMPONENT=$(echo $KEY | awk -F '_' '{print tolower($2)}')
		  URL=$(echo $INSTALLER | awk -F '=' '{print $2}')
		  rm -rf /opt/$COMPONENT
		  rm -rf /opt/unpack
		  mkdir -p /opt/unpack
		  mkdir -p /opt/download
		  DESTFILE=/opt/download/$COMPONENT.tar.gz
		  if [ ! -f "$DESTFILE" ]; then
		     wget $URL -O $DESTFILE
	          fi
		  tar xzf $DESTFILE -C /opt/unpack
                  mv /opt/unpack/* /opt/$COMPONENT
                  rm -rf /opt/unpack
done


call-next-plugin "$@"
