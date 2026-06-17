# Squad Decisions

## Active Decisions

### 2026-06-17T09:07:00Z: Scenario 5 — Greenfield ETL Pipeline (Squad + Spec Kit + Copilot CLI)

**By:** Neo (Lead / SDD Architect)  
**Status:** DESIGN COMPLETE — ready for coordinator fan-out

New workshop scenario: build a greenfield ETL pipeline spec-first using the full Spec Kit lifecycle orchestrated by Squad. Two public datasets (OWID CO2 emissions + World Bank Population) are joined on `(iso_code, year)` and landed into a local PostgreSQL container.

**Key Design Choices:**
- Folder: `examples/etl-climate-pipeline`
- Datasets: OWID CO2 (CC-BY-4.0, CSV) + Datahub Population (PDDL, CSV). Join key: ISO-3166-alpha-3 country code + year.
- Target: Local PostgreSQL via docker compose; target schema `climate` with tables `co2_emissions`, `population`, `country_metrics` (joined view materialized).
- Spec Kit agents mapped to Squad members: Morpheus (constitution), Oracle (specify+clarify), Niobe (plan), Dozer (tasks+analyze), Cypher (checklist), Seraph (implement), Link (skills manager).
- Orchestration: Neo invokes members in Spec Kit phase order; Seraph delegates to core team (Trinity/Tank/Switch); Link provisions skills before Seraph starts.
- Implementation stack: Python 3.12+, pandas-free (stdlib csv + psycopg), docker compose for PostgreSQL.

**Implications:**
- 7 new squad members added (does not replace existing core team)
- `find-skills` tool must be installed before implementation phase
- Scenario doc: `docs/scenario-5-speckit-etl-pipeline.md`
- No existing files modified; new content only

---

### 2026-06-17T07:06:00Z: Spec Kit orchestration model for new ETL scenario

**By:** Pascal van der Heiden (via Copilot)  
**Status:** ADOPTED

Defines how Squad and Spec Kit interlock for Scenario 5. User request establishes:
- One squad member per Spec Kit custom agent definition (the speckit.*.agent.md set)
- Lead (Neo) orchestrates Spec Kit method, invoking each speckit member at the right phase
- Member following speckit.implement.agent.md orchestrates CORE team (Trinity/Tank/Switch) for development
- Additional squad member (Link) manages skills via find-skills/skill-creator, provisioning before implementation
- Scenario uses 2 public open datasets, combined, landing in local PostgreSQL container

---

### 2026-06-17T08:27:00Z: Scenario 5 scaffold — dedicated folder-scoped squad, VS Code delivery

**By:** Pascal van der Heiden (via Copilot / Coordinator)  
**Status:** ADOPTED

Directive to scaffold examples/etl-climate-pipeline/ with self-contained approach (same as scenario 3). The scenario gets its OWN dedicated Squad living INSIDE `examples/etl-climate-pipeline/.squad/`, isolated from repo-root `.squad/` (the meta team for extending SDD hacks). Two squad setups must not conflict. Scenario 5 runs from VS Code: prereqs must add SquadUI and Spec Kit companion VS Code extensions, and REMOVE GitHub Copilot CLI install.

---

### 2026-06-17T10:30:00Z: Scenario 5 — Dedicated folder-scoped Squad scaffold (IMPLEMENTED)

**By:** Tank (Implementation Agent)  
**Status:** COMPLETE

Scaffolded self-contained example folder for Scenario 5 at `examples/etl-climate-pipeline/` with critical isolation requirement. **OWN dedicated Squad** lives at `examples/etl-climate-pipeline/.squad/`, completely separate from repo-root `.squad/`.

**Files Created:**
- `docker-compose.yml` — PostgreSQL 16 container
- `init.sql` — target schema + 3 tables (co2_emissions, population, country_metrics)
- `.env.example` — connection string + dataset URLs
- `.gitignore` — ignores data/*.csv, .env, __pycache__/, *.pyc
- `data/.gitkeep` — placeholder for downloaded CSVs
- `README.md` — scenario quick guide

**Dedicated Folder-Scoped Squad:**
- Copied 12 agents (neo, morpheus, oracle, niobe, dozer, cypher, link, seraph, trinity, tank, switch, scribe) to `examples/etl-climate-pipeline/.squad/agents/`
- Reset each agent's `history.md` to fresh scope (this pipeline, 2026-06-17)
- Squad infrastructure: team.md, routing.md, decisions.md, config.json, casting/, empty inbox/log/orchestration-log
- Validation: init.sql syntax correct by inspection; docker available; datasets/specify init to be run by learner

**Usage:** Learner opens `examples/etl-climate-pipeline` in VS Code with SquadUI extension; dedicated squad active and isolated from repo-root.

---

### 2026-06-17T10:31:00Z: Scenario 5 prereqs and workflow edits — VS Code delivery refinement

**By:** Mouse (Technical Writer / DevRel)  
**Status:** COMPLETE

Refined `docs/scenario-5-speckit-etl-pipeline.md` and `docs/prerequisites.md` to align with VS Code-based delivery.

**Changes:**
1. **Prereqs:**
   - Removed: GitHub Copilot CLI install (scenario runs in VS Code, not CLI)
   - Added: **Squad UI** VS Code extension (marketplace, publisher verified)
   - Added: **Spec Kit companion** VS Code extension (marketplace, publisher verified)
   - Kept: Docker, Python 3.12+/uv, Spec Kit CLI, optional psql, VS Code + GitHub Copilot + Copilot Chat

2. **Workflow Framing:**
   - Step 0: Verify source dataset endpoints (REQUIRED pre-build test)
   - Step 1: NEW — Open `examples/etl-climate-pipeline/` in VS Code to activate dedicated folder-scoped squad; explicit note that `.squad/` in folder is SEPARATE from repo-root squad
   - Step 2: (formerly Step 1) Database setup — docker-compose.yml and init.sql ALREADY EXIST; learner reviews and runs `docker compose up -d`
   - Step 3: "Meet your Squad" — Squad UI for interaction, Neo orchestrates Spec Kit phases, /speckit.* commands from Spec Kit companion
   - All subsequent steps renumbered (+1 through Step 13)

**Verified:** All edits non-breaking; docs remain consistent across scenarios.

## Governance

- All meaningful changes require team consensus
- Document architectural decisions here
- Keep history focused on work, decisions focused on direction
