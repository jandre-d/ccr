FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    jq \
    less \
    poppler-utils \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    ripgrep \
    unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH=/root/.local/bin:$PATH

WORKDIR /project
CMD ["/bin/bash"]
