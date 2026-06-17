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

## 2026-06-17 — Scenario 5 live infrastructure test (colima runtime)

**Task:** Run end-to-end infrastructure test of Scenario 5 scaffold using colima as Docker daemon. Verify Docker runtime, source endpoints, DB schema, sanity operations, and clean teardown.

**Approach:**
- Pre-flight: verified colima installed, started it with `--cpu 2 --memory 4` (77s cold start).
- Step 1 (Docker runtime): `docker info` to confirm daemon responsive post-colima start.
- Step 2 (Source endpoints): `curl -sI` + `curl -s | head -1` on both OWID CO₂ and Datahub Population CSVs. Verified HTTP 200 + expected headers (`country,year,iso_code,...` and `Country Name,Country Code,Year,Value`).
- Step 3 (Target DB): `docker-compose up -d` to pull postgres:16-alpine image and start container. Polled `pg_isready -U etl -d climate_db` until healthy (11s).
- Step 4 (Schema verification): `\dt climate.*` confirmed 3 tables (co2_emissions, population, country_metrics). `\di climate.*` confirmed 6 indexes (3 primary keys + 3 custom: idx_co2_iso_year, idx_pop_iso_year, idx_metrics_iso_year). Matched init.sql exactly.
- Step 5 (Sanity test): INSERT + SELECT on climate.co2_emissions. Returned count=1. Confirmed DB writable and queryable.
- Step 6 (Teardown): `docker-compose down -v`. Verified container removed, volume deleted, network removed, `docker-compose ps` empty. Confirmed data/ directory still clean (only .gitkeep). Left colima running (user will reuse it).

**Findings:**
- PASS all steps. No blockers.
- Minor issue: docker-compose.yml:1 has obsolete `version: '3.8'` field. Generates warning on every command. Non-functional but noisy. Recommended removal per Compose Specification.
- Total test duration: ~4 minutes (including colima cold start and image pull).
- Postgres became healthy in 11 seconds post-container start.
- init.sql auto-executed correctly (schema matches specification).

**Learning:**
- colima start can take 60–90s on first run (QEMU VM boot + Docker daemon init). When writing test scripts, allow ≥120s initial_wait for `colima start`.
- docker-compose up with image pull adds ~30–60s. For live tests, separate "pull" step from "start" step to isolate failures.
- pg_isready polling is more reliable than fixed sleeps. Use loop with 10–12 attempts @ 3s interval to handle varying startup speeds.
- Always verify teardown with `docker-compose ps` and volume inspection — `docker-compose down -v` can silently fail to remove volumes if containers are unhealthy.
- Obsolete docker-compose.yml `version` field is common in legacy examples. Flag it in docs/tests but treat as cosmetic, not blocking.
- For workshop delivery, pre-pull the postgres:16-alpine image to save attendees 30–60s of wait time during hands-on exercises.

**Deliverable:** `.squad/decisions/inbox/switch-scenario5-livetest.md` with PASS report and minor fix recommendation (remove version field).
