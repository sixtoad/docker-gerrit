# gerrit
#
# VERSION 2.9.1            

FROM  phusion/baseimage

MAINTAINER Dale Larson <dlarson42@gmail.com>

ENV GERRIT_HOME /home/gerrit
ENV GERRIT_USER gerrit
ENV GERRIT_WAR /home/gerrit/gerrit.war

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main universe" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-security main universe" >> /etc/apt/sources.list

# comment out the following line if you don't have a local deb proxy
#RUN IPADDR=$( ip route | grep default | awk '{print $3}' ) ; echo "Acquire::http { Proxy \"http://$IPADDR:3142\"; };" | tee -a /etc/apt/apt.conf.d/01proxy

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

RUN useradd -m ${GERRIT_USER}

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       openjdk-7-jre-headless sudo git-core supervisor vim-tiny \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/log/supervisor

ADD http://gerrit-releases.storage.googleapis.com/gerrit-2.9.1.war /tmp/gerrit.war
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p $GERRIT_HOME/gerrit
RUN mv /tmp/gerrit.war $GERRIT_WAR
RUN chown -R ${GERRIT_USER}:${GERRIT_USER} $GERRIT_HOME

USER gerrit
RUN java -jar $GERRIT_WAR init --batch -d $GERRIT_HOME/gerrit

# Replace the gerrit config and set the URL to 0.0.0.0:8080
ADD gerrit.config $GERRIT_HOME/gerrit/etc/gerrit.config

USER root
EXPOSE 8080 29418
CMD ["/usr/sbin/service","supervisor","start"]

