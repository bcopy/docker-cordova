FROM node:9

MAINTAINER Olivier Bourdoux

RUN apt-get update && apt install -y software-properties-common

# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y "deb http://ppa.launchpad.net/cwchien/gradle/ubuntu xenial main" && \
  add-apt-repository -y "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" && \
  apt-get update && \
  apt-get install -y oracle-java8-installer lib32stdc++6 lib32z1 curl unzip gradle && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# install cordova
RUN npm i -g cordova

# download and extract android sdk
RUN curl https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip > android.zip && unzip android.zip -d /usr/local/android-sdk-linux
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg

# accept licenses
RUN yes | /usr/local/android-sdk-linux/tools/bin/sdkmanager --licenses

# update SDKs
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) |\
    /usr/local/android-sdk-linux/tools/android update sdk --no-ui -a --filter platform-tool,build-tools-26.0.2,android-26,build-tools-27.0.3,android-27 &&\
    find /usr/local/android-sdk-linux -perm 0744 | xargs chmod 755

ENV GRADLE_USER_HOME /src/gradle
VOLUME /src
WORKDIR /src
