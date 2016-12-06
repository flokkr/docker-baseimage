FROM frolvlad/alpine-oraclejdk8:cleaned 
RUN apk add --update bash ca-certificates openssl jq && rm -rf /var/cache/apk/* && update-ca-certificates
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init
WORKDIR /opt
RUN wget https://releases.hashicorp.com/consul-template/0.16.0/consul-template_0.16.0_linux_amd64.zip -O consul-template.zip && unzip consul-template.zip && rm consul-template.zip && mv consul-template /usr/bin
RUN mkdir configuration
RUN mkdir defaults
ADD launcher.sh ./
ADD configuration/* configuration/
ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/opt/launcher.sh"]
