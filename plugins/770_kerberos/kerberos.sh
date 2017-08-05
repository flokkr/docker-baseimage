#/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

KERBEROS_SERVER=${KERBEROS_SERVER:-krb5}
ISSUER_SERVER=${ISSUER_SERVER:-$KERBEROS_SERVER\:8081}
export HOST_NAME=`hostname`
for NAME in ${KERBEROS_KEYTABS}; do
   echo "Download $NAME/$HOSTNAME@... keytab file"
   wget http://$ISSUER_SERVER/keytab/$HOST_NAME/$NAME -O $CONF_DIR/$NAME.keytab
   KERBEROS_ENABLED=true
done

for NAME in ${KERBEROS_KEYSTORES}; do
   echo "Download keystore files for $NAME"
   wget http://$ISSUER_SERVER/keystore/$NAME -O $CONF_DIR/$NAME.keystore
   KERBEROS_ENABLED=true
   KEYSTORE_DOWNLOADED=true
done

if [ -n "$KEYSTORE_DOWNLOADED" ]; then
  wget http://$ISSUER_SERVER/keystore/$HOST_NAME -O $CONF_DIR/$HOST_NAME.keystore
  wget http://$ISSUER_SERVER/truststore -O $CONF_DIR/truststore
fi

if [ -n "$KERBEROS_ENABLED" ]; then
   cp $DIR/krb5.conf /etc/krb5.conf
fi

call-next-plugin "$@"
