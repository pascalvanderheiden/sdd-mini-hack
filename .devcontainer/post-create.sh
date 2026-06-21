#!/usr/bin/env bash
# Provision every tool the workshop scenarios (1-6) need.
set -euo pipefail

echo "▶ Installing system packages (GnuCOBOL)…"
sudo apt-get update
sudo apt-get install -y gnucobol

echo "▶ Installing global npm CLIs (OpenSpec, Squad, Copilot CLI, Playwright)…"
npm install -g \
  @fission-ai/openspec@latest \
  @bradygaster/squad-cli \
  @github/copilot@latest \
  playwright

echo "▶ Installing Playwright Chromium + OS deps…"
npx --yes playwright install --with-deps chromium

echo "▶ Installing uv (Python tool manager)…"
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

echo "▶ Installing Spec Kit CLI (specify)…"
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git || true

echo "▶ Versions:"
node --version
python3 --version
gh --version | head -n1
cobc -V | head -n1 || true
openspec --version 2>/dev/null || echo "openspec: installed"
squad --version 2>/dev/null || echo "squad: installed"
copilot --version 2>/dev/null || echo "copilot: installed"
uv --version || true
specify check 2>/dev/null || echo "specify: run 'specify check' after reopening the terminal"
docker --version || echo "docker: provided by docker-in-docker feature"

echo "✅ post-create complete. Re-open a terminal so ~/.local/bin (uv, specify) is on PATH."
