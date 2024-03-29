FROM openjdk:8-jdk

ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV ANDROID_COMPILE_SDK_27="27"
ENV ANDROID_COMPILE_SDK_28="28"
ENV ANDROID_COMPILE_SDK_29="29"
ENV ANDROID_BUILD_TOOLS="29.0.2"
ENV ANDROID_SDK_TOOLS="4333796"
ENV NDK_VERSION="21.0.6113669"
ENV CMAKE_VERSION="3.10.2.4988404"

# Init apt-get
RUN apt-get --quiet update --yes && \
    apt-get --quiet install --yes wget \
    tar \
    unzip \
    lib32stdc++6 \
    lib32z1 \
    ruby \
    ruby-dev
RUN yes | apt-get install ubuntu-dev-tools

# Install Android SDK
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-$ANDROID_SDK_TOOLS.zip
RUN unzip -d android-sdk-linux android-sdk.zip
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK_27" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK_28" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-$ANDROID_COMPILE_SDK_29" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "extras;google;google_play_services" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "build-tools;$ANDROID_BUILD_TOOLS" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "ndk;$NDK_VERSION" >/dev/null
RUN echo y | android-sdk-linux/tools/bin/sdkmanager "cmake;$CMAKE_VERSION" >/dev/null
RUN yes | android-sdk-linux/tools/bin/sdkmanager --licenses
ENV ANDROID_HOME=$PWD/android-sdk-linux
ENV PATH=$PATH:$PWD/android-sdk-linux/platform-tools/
RUN rm android-sdk.zip

# Install bundler for fastlane
RUN gem install bundler

# Google cloud sdk
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh --quiet
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin