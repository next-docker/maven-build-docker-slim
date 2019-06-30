FROM  maven:3-jdk-8-slim

MAINTAINER Ravi Sharma

#Install Maven

ENV MAVEN_VERSION 3.6.1

RUN echo $JAVA_HOME
RUN apt-get update -y
RUN curl  https://download.docker.com/linux/static/stable/x86_64/docker-18.09.2.tgz -O docker-18.09.2.tgz; tar -xvf docker-18.09.2.tgz; cp docker/* /usr/local/bin/.; rm -fR docker
