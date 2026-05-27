# Environment

You are running inside a Podman container based on Ubuntu 24.04.

Do not explore git history (git log, git blame, etc.) unless explicitly asked.
Do not speculatively explore files or run commands to gather context. Only read files and run commands when directly needed for the task at hand.

## Filesystem

The project is mounted at `/project` (read-write). Everything outside `/project` is ephemeral and discarded when the container exits.

## Tools

- Python 3.12 with `pip` and `venv`
- Go 1.24 with gopls, delve, staticcheck, goimports, gofumpt, golangci-lint, air, goose
- `git`, `ripgrep`, `jq`, `curl`, `psql`, `poppler-utils`
- C build toolchain (`build-essential`, `python3-dev`)

## Python

Ubuntu 24.04 enforces PEP 668 — `pip install` outside a virtualenv will fail. Always use a venv:

    python3 -m venv .venv
    . .venv/bin/activate
    pip install -r requirements.txt

## PostgreSQL

Optional sibling container on the same Podman network. Not started automatically — run `make postgres` from the host.

- **Host:** `ccr-postgres`
- **Port:** `5432`
- **User:** `postgres`
- **Password:** `devpassword`
- **From host:** `localhost:5432`

Data persists in a named volume. Wipe with `make postgres-wipe` from the host.

## Neo4j

Optional sibling container on the same Podman network. Not started automatically — run `make neo4j` from the host.

- **Bolt URI:** `bolt://ccr-neo4j:7687`
- **User:** `neo4j`
- **Password:** `devpassword`
- **Browser UI (from host):** `http://localhost:7474`

Data persists in a named volume. Wipe with `make neo4j-wipe` from the host.

## Network

Outbound internet access is available. Database containers are reachable by hostname (`ccr-postgres`, `ccr-neo4j`).
