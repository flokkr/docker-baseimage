FROM alpine
ARG LAUNCHER_HASH=master
VOLUME /data
RUN addgroup flokkr
RUN apk add --update bash python3 dumb-init procps ca-certificates openssl jq curl sudo git openjdk8 && rm -rf /var/cache/apk/* && update-ca-certificates && echo "%flokkr ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/flokkr && ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install robotframework
ENV CONF_DIR=/opt JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/

WORKDIR /opt
ENV PERMISSION_FIX=true
ADD .bashrc /root/
RUN git clone https://github.com/flokkr/launcher.git && git --work-tree=/opt/launcher --git-dir=/opt/launcher/.git checkout ${LAUNCHER_HASH}
RUN find -name onbuild.sh | xargs -n1 bash -c
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/opt/launcher/launcher.sh"]
