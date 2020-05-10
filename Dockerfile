FROM openjdk:14-jdk-slim

MAINTAINER Ravi Sharma

ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
ARG DOCKER_VERSION=19.03.8
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

ENV MAVEN_VERSION ${MAVEN_VERSION} 

RUN apt-get update -y || true && \
    apt-get install curl -y &&\
    apt-get install git -y


RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
#COPY settings-docker.xml /usr/share/maven/ref/


RUN echo $JAVA_HOME
RUN curl  https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz -O docker-${DOCKER_VERSION}.tgz; tar -xvf docker-${DOCKER_VERSION}.tgz; cp docker/* /usr/local/bin/.; rm -fR docker
RUN mkdir -p /opt/health;mkdir -p /opt/ci
ADD healthcheck.sh /opt/health/healthcheck.sh
ADD settings.xml /opt/ci/settings.xml
RUN chmod 755 /opt/health/healthcheck.sh
ENV MVN_SETTINGS_XML "/opt/ci/settings.xml"
ENV HEALTH_CHECK_SCRIPT "/opt/health/healthcheck.sh"


ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]

