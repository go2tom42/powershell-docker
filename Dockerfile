# Docker image file that describes an Ubuntu16.04 image with PowerShell installed from Microsoft APT Repo
FROM ubuntu:16.04

ARG PS_VERSION=6.1.0
ARG PS_VERSION_POSTFIX=-1.ubuntu.16.04
ARG IMAGE_NAME=mcr.microsoft.com/powershell:ubuntu16.04
ARG VCS_REF="none"


# Install dependencies and clean up
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        youtube-dl \
        aria2 \
        ffmpeg \
        ca-certificates \
        curl \
        apt-transport-https \
        locales \
    && apt-get dist-upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Setup the locale
ENV LANG en_US.UTF-8
ENV LC_ALL $LANG
RUN locale-gen $LANG && update-locale

# Download the Microsoft repository GPG keys
#RUN curl -L -O https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb

# Register the Microsoft repository GPG keys
#RUN dpkg -i packages-microsoft-prod.deb

# Install powershell from Microsoft Repo
RUN apt-get update \
      && curl -L -O https://github.com/PowerShell/PowerShell/releases/download/v6.1.0/powershell_6.1.0-1.ubuntu.16.04_amd64.deb    \
      && dpkg -i powershell_6.1.0-1.ubuntu.16.04_amd64.deb \
      && apt-get install -f \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

# Use PowerShell as the default shell
# Use array to avoid Docker prepending /bin/sh -c
CMD [ "pwsh" ]
