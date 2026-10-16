FROM gradle:8.11.1-jdk17

ENV ANDROID_CMDLINE_TOOLS_VERSION=15859902
ENV ANDROID_SDK_URL=https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip

ENV ANDROID_HOME=/usr/local/android-sdk-linux

ENV ANDROID_API_LEVEL=android-36
ENV ANDROID_VERSION=36
ENV ANDROID_BUILD_TOOLS_VERSION=36.0.0

ENV ANDROID_NDK_VERSION=27.2.12479018
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION}

ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools
ENV PATH=${PATH}:${ANDROID_NDK_HOME}
ENV PATH=${PATH}:${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin

RUN mkdir -p "${ANDROID_HOME}/cmdline-tools" /home/gradle/.android && \
    cd /tmp && \
    curl -fL "${ANDROID_SDK_URL}" -o commandlinetools.zip && \
    unzip commandlinetools.zip && \
    mv cmdline-tools "${ANDROID_HOME}/cmdline-tools/latest" && \
    rm commandlinetools.zip

RUN yes | sdkmanager --sdk_root="${ANDROID_HOME}" --licenses
RUN sdkmanager \
    --sdk_root="${ANDROID_HOME}" \
    "build-tools;36.0.0" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools" \
    "ndk;${ANDROID_NDK_VERSION}" \
    "cmake;3.22.1"

CMD mkdir -p /home/source/TMessagesProj/build/outputs/apk &&     cp -R /home/source/. /home/gradle &&     mkdir -p /home/gradle/TMessagesProj/config &&     if [ ! -f /home/gradle/TMessagesProj/config/release.keystore ]; then         keytool -genkey -v -keystore /home/gradle/TMessagesProj/config/release.keystore -alias owpengramkey -keyalg RSA -keysize 2048 -validity 10000 -storepass 817564a59f09a3aa2ebc9029 -keypass 817564a59f09a3aa2ebc9029 -dname "CN=OwpenGram, OU=OwpenGram, O=OwpenGram, L=City, S=State, C=US";     fi &&     cd /home/gradle &&     gradle :TMessagesProj_AppStandalone:assembleAfatStandalone --stacktrace &&     cp -R /home/gradle/TMessagesProj_AppStandalone/build/outputs/apk/. /home/source/TMessagesProj/build/outputs/apk
