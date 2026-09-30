SHELL    := bash
IMAGE    := claude-code
NETWORK  := ccr-net
# Named after the full path so projects with the same folder name don't collide.
INSTANCE := $(subst /,-,$(patsubst /%,%,$(abspath $(SRC))))
CONFIG   := .instances/$(INSTANCE)/claude-home

RUN = podman run --rm -it --name "claude-code-$(INSTANCE)" \
	--userns=keep-id:uid=1000,gid=1000 \
	--network $(NETWORK) \
	-v "$(abspath $(SRC)):/project:z" \
	-v "./$(CONFIG):/home/claude/.claude:z" \
	-v "./skills:/home/claude/.claude/skills:ro,z"

.PHONY: help build image network init new resume

help:
	@echo "make new [SRC=/path/to/project]    start a new session (ask for a folder if SRC is omitted)"
	@echo "make resume [SRC=/path/to/project] resume a previous session (pick a project if SRC is omitted)"
	@echo "make build                         rebuild the image with the latest Claude Code"

# --no-cache so every build installs the latest Claude Code.
build:
	podman build --no-cache -t $(IMAGE) .

# Build only if the image doesn't exist yet.
image:
	podman image exists $(IMAGE) || $(MAKE) build

# Other containers can join this network to be reachable by name.
network:
	podman network create --ignore $(NETWORK)

init:
	@test -d "$(SRC)" || { echo "Error: SRC must be a directory, got '$(SRC)'"; exit 1; }
	mkdir -p $(CONFIG)
	test -f $(CONFIG)/CLAUDE.md || cp seed/CLAUDE.md $(CONFIG)/
	test -f $(CONFIG)/settings.json || cp seed/settings.json $(CONFIG)/
	echo "$(abspath $(SRC))" > .instances/$(INSTANCE)/src

# Without SRC, ask for a folder under ~ (tab completes).
new: $(if $(SRC),init image network)
ifdef SRC
	$(RUN) $(IMAGE)
else
	@cd ~ && read -e -p "Project folder: ~/" dir && $(MAKE) -C $(CURDIR) new SRC="$$HOME/$$dir"
endif

resume: $(if $(SRC),init image network)
ifdef SRC
	$(RUN) $(IMAGE) --resume
else
	@select src in $$(cat .instances/*/src); do $(MAKE) resume SRC=$$src; break; done
endif
