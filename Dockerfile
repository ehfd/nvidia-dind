# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Supported base images: Ubuntu 24.04, 22.04, 20.04
ARG DISTRIB_IMAGE=ubuntu
ARG DISTRIB_RELEASE=24.04
FROM ${DISTRIB_IMAGE}:${DISTRIB_RELEASE}
ARG DISTRIB_IMAGE
ARG DISTRIB_RELEASE

LABEL maintainer="https://github.com/ehfd"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get clean && apt-get update && apt-get dist-upgrade -y && apt-get install --no-install-recommends -y \
        apt-utils \
        ca-certificates \
        openssh-client \
        curl \
        iptables \
        git \
        gnupg \
        software-properties-common \
        supervisor \
        wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/debconf/* /var/log/* /tmp/* /var/tmp/*

# NVIDIA Container Toolkit and Docker
RUN mkdir -pm755 /etc/apt/keyrings && curl -o /etc/apt/keyrings/docker.asc -fsSL "https://download.docker.com/linux/ubuntu/gpg" && chmod a+r /etc/apt/keyrings/docker.asc && \
    mkdir -pm755 /etc/apt/sources.list.d && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(grep UBUNTU_CODENAME= /etc/os-release | cut -d= -f2 | tr -d '\"') stable" > /etc/apt/sources.list.d/docker.list && \
    mkdir -pm755 /usr/share/keyrings && curl -fsSL "https://nvidia.github.io/libnvidia-container/gpgkey" | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -fsSL "https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list" | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' > /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
    apt-get update && apt-get install --no-install-recommends -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin \
        pigz \
        xz-utils \
        nvidia-container-toolkit && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/debconf/* /var/log/* /tmp/* /var/tmp/* && \
    nvidia-ctk runtime configure --runtime=docker

COPY modprobe entrypoint.sh /usr/local/bin/
RUN chmod -f 755 /usr/local/bin/entrypoint.sh /usr/local/bin/modprobe
COPY supervisord.conf /etc/supervisord.conf
RUN chmod -f 755 /etc/supervisord.conf

VOLUME /var/lib/docker

ENTRYPOINT ["/usr/bin/supervisord"]
