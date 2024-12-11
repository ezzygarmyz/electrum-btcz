# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during apt-get installation
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME="/opt"
ENV ANDROID_SDK_HOME="${ANDROID_HOME}/android-sdk"
ENV ANDROID_NDK="${ANDROID_HOME}/android-ndk"
ENV ANDROID_NDK_HOME="${ANDROID_NDK}"

# Set locales
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# Install dependencies
RUN apt-get update -y -qq > /dev/null \
    && apt-get install -qq --yes --no-install-recommends locales \
    && locale-gen en_US.UTF-8 \
    && apt-get -y install -qq --no-install-recommends \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        wget \
        lbzip2 \
        patch \
        sudo \
        software-properties-common \
        git \
        zip \
        unzip \
        build-essential \
        ccache \
        openjdk-13-jdk \
        autoconf \
        libtool \
        pkg-config \
        zlib1g-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libtinfo5 \
        cmake \
        libffi-dev \
        libssl-dev \
        automake \
        gettext \
        libltdl-dev \
        libgmp-dev \
        curl \
        ca-certificates \
        vim \
    && apt-get -y autoremove \
    && apt-get -y clean

# Prepare non-root environment
ENV USER="buildozer"
ENV HOME_DIR="/home/${USER}"
ENV WORK_DIR="${HOME_DIR}/build" \
    PATH="${HOME_DIR}/.local/bin:${PATH}"

RUN useradd --create-home --shell /bin/bash ${USER} \
    && usermod -append --groups sudo ${USER} \
    && echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && mkdir -p ${WORK_DIR} \
    && chown -R ${USER}:${USER} ${WORK_DIR} ${ANDROID_HOME}

USER ${USER}
WORKDIR ${WORK_DIR}

# Install Android SDK and NDK
RUN curl --location --progress-bar \
        "https://dl.google.com/android/repository/android-ndk-r21d-linux-x86_64.zip" \
        --output "android-ndk-r21d-linux-x86_64.zip" \
    && unzip -q "android-ndk-r21d-linux-x86_64.zip" -d "${ANDROID_HOME}" \
    && rm -rf "android-ndk-r21d-linux-x86_64.zip" \
    && curl --location --progress-bar \
        "https://dl.google.com/android/repository/commandlinetools-linux-6514223_latest.zip" \
        --output "commandlinetools-linux-6514223_latest.zip" \
    && unzip -q "commandlinetools-linux-6514223_latest.zip" -d "${ANDROID_SDK_HOME}" \
    && rm -rf "commandlinetools-linux-6514223_latest.zip" \
    && yes | ${ANDROID_SDK_HOME}/tools/bin/sdkmanager --licenses

# Install Buildozer and Python dependencies
RUN python3 -m pip install --user --upgrade pip \
    && python3 -m pip install --user --upgrade wheel cython==0.29.19 kivy

# Install Buildozer and python-for-android
RUN python3 -m pip install --user buildozer \
    && git clone https://github.com/kivy/python-for-android /opt/python-for-android

# Set the source directory for p4a (Python for Android)
ENV P4A_SOURCE_DIR="/opt/python-for-android"
ENV BUILD_DIR="${HOME_DIR}/build"

# Copy your project into the container
COPY . ${WORK_DIR}

# Set up Buildozer environment variables
ENV ANDROID_HOME="/opt/android-sdk"
ENV ANDROID_NDK="/opt/android-ndk"
ENV ANDROID_SDK_HOME="${ANDROID_HOME}"

# Set permissions for the copied project files
RUN chown -R buildozer:buildozer ${WORK_DIR}

# Build the app (using Buildozer inside the container)
CMD ["buildozer", "android", "debug"]