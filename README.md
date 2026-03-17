# ccr

Run [Claude Code](https://docs.claude.com/en/docs/claude-code) in a Podman container with opinionated defaults. Mount any project directory and get an isolated, read-first Claude Code session.

## Usage
```bash
make run MOUNT_SRC=/path/to/project        # new session
make resume MOUNT_SRC=/path/to/project     # resume last session
```

## Defaults

- Read-only by default — shell commands, web fetch, and writes are denied unless explicitly allowed
- Analysis and explanation first, no unsolicited changes or suggestions
- `CLAUDE.md` and `.claude/settings.json` are tracked and mounted into every session

## Notes

- `:Z` volume flags are for SELinux (Fedora/RHEL)
