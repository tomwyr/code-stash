FROM ubuntu:latest

# Set working directory inside the container
WORKDIR /src

# Copy and build inside the container
# CMD swift build -c debug && mkdir -p /src/output && cp .build/aarch64-unknown-linux-gnu/debug/*.so /src/output/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y unzip wget git python3 clang

WORKDIR /opt
RUN wget https://dl.google.com/android/repository/android-ndk-r27c-linux.zip -O ndk.zip && \
  unzip ndk.zip && rm ndk.zip

RUN export ANDROID_NDK_HOME=/opt/android-ndk-r27c && \
  export SDKROOT=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/sysroot

WORKDIR /src
# RUN swift build -c debug --triple aarch64-unknown-linux-android27

# Install
# - setup environment
# - install packages
# - download android ndk
# - download development swift compiler
# - clone swift
# - [maybe] add swift usr bin to path - install libsqlite3-dev

# - setup dependencies
#   utils/update-checkout --clone
# - checkout correct tag
#   utils/update-checkout --tag swift-6.1-DEVELOPMENT-SNAPSHOT-2025-03-20-a
# - compile
#   utils/build-script -R --android --android-ndk $NDK_PATH --android-arch aarch64 --android-api-level 21 --stdlib-deployment-targets=android-aarch64 --native-swift-tools-path=$SWIFT_PATH --native-clang-tools-path=$SWIFT_PATH --build-swift-tools=0 --build-llvm=0 --skip-build-cmark
# - test build
#   $SWIFT_PATH/swiftc -tools-directory ${NDK_PATH}/toolchains/llvm/prebuilt/linux-x86_64/bin/ -target aarch64-unknown-linux-android21 -sdk ${NDK_PATH}/toolchains/llvm/prebuilt/linux-x86_64/sysroot -resource-dir build/Ninja-ReleaseAssert/swift-linux-x86_64/lib/swift hello.swift

# Links
# - https://github.com/swiftlang/swift/blob/main/docs/Android.md
# - https://github.com/swiftlang/swift/blob/main/docs/HowToGuides/GettingStarted.md
