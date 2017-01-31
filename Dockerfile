FROM frolvlad/alpine-oraclejdk8:cleaned 
RUN apk add --update bash ca-certificates openssl jq curl python && rm -rf /var/cache/apk/* && update-ca-certificates
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init
WORKDIR /opt
RUN mkdir configuration
RUN mkdir defaults
ADD .bashrc /root/
ADD launcher.sh ./
ADD configuration/* configuration/
ENV CONF_DIR=/opt
ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/opt/launcher.sh"]
