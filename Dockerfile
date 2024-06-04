# Copyright (c) 2024 Ivanchuk Ivan
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met: 1) Redistributions of source code must retain the above
# copyright notice, this list of conditions and the following
# disclaimer. 2) Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided
# with the distribution. 3) Neither the name of the rultor.com nor
# the names of its contributors may be used to endorse or promote
# products derived from this software without specific prior written
# permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
# NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

# The software packages configured here (Git, Java, Maven, etc.) are for
# the convenience of the users going to use this container.
# If you are going to use your own container, you may remove them.
# Rultor has no dependency on these packages.

FROM ubuntu:20.04
MAINTAINER Ivan Ivanchuck <l3r8yJ@duck.com>
LABEL Description="This is the Rust image for Rultor.com" Vendor="l3r8y.ru" Version="0.0.0"
WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive

# To disable IPv6
RUN mkdir ~/.gnupg
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

# UTF-8 locale
RUN apt-get clean
RUN apt-get update -y --fix-missing
RUN apt-get -y install locales=2.31-0ubuntu9.9
RUN locale-gen en_US.UTF-8 && \
  dpkg-reconfigure locales && \
  echo "LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8\nLANGUAGE=en_US.UTF-8" > /etc/default/locale
ENV LC_ALL en_US.UTF-8
RUN echo 'export LC_ALL=en_US.UTF-8' >> /root/.profile
ENV LANG en_US.UTF-8
RUN echo 'export LANG=en_US.UTF-8' >> /root/.profile
ENV LANGUAGE en_US.UTF-8
RUN echo 'export LANGUAGE=en_US.UTF-8' >> /root/.profile

# Basic Linux tools
RUN apt-get -y update
RUN apt-get -y install wget=1.20.3-1ubuntu2
RUN apt-get -y install vim
RUN apt-get -y install curl
RUN apt-get -y install sudo
RUN apt-get -y install unzip
RUN apt-get -y install zip=3.0-11build1
RUN apt-get -y install gnupg2=2.2.19-3ubuntu2.2
RUN apt-get -y install jq=1.6-1ubuntu0.20.04.1
RUN apt-get -y install netcat-openbsd=1.206-1ubuntu1
RUN apt-get -y install bsdmainutils=11.1.2ubuntu3
RUN apt-get -y install libxml2-utils=2.9.10+dfsg-5ubuntu0.20.04.5
RUN apt-get -y install libjpeg-dev=8c-2ubuntu8
RUN apt-get -y install aspell=0.60.8-1ubuntu0.1
RUN apt-get -y install ghostscript=9.50~dfsg-5ubuntu4.6
RUN apt-get -y install build-essential=12.8ubuntu1.1
RUN apt-get -y install automake=1:1.16.1-4ubuntu6
RUN apt-get -y install autoconf=2.69-11.1
RUN apt-get -y install chrpath=0.16-2
RUN apt-get -y install libxft-dev=2.3.3-0ubuntu1
RUN apt-get -y install libfreetype6=2.10.1-2ubuntu0.2
RUN apt-get -y install libfreetype6-dev=2.10.1-2ubuntu0.2
RUN apt-get -y install libfontconfig1=2.13.1-2ubuntu3
RUN apt-get -y install libfontconfig1-dev=2.13.1-2ubuntu3
RUN apt-get -y install software-properties-common

# CMake for C/C++ projects
RUN apt-get -y install cmake=3.16.3-1ubuntu1.20.04.1

# Docker cli
RUN mkdir -p /tmp/download \
  && curl -s -L "https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz" | \
    tar -xz -C /tmp/download \
  && mv /tmp/download/docker/docker /usr/bin/ \
  && rm -rf /tmp/download

# Git 2.0
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get update -y --fix-missing
RUN apt-get -y install git
RUN bash -c '[[ "$(git --version)" =~ "2.39" ]]'

# SSH Daemon
RUN apt-get -y install ssh=1:8.2p1-4ubuntu0.5
RUN mkdir /var/run/sshd && \
  chmod 0755 /var/run/sshd

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Clean up
RUN rm -rf /tmp/*
RUN rm -rf /root/.ssh
RUN rm -rf /root.cache
RUN rm -rf /root.wget-hsts
RUN rm -rf /root/.gnupg

ENTRYPOINT ["/bin/bash", "--login", "-c"]
