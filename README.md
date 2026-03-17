# ccr

Run [Claude Code](https://docs.claude.com/en/docs/claude-code) in a Podman container.

Includes defaults to reduce token usage — no unsolicited commands, changes, or suggestions. See `CLAUDE.md` and `settings.json`.

## Usage
```bash
make run MOUNT_SRC=/path/to/project        # new session
make resume MOUNT_SRC=/path/to/project     # resume last session
```
