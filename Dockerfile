FROM ubuntu:16.04

MAINTAINER tom42

# Install PowerShell Pre-Reqs
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    apt-transport-https \
    locales \
    curl \
    python3 \
    python3-pip \
    aria2

# Set the locale 
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8 
    
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8771ADB0816950D8 && \
 
RUN add-apt-repository ppa:jonathonf/ffmpeg-3 && \
    apt-get update && \
    apt-get -y --no-install-recommends install ffmpeg && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install youtube-dl && \
    pip3 install lxml


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
CMD pwsh /PSripper/YTripper.ps1

VOLUME /PSripper/config /media 
