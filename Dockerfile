FROM frolvlad/alpine-oraclejdk8:cleaned
RUN apk add --update bash ca-certificates openssl jq curl && rm -rf /var/cache/apk/* && update-ca-certificates
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

ENV CONF_DIR=/opt JAVA_HOME=/usr/lib/jvm/java-8-oracle

WORKDIR /opt

ADD .bashrc /root/
ADD launcher.sh ./
ADD plugins plugins
RUN find -name onbuild.sh | xargs -n1 bash -c

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/opt/launcher.sh"]
