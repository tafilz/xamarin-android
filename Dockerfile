FROM debian:stable AS platform
ARG MAINTAINER
ARG TZ
ARG SDK_CMD_TOOLS
ARG XAMARIN_OSS_BUILD_ID
LABEL maintainer=${MAINTAINER}
ENV TZ=${TZ}

RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    tzdata && \
    rm -rf /var/lib/apt/lists/*

# .NET
RUN curl -k "https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb" -o dotnet.deb && \
    dpkg -i dotnet.deb

# MONO
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get update && apt-get install -y \
    mono-complete \
    dotnet-sdk-6.0 \
    nuget && \
    rm -rf /var/lib/apt/lists/*

# JAVA
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# Xamarin Android OSS Linux
RUN apt-get update && apt-get install -y \
    unzip \
    jq \
    bzip2 \
    libzip4 \
    libzip-dev && \
    rm -rf /var/lib/apt/lists/* && \
    curl -k "https://dev.azure.com/xamarin/public/_apis/build/builds/${XAMARIN_OSS_BUILD_ID}/artifacts?artifactName=installers-unsigned%20-%20Linux&api-version=5.1" | curl -L $(jq -r '.resource.downloadUrl') -o xamarin-linux.zip && \
    unzip -q xamarin-linux.zip -d /tmp/xamarin-linux && \
    rm xamarin-linux.zip && \
    cd "/tmp/xamarin-linux/installers-unsigned - Linux/" && \
    apt-get install ./xamarin.android-oss_*_amd64.deb && \
    rm -rf /tmp/xamarin-linux

# Android SDK
RUN mkdir -p /usr/lib/android-sdk/cmdline-tools/latest && \
    curl -k "https://dl.google.com/android/repository/commandlinetools-linux-${SDK_CMD_TOOLS}_latest.zip" -o commandlinetools-linux.zip && \
    unzip -q commandlinetools-linux.zip -d /usr/lib/android-sdk/tmp && \
    mv  /usr/lib/android-sdk/tmp/cmdline-tools/* /usr/lib/android-sdk/cmdline-tools/latest && \
    rm -rf /usr/lib/android-sdk/tmp/ && \
    rm commandlinetools-linux.zip 

ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools"

### NDK only target ###
FROM platform AS ndk
RUN sdkmanager "ndk-bundle"

FROM platform AS without_ndk
ARG BUILD_TOOLS_VERSION
ARG API_LEVEL
RUN sdkmanager "build-tools;${BUILD_TOOLS_VERSION}" "platforms;android-${API_LEVEL}"

FROM ndk AS with_ndk
ARG BUILD_TOOLS_VERSION
ARG API_LEVEL
RUN sdkmanager "build-tools;${BUILD_TOOLS_VERSION}" "platforms;android-${API_LEVEL}"
