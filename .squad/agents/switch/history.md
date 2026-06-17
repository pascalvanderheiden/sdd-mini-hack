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

## 2026-06-17 — Scenario 5 documentation validation

**Task:** Validate scenario-5-speckit-etl-pipeline.md, README.md Scenario 5 row, prerequisites.md Scenario 5 entry against 6 criteria (source endpoints, target DB setup, command accuracy, Spec Kit lifecycle completeness, consistency, fact check).

**Approach:**
- Tested both public CSV endpoints (OWID CO₂, Datahub Population) with curl -sI and curl -s | head to verify HTTP 200 and CSV headers.
- Inspected docker-compose.yml, init.sql for syntax, schema correctness, healthcheck.
- Validated all commands (specify, uv, docker, psql) for correctness.
- Cross-checked Spec Kit lifecycle phases and Squad member assignments against .squad/routing.md.
- Verified README and prerequisites.md consistency (tooling, time, folder path).
- Confirmed find-skills missing, skill-creator/mcp-builder exist, .specify/ not yet created.

**Findings:**
- PASS with 2 minor fixes:
  1. OWID CSV column order in doc (line 48) doesn't match actual header order — recommended clarification.
  2. Step 1 (DB setup) has no explicit owner attribution, though routing.md table shows Tank owns Phase 0 Setup.
- No blockers. All endpoints live (HTTP 200). DB setup production-grade. All commands correct. Full lifecycle covered. README/prereqs consistent.

**Learning:**
- When validating data-source documentation, ALWAYS test the actual endpoints, not just read the doc claims — found column order mismatch this way.
- For multi-phase workflows with explicit owner assignments, verify EVERY step has clear ownership, not just the lifecycle summary table. Users follow steps sequentially; they won't see the table until Step 2.
- ETL scenario validation requires DB schema inspection (types, keys, indexes) and connection string verification — PostgreSQL init scripts auto-run on first container start, so syntax errors are silent failures if not caught in review.
- Documentation consistency check must cover: tooling lists, time estimates, folder paths, internal link resolution, and tone/structure match against peer scenarios. Use prior scenarios (3 & 4) as templates.

**Deliverable:** `.squad/decisions/inbox/switch-scenario5-validation.md` with prioritized fix list routed to Mouse.
