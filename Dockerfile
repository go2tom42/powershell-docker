FROM ubuntu:16.04

MAINTAINER Larry Smith Jr. <mrlesmithjr@gmail.com>

# Install PowerShell Pre-Reqs
RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        curl \
        youtube-dl \
        ffmpeg \
        aria2
RUN mkdir -p /PSripper/config

# Add Microsoft apt key and repo
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/microsoft.list

# Install PowerShell
RUN apt-get update && apt-get install -y powershell

# Cleanup
RUN apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD YTripper.ps1 /PSripper/YTripper.ps1
CMD pwsh #/PSripper/YTripper.ps1

VOLUME /PSripper/config /media 
