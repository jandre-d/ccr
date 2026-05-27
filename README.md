# ccr

Run [Claude Code](https://docs.claude.com/en/docs/claude-code) in a Podman container. Supports running multiple instances in parallel, each with its own isolated history and config. Includes optional PostgreSQL and Neo4j sibling containers on a shared network.

## Prerequisites

- [Podman](https://podman.io/)
- A valid Claude Code authentication (API key or OAuth)

## Usage

```bash
make new SRC=/path/to/project        # new session
make resume SRC=/path/to/project     # resume last session
```

By default, each project gets its own instance (keyed by the directory name). To run multiple instances against the same project, pass `INSTANCE` explicitly:

```bash
make new SRC=/path/to/project INSTANCE=a1
make new SRC=/path/to/project INSTANCE=a2
```

### Managing instances

```bash
make build                           # build the container image
make list                            # show running instances
make stop INSTANCE=a1                # stop a specific instance
```

### PostgreSQL

A PostgreSQL 17 container can be run alongside Claude on a shared Podman network. Data persists in a named volume across restarts.

```bash
make postgres                        # start PostgreSQL (leave running)
make postgres-stop                   # stop PostgreSQL, data preserved
make postgres-wipe                   # delete all PostgreSQL data
```

From inside the Claude container, connect at `ccr-postgres:5432` with user `postgres` and password `devpassword`. From the host, connect at `localhost:5432`.

### Neo4j

A Neo4j 5.x container can be run alongside Claude on a shared Podman network. Data persists in a named volume across restarts.

```bash
make neo4j                           # start Neo4j (leave running)
make neo4j-stop                      # stop Neo4j, data preserved
make neo4j-wipe                      # delete all Neo4j data
```

From inside the Claude container, connect at `bolt://ccr-neo4j:7687` with user `neo4j` and password `devpassword`. The browser UI is available on the host at `http://localhost:7474`.
