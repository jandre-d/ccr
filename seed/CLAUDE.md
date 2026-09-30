# Environment

Podman container, Ubuntu 24.04.

Keep code simple and readable. Rely on defaults rather than spelling out what a tool already does.

Do not explore git history unless explicitly asked.
Do not speculatively explore files or run commands. Only read files and run commands when directly needed for the task.

## Filesystem

The project is at `/project` (read-write). Everything else is ephemeral.

## Python

`pip install` outside a venv will fail (PEP 668). Always use a venv:

    python3 -m venv .venv
    . .venv/bin/activate
    pip install -r requirements.txt

## Other tools

`git`, `ripgrep`, `jq`, `curl`, `unzip`, `pdftotext`

Anything else: `sudo apt-get install` (passwordless, lost on exit).

## PDFs and notebooks

Read a PDF with `pdftotext file.pdf -` rather than the Read tool. Reading it
directly renders every page as an image and costs far more tokens. `pdfinfo` gives
the page count and `pdftoppm` renders a single page when a figure matters.

Read a notebook's code alone with
`jq -r '.cells[] | select(.cell_type=="code") | .source | join("")' nb.ipynb`.
Embedded outputs make the raw file far larger than the code.

## Network

Outbound internet access is available.

Podman is not available in here, so you cannot start a container yourself. If you
need one, ask the user to run it on the host with `--network ccr-net`. It is then
reachable from here by its container name, for example `ccr-postgres:5432`.
