FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    openssh-client \
    jq \
    less \
    file \
    procps \
    locales \
    build-essential \
    poppler-utils \
    ghostscript \
    qpdf \
    imagemagick \
    librsvg2-bin \
    inkscape \
    python3-venv \
    python3-pip \
    ripgrep \
    sudo \
    unzip \
    # Data analysis
    python3-numpy \
    python3-pandas \
    python3-scipy \
    python3-statsmodels \
    python3-matplotlib \
    # LaTeX / PDF toolchain
    latexmk \
    lmodern \
    pandoc \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-xetex \
    texlive-luatex \
    texlive-science \
    texlive-pictures \
    texlive-plain-generic \
    texlive-bibtex-extra \
    texlive-lang-european \
    texlive-lang-other \
    biber \
    chktex \
    fontconfig \
    fonts-dejavu \
    fonts-liberation \
    fonts-noto \
    fonts-noto-cjk \
    && sed -i 's/# en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

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