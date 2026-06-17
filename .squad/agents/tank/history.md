# Project Context

- **Owner:** Pascal van der Heiden
- **Project:** sdd-mini-hack — a 1-hour learning repo teaching spec-driven development (SDD) and agentic engineering with GitHub Copilot. Four scenarios: (1) Greenfield Todo with OpenSpec, (2) Brownfield feature with Copilot Plan Mode, (3) Legacy COBOL modernization with Spec Kit, (4) Personal Assistant with Copilot CLI + Squad + OpenSpec.
- **Stack:** Node.js 20.19+ (vanilla JS / .mjs servers, static `public/` frontends), COBOL (legacy example), Markdown docs, Playwright MCP, Agent Skills, OpenSpec, Spec Kit, GitHub Copilot CLI/Plan Mode/Squad.
- **Goal:** Extend the repo with new SDD use cases/scenarios.
- **Created:** 2026-06-17

## Learnings

<!-- Append new learnings below. Each entry is something lasting about the project. -->
- Repo structure: scenarios in `docs/scenario-N-*.md`, sample apps in `examples/<app>/`, skills in `.github/skills/`, authoring guides in `.github/instructions/*.instructions.md`, MCP config in `.mcp.json` + `.vscode/mcp.json`, verification in `scripts/verify-workshop.sh`.
- User directive: use Speckit workflow only; do not use Superpowers skills.
- **2026-06-17:** Scenario 5 (ETL Climate Pipeline) uses a DEDICATED folder-scoped Squad at `examples/etl-climate-pipeline/.squad/`, completely isolated from the repo-root `.squad/` (which is the meta team for extending the SDD hacks). The two squads MUST NOT conflict. Learners open `examples/etl-climate-pipeline` in VS Code so the dedicated squad is active via SquadUI extension.
