FROM frolvlad/alpine-oraclejdk8:cleaned
VOLUME /data
RUN addgroup flokkr
RUN apk add --update bash ca-certificates openssl jq curl sudo git && rm -rf /var/cache/apk/* && update-ca-certificates && echo "%flokkr ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/flokkr
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 && chmod +x /usr/local/bin/dumb-init
ENV CONF_DIR=/opt JAVA_HOME=/usr/lib/jvm/java-8-oracle

WORKDIR /opt
ENV PERMISSION_FIX=true
ADD .bashrc /root/
RUN git clone https://github.com/flokkr/launcher.git
RUN find -name onbuild.sh | xargs -n1 bash -c

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/opt/launcher/launcher.sh"]
