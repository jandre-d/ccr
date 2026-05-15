# Environment

This project runs inside the `ccr` Podman container (see https://github.com/<you>/ccr).

## Available tools

- Python 3.12 with `pip` and `venv`
- `git`, `ripgrep`, `jq`, `curl`
- C build toolchain (`build-essential`, `python3-dev`) for compiling extensions

## Project filesystem

The project is mounted at `/project` (read-write). Anything outside `/project` is ephemeral and will be discarded when the container exits.

## Python conventions

Ubuntu 24.04 enforces PEP 668, so `pip install` outside a virtualenv will fail. Use a venv:

    python3 -m venv .venv
    . .venv/bin/activate
    pip install -r requirements.txt

## Neo4j

A Neo4j 5.x instance runs as a sibling container on the same Podman network. It is not started automatically — run `make neo4j` from the host before starting Claude if you need it.

Connection details:

- **Bolt URI:** `bolt://ccr-neo4j:7687`
- **User:** `neo4j`
- **Password:** `devpassword`
- **Browser UI (from host):** `http://localhost:7474`

Data persists in a named volume across restarts. To wipe the database, run `make neo4j-wipe` from the host.

## Network

Outbound internet access is available (for `pip install`, `git clone`, etc.). The Neo4j container is reachable as `ccr-neo4j`. No other containers are on the network by default.
