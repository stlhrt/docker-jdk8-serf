FROM stlhrt/jdk8
MAINTAINER Lukasz Wozniak

# install serf
USER root
RUN apt-get update
RUN apt-get install -qy unzip supervisor
RUN mkdir -p /tmp/serf
WORKDIR /tmp/serf
ADD https://dl.bintray.com/mitchellh/serf/0.6.3_linux_amd64.zip /tmp/serf/serf.zip
RUN unzip serf.zip
RUN mv serf /usr/bin/
RUN rm -rf /tmp/serf


# configure serf
RUN mkdir -p /opt/serf/conf
RUN mkdir -p /opt/serf/logs
WORKDIR /opt/serf
ADD serf-join.sh /opt/serf/serf-join.sh
ADD supervisord-serf.conf /etc/supervisor/conf.d/supervisord-serf.conf
RUN chmod 755 /opt/serf/*.sh

#configure application launching
RUN mkdir -p /opt/app/service
RUN mkdir -p /opt/app/logs
ADD supervisord-app.conf /etc/supervisor/conf.d/supervisord-app.conf
ADD run-app.sh /opt/app/service/run-app.sh
RUN chmod 755 /opt/app/service/*.sh
ADD /run.sh /opt/run.sh
RUN chmod 755 /opt/run.sh

# Expose volume for additional serf config in JSON
VOLUME /opt/serf/conf

CMD ["/opt/run.sh"]