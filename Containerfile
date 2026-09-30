FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    jq \
    less \
    poppler-utils \
    python3-venv \
    ripgrep \
    sudo \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Replace the image's default uid 1000 user with "claude".
RUN userdel -r ubuntu \
    && useradd -m -s /bin/bash claude \
    && echo 'claude ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/claude

USER claude
ENV PATH=/home/claude/.local/bin:$PATH \
    CLAUDE_CONFIG_DIR=/home/claude/.claude

RUN curl -fsSL https://claude.ai/install.sh | bash

WORKDIR /project
ENTRYPOINT ["claude"]
