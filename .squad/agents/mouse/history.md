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
- Scenario 5 (ETL Pipeline) doc structure mirrors Scenario 3 (COBOL) and Scenario 4 (Squad): prereqs + numbered steps with code blocks + troubleshooting + learning summary. Step 0 is a REQUIRED data endpoint verification before any build. Each Spec Kit phase → one Squad member producing one artifact in order. Cypher's checklist is a hard gate before Seraph implements.
