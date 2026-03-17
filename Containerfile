FROM ubuntu:24.04

RUN apt-get update && apt-get install -y curl ca-certificates bash git && rm -rf /var/lib/apt/lists/*

WORKDIR /root
RUN curl -fsSL https://claude.ai/install.sh | bash

ENV PATH=/root/.local/bin:$PATH
WORKDIR /project

CMD ["/bin/bash"]
