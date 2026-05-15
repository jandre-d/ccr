FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    jq \
    less \
    poppler-utils \
    ripgrep \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH=/root/.local/bin:$PATH
WORKDIR /project

CMD ["/bin/bash"]
