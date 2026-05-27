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
    postgresql-client \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    ripgrep \
    sudo \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Go from upstream (Ubuntu's golang package lags behind)
ARG GO_VERSION=1.24.3
RUN ARCH=$(dpkg --print-architecture) \
    && case "$ARCH" in \
         amd64) GOARCH=amd64 ;; \
         arm64) GOARCH=arm64 ;; \
         *) echo "Unsupported arch: $ARCH" && exit 1 ;; \
       esac \
    && curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${GOARCH}.tar.gz" -o /tmp/go.tar.gz \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz
ENV PATH=/usr/local/go/bin:$PATH \
    GOTOOLCHAIN=auto

# Non-root user (replace default ubuntu user at UID/GID 1000)
ARG USERNAME=claude
ARG USER_UID=1000
ARG USER_GID=1000
RUN userdel -r ubuntu 2>/dev/null || true \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

# Claude Code
RUN curl -fsSL https://claude.ai/install.sh | bash

# Go environment for the user
ENV GOPATH=/home/claude/go \
    PATH=/home/claude/.local/bin:/home/claude/go/bin:/usr/local/go/bin:$PATH

# Common Go dev tools
RUN go install golang.org/x/tools/gopls@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest \
    && go install golang.org/x/tools/cmd/goimports@latest \
    && go install mvdan.cc/gofumpt@latest \
    && go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
    && go install github.com/air-verse/air@latest \
    && go install github.com/pressly/goose/v3/cmd/goose@latest

WORKDIR /project
CMD ["/bin/bash"]