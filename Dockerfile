FROM centos:8
ARG LAUNCHER_HASH=master
VOLUME /data
RUN groupadd flokkr
RUN yum install epel-release -y && \
   yum -y update && yum install -y jq git java-1.8.0-openjdk-devel python3-pip wget sudo nc which && \
   alternatives --set python /usr/bin/python3 && \
   yum clean all
RUN pip3 install robotframework robotframework-requests
RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && chmod +x /usr/bin/dumb-init
RUN echo "%flokkr ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/flokkr
ENV CONF_DIR=/opt JAVA_HOME=/usr/lib/jvm/java-openjdk/

WORKDIR /opt
ENV PERMISSION_FIX=true
ADD .bashrc /root/
RUN git clone https://github.com/flokkr/launcher.git && git --work-tree=/opt/launcher --git-dir=/opt/launcher/.git checkout ${LAUNCHER_HASH}
RUN find -name onbuild.sh | xargs -n1 bash -c
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/opt/launcher/launcher.sh"]
