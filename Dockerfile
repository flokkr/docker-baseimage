FROM frolvlad/alpine-oraclejdk8:cleaned 
RUN apk add --update bash ca-certificates openssl jq curl python py-pip && rm -rf /var/cache/apk/* && update-ca-certificates
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init
WORKDIR /opt
RUN mkdir configuration
RUN mkdir defaults
ADD .bashrc /root/
ADD launcher.sh ./
ADD configuration/* configuration/
ADD configurer configurer
ADD setup.py /opt/
RUN pip install -e /opt
ENV CONF_DIR=/opt
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ADD https://github.com/elek/consul-launcher/releases/download/1.0/linux_amd64_consul-launcher /opt/configurer/consul-launcher
RUN chmod +x /opt/configurer/consul-launcher
ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/opt/launcher.sh"]
