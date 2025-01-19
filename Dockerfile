FROM "ubuntu:18.04"
MAINTAINER "M2kar<m2kar.cn@gmail.com>"
ARG EMAGNET_VERSION=3.4
RUN apt update \
    && apt-get install -y --no-install-recommends \
        inetutils-ping \
        wget \
        curl \
        screen \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN curl https://codeload.github.com/wuseman/EMAGNET/tar.gz/${EMAGNET_VERSION} > /tmp/emagnet.tar.gz \
    && tar -xzv -f /tmp/emagnet.tar.gz -C / \
    && ln -s /EMAGNET-${EMAGNET_VERSION} /EMAGNET
WORKDIR  /EMAGNET
CMD ["/EMAGNET/emagnet","--emagnet"]


