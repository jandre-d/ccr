# ccr

Run Claude Code in a Podman container. Supports running multiple instances in parallel, each with its own isolated history and config.

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
make list                                  # show running instances
make stop INSTANCE=a1                      # stop a specific instance
```