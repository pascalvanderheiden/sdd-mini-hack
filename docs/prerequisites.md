# Workshop Prerequisites

## Baseline requirements (all scenarios)

| Requirement | macOS install command | Windows install command |
|---|---|---|
| VS Code | `brew install --cask visual-studio-code` | `winget install -e --id Microsoft.VisualStudioCode` |
| Copilot extensions in VS Code | `code --install-extension GitHub.copilot && code --install-extension GitHub.copilot-chat` | `code --install-extension GitHub.copilot && code --install-extension GitHub.copilot-chat` |
| Node.js 20.19+ | `brew install node@20` | `winget install -e --id OpenJS.NodeJS.LTS` |
| Clone workshop repo | `git clone https://github.com/pascalvanderheiden/sdd-mini-hack.git && cd sdd-mini-hack` | `git clone https://github.com/pascalvanderheiden/sdd-mini-hack && cd sdd-mini-hack` |
| Playwright MCP config (already in repo) | `test -f .vscode/mcp.json && test -f .mcp.json` | `if (Test-Path .vscode/mcp.json -and Test-Path .mcp.json) { 'ok' } else { 'missing files' }` |
| Playwright CLI backup (recommended) | `npm install -g playwright && npx playwright install chromium` | `npm install -g playwright; npx playwright install chromium` |

## Requirements per scenario

### Scenario 1: OpenSpec Todo

| Requirement | macOS install command | Windows install command |
|---|---|---|
| OpenSpec CLI | `npm install -g @fission-ai/openspec@latest` | `npm install -g @fission-ai/openspec@latest` |
| VS Code extension (`atman-dev.openspec-for-copilot`) | `code --install-extension atman-dev.openspec-for-copilot` | `code --install-extension atman-dev.openspec-for-copilot` |

### Scenario 2: Plan Mode Bookshelf

| Requirement | macOS install command | Windows install command |
|---|---|---|
| No extra tools | `# none` | `# none` |

### Scenario 3: Spec Kit COBOL

| Requirement | macOS install command | Windows install command |
|---|---|---|
| GnuCOBOL | `brew install gnu-cobol` | `wsl sudo apt-get update && wsl sudo apt-get install -y gnucobol` |
| Python 3.12+ | `brew install python@3.12` | `winget install -e --id Python.Python.3.12` |
| uv | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | `powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 \| iex"` |
| Spec Kit CLI | `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` | `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` |
| VS Code extension (`alfredoperez.speckit-companion`) | `code --install-extension alfredoperez.speckit-companion` | `code --install-extension alfredoperez.speckit-companion` |

### Scenario 4: Squad Assistant

| Requirement | macOS install command | Windows install command |
|---|---|---|
| Copilot CLI | `brew install --cask copilot-cli` | `npm install -g @github/copilot@latest` |
| Squad CLI | `npm install -g @bradygaster/squad-cli` | `npm install -g @bradygaster/squad-cli` |
| OpenSpec CLI | `npm install -g @fission-ai/openspec@latest` | `npm install -g @fission-ai/openspec@latest` |

### Scenario 5: ETL Pipeline with Squad + Spec Kit

| Requirement | macOS install command | Windows install command |
|---|---|---|
| Squad CLI | `npm install -g @bradygaster/squad-cli` | `npm install -g @bradygaster/squad-cli` |
| Docker Desktop (recommended) | `brew install --cask docker` | `winget install -e --id Docker.DockerDesktop` |
| colima (optional macOS alternative) | `brew install colima docker` then `colima start` | N/A (use Docker Desktop) |
| Docker Compose | Included with Docker Desktop / colima | Included with Docker Desktop |
| Python 3.12+ | `brew install python@3.12` | `winget install -e --id Python.Python.3.12` |
| uv | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | `powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 \| iex"` |
| Spec Kit CLI | `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` | `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` |
| Spec Kit companion (VS Code extension, optional) | Search VS Code Extensions for **Spec Kit** companion: https://marketplace.visualstudio.com/search?term=spec%20kit&target=VSCode | Search VS Code Extensions for **Spec Kit** companion: https://marketplace.visualstudio.com/search?term=spec%20kit&target=VSCode |
| psql client (optional) | `brew install postgresql@16` | `winget install -e --id PostgreSQL.PostgreSQL` |

