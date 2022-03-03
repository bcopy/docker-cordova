FROM node:14

LABEL Author Brice Copy

RUN apt-get update && apt install -y software-properties-common

# Install Java jdk8
RUN apt-get update && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get -y update && \
    apt-get -y install openjdk-8-jdk ca-certificates-java lib32stdc++6 lib32z1 curl unzip gradle usbutils && \
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
    /usr/local/android-sdk-linux/tools/bin/sdkmanager platform-tools build-tools;30.0.3 platforms;android-30 &&\
    find /usr/local/android-sdk-linux -perm 0744 | xargs chmod 755

ENV GRADLE_USER_HOME /src/gradle
VOLUME /src
WORKDIR /src
