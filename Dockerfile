FROM frolvlad/alpine-oraclejdk8:cleaned
RUN apk add --update bash ca-certificates openssl jq curl && rm -rf /var/cache/apk/* && update-ca-certificates
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

ENV CONF_DIR=/opt
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle

WORKDIR /opt

ADD .bashrc /root/
ADD launcher.sh ./
ADD configurer configurer

ADD https://github.com/elek/consul-launcher/releases/download/1.2/linux_amd64_consul-launcher /opt/configurer/consul-launcher
ADD https://github.com/elek/envtoconf/releases/download/1.1.1/linux_amd64_envtoconf /opt/configurer/envtoconf
RUN chmod +x /opt/configurer/*

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/opt/launcher.sh"]
