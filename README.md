# ccr

Run [Claude Code](https://docs.claude.com/en/docs/claude-code) in a Podman container. Supports running multiple instances in parallel, each with its own isolated history and config. Includes an optional Neo4j sibling container for testing Cypher queries.

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
make list                            # show running instances
make stop INSTANCE=a1                # stop a specific instance
```

### Neo4j

A Neo4j container can be run alongside Claude on a shared Podman network. Data persists in a named volume across restarts.

```bash
make neo4j                           # start Neo4j (leave running)
make neo4j-stop                      # stop Neo4j, data preserved
make neo4j-wipe                      # delete all Neo4j data
```

From inside the Claude container, connect at `bolt://ccr-neo4j:7687` with user `neo4j` and password `devpassword`. The browser UI is available on the host at `http://localhost:7474`.