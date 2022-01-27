FROM node:9

MAINTAINER Olivier Bourdoux

RUN apt-get update && apt install -y software-properties-common

# Install Java.
# jdk8
# https://github.com/carlos3g/my-linux-workspace/blob/d29a68ef7c/ubuntu/workspace.sh
RUN apt-get update && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get -y update && \
    apt-get -y install oracle-java8-installer lib32stdc++6 lib32z1 curl unzip gradle usbutils && \
    rm -r /var/lib/apt/lists/*

# FROM export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

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
