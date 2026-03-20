.ONESHELL:
.PHONY: build run resume argcheck

MOUNT_SRC ?=

all:
	@echo "Usage: make run MOUNT_SRC=/path/to/project"

build:
	podman build -t claude-code -f Containerfile .

argcheck:
	@if [ -z "$(MOUNT_SRC)" ]; then \
		echo "Error: pass a project path with make run MOUNT_SRC=/path/to/project"; \
		exit 1; \
	fi
	@if [ ! -d "$(MOUNT_SRC)" ]; then \
		echo "Error: directory not found: $(MOUNT_SRC)"; \
		exit 1; \
	fi
	@[ -f .claude.json ] || echo '{}' > .claude.json
	@[ -d .claude ] || mkdir -p .claude

run: argcheck build
	clear
	podman run --rm -it --name claude-code \
		-v "$(MOUNT_SRC):/project:z" \
		-v ./.claude:/root/.claude:z \
		-v ./.claude.json:/root/.claude.json:z \
		claude-code claude

resume: argcheck build
	clear
	podman run --rm --replace -it --name claude-code \
		-v "$(MOUNT_SRC):/project:z" \
		-v ./.claude:/root/.claude:z \
		-v ./.claude.json:/root/.claude.json:z \
		claude-code claude --resume
