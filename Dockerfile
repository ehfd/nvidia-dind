FROM nvidia/cudagl:11.2.0-devel-ubuntu20.04

RUN apt-get update && apt-get install -y \
        ca-certificates \
        openssh-client \
        curl \
        iptables \
        supervisor && \
    rm -rf /var/lib/apt/list/*

ENV DOCKER_VERSION=19.03.15
ENV DOCKER_CHANNEL=stable \
    DEBUG=false

# Docker
RUN set -eux; \
    arch="$(uname --m)"; \
    case "$arch" in \
        # amd64
        x86_64) dockerArch='x86_64' ;; \
        # arm32v6
        armhf) dockerArch='armel' ;; \
        # arm32v7
        armv7) dockerArch='armhf' ;; \
        # arm64v8
        aarch64) dockerArch='aarch64' ;; \
        *) echo >&2 "error: unsupported architecture ($arch)"; exit 1 ;;\
    esac; \
    if ! curl -fsSL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz" -o /tmp/docker.tgz; then \
        echo >&2 "error: failed to download 'docker-${DOCKER_VERSION}' from '${DOCKER_CHANNEL}' for '${dockerArch}'"; \
        exit 1; \
    fi; \
    tar --extract \
        --file /tmp/docker.tgz \
        --strip-components 1 \
        --directory /usr/local/bin/ \
    ; \
    rm /tmp/docker.tgz; \
    dockerd --version; \
    docker --version

COPY modprobe startup.sh /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY logger.sh /opt/bash-utils/logger.sh

RUN chmod +x /usr/local/bin/startup.sh /usr/local/bin/modprobe
VOLUME /var/lib/docker

# Docker compose
RUN DOCKER_COMPOSE_VERSION=$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest | grep '"tag_name":' | cut -d '"' -f 4) && \
    curl -fsSL "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# NVIDIA Container Toolkit
RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - && \
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list && \
    apt-get update && apt-get install -y nvidia-docker2 && \
    rm -rf /var/lib/apt/list/*

ENTRYPOINT ["startup.sh"]
CMD ["sh"]
