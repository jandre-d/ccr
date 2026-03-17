.ONESHELL:
.PHONY: build run resume argcheck

MOUNT_SRC ?=

all:
	@echo "Usage: make run MOUNT_SRC=/path/to/project"

build:
	podman build -t claude-code -f Containerfile .

argcheck:
	if [ -z "$(MOUNT_SRC)" ]; then
		echo "Error: pass a project path with make run MOUNT_SRC=/path/to/project"
		exit 1
	fi
	if [ ! -d "$(MOUNT_SRC)" ]; then
		echo "Error: directory not found: $(MOUNT_SRC)"
		exit 1
	fi
	[ -f .claude.json ] || echo '{}' > .claude.json
	[ -d .claude ] || mkdir -p .claude

run: argcheck build
	podman run --rm -it --name claude-code \
		-v "$(MOUNT_SRC):/project:Z" \
		-v ./.claude:/root/.claude:Z \
		-v ./.claude.json:/root/.claude.json:Z \
		claude-code claude

resume: argcheck build
	podman run --rm --replace -it --name claude-code \
		-v "$(MOUNT_SRC):/project:Z" \
		-v ./.claude:/root/.claude:Z \
		-v ./.claude.json:/root/.claude.json:Z \
		claude-code claude --resume
