SHELL    := bash
IMAGE    := claude-code
NETWORK  := ccr-net
INSTANCE := $(subst /,-,$(patsubst /%,%,$(abspath $(SRC))))
CONFIG   := .instances/$(INSTANCE)/claude-home

RUN = podman run --init --rm -it --name "claude-code-$(INSTANCE)" \
	--userns=keep-id:uid=1000,gid=1000 \
	--network $(NETWORK) \
	-v "$(abspath $(SRC)):/project:z" \
	-v "./$(CONFIG):/home/claude/.claude:z" \
	-v "./skills:/home/claude/.claude/skills:ro,z" \
	$(IMAGE)

.PHONY: help build init new resume

help:
	@echo "make new    [SRC=dir]"
	@echo "make resume [SRC=dir]"
	@echo "make build"

build:
	podman build --no-cache -t $(IMAGE) .

init:
	@test -d "$(SRC)" || { echo "SRC must be a directory: '$(SRC)'"; exit 1; }
	@podman image exists $(IMAGE) || $(MAKE) build
	@podman network create --ignore $(NETWORK) >/dev/null
	@mkdir -p $(CONFIG)
	@test -f $(CONFIG)/CLAUDE.md || cp seed/CLAUDE.md $(CONFIG)/
	@test -f $(CONFIG)/settings.json || cp seed/settings.json $(CONFIG)/
	@echo "$(abspath $(SRC))" > .instances/$(INSTANCE)/src

new: $(if $(SRC),init)
ifdef SRC
	$(RUN)
else
	@cd ~ && read -e -p "Project folder: ~/" dir && $(MAKE) -C $(CURDIR) new SRC="$$HOME/$$dir"
endif

resume: $(if $(SRC),init)
ifdef SRC
	$(RUN) --resume
else
	@select src in $$(cat .instances/*/src); do $(MAKE) resume SRC=$$src; break; done
endif