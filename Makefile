.ONESHELL:
.PHONY: build new resume argcheck list stop network neo4j neo4j-stop neo4j-wipe

SRC       ?=
INSTANCE  ?= $(if $(SRC),$(shell basename $(SRC)))
STATE_DIR := .state/$(INSTANCE)
NETWORK   := ccr-net
NEO4J_VOL := ccr-neo4j-data

all:
	@echo "Usage: make <target> [SRC=/path/to/project] [INSTANCE=name]"
	@echo ""
	@echo "Sessions:"
	@echo "  new SRC=...        Start a new Claude session"
	@echo "  resume SRC=...     Resume the last session"
	@echo "  list               Show running Claude instances"
	@echo "  stop INSTANCE=...  Stop a specific instance"
	@echo ""
	@echo "Neo4j:"
	@echo "  neo4j              Start Neo4j (persistent data)"
	@echo "  neo4j-stop         Stop Neo4j (data preserved)"
	@echo "  neo4j-wipe         Delete all Neo4j data"
	@echo ""
	@echo "Build:"
	@echo "  build              Build the Claude container image"

build:
	podman build -t claude-code -f Containerfile .

argcheck:
	@if [ -z "$(SRC)" ]; then
		echo "Error: pass a project path with make new SRC=/path/to/project"
		exit 1
	fi
	if [ ! -d "$(SRC)" ]; then
		echo "Error: directory not found: $(SRC)"
		exit 1
	fi

	mkdir -p "$(STATE_DIR)/.claude/projects"
	mkdir -p "$(STATE_DIR)/.claude/todos"

	# Seed state files on first run
	if [ ! -f "$(STATE_DIR)/.claude.json" ]; then
		echo '{}' > "$(STATE_DIR)/.claude.json"
	fi

	if [ ! -f "$(STATE_DIR)/.claude/CLAUDE.md" ]; then
		cp .claude/CLAUDE.md "$(STATE_DIR)/.claude/CLAUDE.md"
	fi

	if [ ! -f "$(STATE_DIR)/.claude/settings.json" ]; then
		cp .claude/settings.json "$(STATE_DIR)/.claude/settings.json"
	fi

network:
	@podman network exists $(NETWORK) || podman network create $(NETWORK)

neo4j: network
	@podman container exists ccr-neo4j && echo "Neo4j already running" || \
	podman run -d --rm \
		--name ccr-neo4j \
		--network $(NETWORK) \
		-p 7474:7474 -p 7687:7687 \
		-e NEO4J_AUTH=neo4j/devpassword \
		-v $(NEO4J_VOL):/data \
		neo4j:5

neo4j-stop:
	@podman container exists ccr-neo4j && podman stop ccr-neo4j || echo "Neo4j not running"

neo4j-wipe:
	@echo "Wiping Neo4j data volume..."
	@podman container exists ccr-neo4j && podman stop ccr-neo4j || true
	podman volume rm -f $(NEO4J_VOL)

new: argcheck build network
	clear
	podman run --rm -it --name "claude-code-$(INSTANCE)" \
		--userns=keep-id \
		--network $(NETWORK) \
		-v "$(SRC):/project:z" \
		-v "./$(STATE_DIR)/.claude/projects:/home/claude/.claude/projects:z" \
		-v "./$(STATE_DIR)/.claude/todos:/home/claude/.claude/todos:z" \
		-v "./$(STATE_DIR)/.claude/CLAUDE.md:/home/claude/.claude/CLAUDE.md:z" \
		-v "./$(STATE_DIR)/.claude.json:/home/claude/.claude.json:z" \
		claude-code claude

resume: argcheck build network
	clear
	podman run --rm --replace -it --name "claude-code-$(INSTANCE)" \
		--userns=keep-id \
		--network $(NETWORK) \
		-v "$(SRC):/project:z" \
		-v "./$(STATE_DIR)/.claude/projects:/home/claude/.claude/projects:z" \
		-v "./$(STATE_DIR)/.claude/todos:/home/claude/.claude/todos:z" \
		-v "./$(STATE_DIR)/.claude/CLAUDE.md:/home/claude/.claude/CLAUDE.md:z" \
		-v "./$(STATE_DIR)/.claude.json:/home/claude/.claude.json:z" \
		claude-code claude --resume

list:
	podman ps --filter "name=claude-code-" --format "table {{.Names}}\t{{.Status}}\t{{.Mounts}}"

stop:
	@if [ -z "$(INSTANCE)" ]; then \
		echo "Error: pass INSTANCE=name"; exit 1; \
	fi
	podman stop "claude-code-$(INSTANCE)"
