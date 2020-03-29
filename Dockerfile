FROM  maven:3.6.3-jdk-11-openj9
#FROM  maven:3-jdk-8-slim

MAINTAINER Ravi Sharma

#Install Maven

ENV MAVEN_VERSION 3.6.1

RUN echo $JAVA_HOME
RUN apt-get update -y
RUN curl  https://download.docker.com/linux/static/stable/x86_64/docker-18.09.2.tgz -O docker-18.09.2.tgz; tar -xvf docker-18.09.2.tgz; cp docker/* /usr/local/bin/.; rm -fR docker
RUN mkdir -p /opt/health;mkdir -p /opt/ci
ADD healthcheck.sh /opt/health/healthcheck.sh
ADD settings.xml /opt/ci/settings.xml
RUN chmod 755 /opt/health/healthcheck.sh
ENV MVN_SETTINGS_XML "/opt/ci/settings.xml"
ENV HEALTH_CHECK_SCRIPT "/opt/health/healthcheck.sh"

