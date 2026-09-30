# ccr

[Claude Code](https://docs.claude.com/en/docs/claude-code) in a Podman container. Each project gets its own instance with separate config and history.

## Usage

```bash
make new [SRC=path/to/project]     # new session (ask for a folder if SRC is omitted)
make resume [SRC=path/to/project]  # resume a previous session (pick a project if SRC is omitted)
make build                         # rebuild the image with the latest Claude Code
```

`new` and `resume` build the image only if it is missing. Run `make build` to update Claude Code.

The instance is named after the project's full path (`/home/me/code/api` becomes `home-me-code-api`).

## Layout

| Path                            | Purpose                                                    |
| ------------------------------- | ---------------------------------------------------------- |
| `seed/`                         | Copied into a new instance on first run, then left alone   |
| `skills/`                       | Mounted read-only into every instance                      |
| `.instances/<name>/claude-home` | The instance's `~/.claude`: config, auth, history          |

Containers join the `ccr-net` network. Start other containers (such as a database) on it and Claude can reach them by name.
