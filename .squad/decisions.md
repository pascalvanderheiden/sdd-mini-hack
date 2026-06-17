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

---

### 2026-06-17T08:42:00Z: Scenario 5 — learners create their own squad; colima for containers

**By:** Pascal van der Heiden (via Copilot)  
**Status:** ADOPTED

**Directive:** Do NOT ship a pre-made `.squad/` in `examples/etl-climate-pipeline/`. Creating the dedicated, folder-scoped squad is PART OF THE EXERCISE: learner runs `squad init` in the example folder via terminal (isolated from repo-root squad), then prompts Squad coordinator via Squad UI in VS Code to hire a crystal-clear team for full Spec Kit lifecycle + core build team.

**Requirements:**
- Instructions MUST include explicit prompting guidance on phrasing the request for unambiguous team composition
- Containers run with colima (`colima start`) as Docker runtime (macOS native)
- Squad creation and precise prompting is a learning objective, not pre-baked

---

### 2026-06-17T10:44:00Z: Scenario 5 documentation updated — self-create squad + colima + prompting guidance

**By:** Mouse (Technical Writer / DevRel)  
**Status:** COMPLETE

Implemented self-create squad pattern for Scenario 5 (ETL Pipeline):

**Changes:**
1. **NEW STEP 3 "Create your own Squad"** — Learners create folder-scoped squad via `squad init` inside example folder, kept isolated from repo-root squad
2. **"Prompt for a crystal-clear team" subsection** — Extensive guidance on phrasing hire request:
   - State goal (greenfield ETL, full Spec Kit lifecycle, two public datasets → PostgreSQL)
   - Name roles explicitly (one per Spec Kit phase + Skills Manager + core build team)
   - Ask Lead to orchestrate phases, Implement member to orchestrate core team
   - Request isolation (folder-scoped)
   - Review and refine proposed roster before confirming
3. **Concrete example prompt** — Complete, adaptable template for exact team composition
4. **"Tips for clear prompting" list** — Explicit role naming, methodology reference, isolation, roster iteration
5. **Colima documentation** — Added to prerequisites.md and Step 2 (DB setup):
   - macOS: `brew install colima docker`, then `colima start` before `docker compose`
   - Troubleshooting: if `docker info` fails, run `colima start` again
6. **Updated examples/etl-climate-pipeline/README.md** — Removed pre-made squad claim; learners create squad during Step 3
7. **Renumbered all steps** — Step 3→4 (Meet Squad), Step 4→5 (Init Spec Kit), etc. through Step 14 (Troubleshooting)

**Verification:** All edits to scenario-5, prerequisites, example README, history log. No breaking changes; only insertions and renumbering.

---

### 2026-06-17T10:47:00Z: Scenario 5 Live Infrastructure Test — PASS

**By:** Switch (QA / Infrastructure)  
**Status:** COMPLETE

Full end-to-end live test: colima startup → docker compose → schema verification → sanity test → teardown.

**Test Results:**
- **Docker Runtime:** colima started successfully (~77s). Docker daemon responsive.
- **Source Endpoints:** Both dataset URLs return HTTP 200 (CO2 + Population CSV headers verified)
- **Target DB:** postgres:16-alpine container healthy within 11 seconds
- **Schema Verification:** All 3 tables created (co2_emissions, population, country_metrics). All 6 indexes present (3 primary keys + 3 composite on iso_code, year)
- **Sanity Test:** Insert and select operations functional. Database writable and queryable.
- **Teardown:** All containers, volumes, networks removed cleanly. Data directory clean (only .gitkeep)
- **Total Test Duration:** ~4 minutes (including colima cold start and image pull)

**Minor Finding:** Obsolete `version: '3.8'` in docker-compose.yml generates warning on every command. **Recommendation:** Remove line 1 per [Compose Specification](https://docs.docker.com/compose/compose-file/). **Action:** Removed by Coordinator.

**Compliance:** All 8 scenario claims verified (3 tables, 3 indexes, image, init script, healthcheck, port, volume, network).

**Status:** Production-ready for workshop delivery.

---

### 2026-06-17T09:09:00Z: Scenario 5 doc — concise, Copilot Chat Squad agent, two-prompt flow

**By:** Pascal van der Heiden (via Copilot)  
**Status:** ADOPTED — Implementation by Mouse COMPLETE

Rework scenario-5 doc to be concise and to the point. Squad install is already a prereq (don't repeat as a step). Do NOT use the VS Code SquadUI extension for creating the squad — instead the learner switches to the Squad custom agent in GitHub Copilot Chat and hires the team there. The hire/example prompt should mirror the user's original session-opening ETL request (greenfield ETL, spec the contract, one member per speckit custom agent, Lead orchestrates speckit invoking each member at the right time, implement-member orchestrates the core team, add a skills manager using find-skills/skill-creator, 2 public datasets → local postgres). The squad runs the Spec Kit process via TWO prompts: (1) one prompt to the Lead → distributes to members to create constitution, specs, plan, tasks, and search for needed skills, then STOP for spec validation; (2) after the user validates the specs, one prompt to kick off implementation in one go following the speckit implement pattern, Lead distributing to core squad members. Remove the verbose per-phase steps.

**Why:** User request — match the real Copilot Chat + custom-agent flow and keep the guide concise.

---

### 2026-06-17T11:11:00Z: Scenario 5 doc rewritten — concise, two-prompt flow, Squad custom agent

**By:** Mouse (Technical Writer / DevRel)  
**Status:** COMPLETE

Rewrote `docs/scenario-5-speckit-etl-pipeline.md`: **589 lines → 141 lines** (target: 150–200). Collapsed per-phase step-by-step into 7 streamlined steps.

**Key Changes:**
- Removed SquadUI VS Code extension guidance entirely. Now uses **Squad custom agent in Copilot Chat** (`.github/agents/squad.agent.md`).
- Removed `squad init` / CLI install from steps — Squad is a repo prereq.
- Updated workflow to **two-prompt pattern**: (1) Lead runs constitution/spec/plan/tasks + Skills Manager finds capabilities, then STOP for validation; (2) Lead orchestrates implementation following speckit.implement pattern, distributing tasks to core team.
- Removed long member→phase assignment table. Removed verbose per-role explanations.
- Updated `docs/prerequisites.md`: removed Squad UI extension from Scenario 5 table, kept Spec Kit companion (optional) + Docker/colima + Python + psql.
- Updated `examples/etl-climate-pipeline/README.md`: simplified structure, emphasized "follow the scenario guide step-by-step" approach, no per-phase detail.

**Structural Changes (per directive):**
1. **Step 0**: Test source endpoints (curl -sI, head -3). Brief, no fluff.
2. **Step 1**: Stand up target DB. Pre-scaffolded docker-compose.yml + init.sql (no long compose/sql pastes). Show connection string.
3. **Step 2**: Switch to Squad custom agent in Chat, hire team (example prompt mirrors user's original request: greenfield ETL, spec contract, one member per speckit custom agent, Lead orchestrates, implement member orchestrates core team, add Skills Manager). Review roster before confirming.
4. **Step 3**: Initialize Spec Kit (specify init --here --ai copilot).
5. **Step 4**: Run Spec Kit process (one prompt) → STOP for spec validation.
6. **Step 5**: Validate specs (2-3 bullets).
7. **Step 6**: Implement (one prompt) → Lead distributes to core team.
8. **Step 7**: Validate pipeline (psql queries).
9. **Troubleshooting**: 4-5 one-liners max.
10. **What you learned**: 3-4 tight bullets (two-prompt orchestration, verified-source discipline, spec-first, real persistence).

**Accuracy Maintained:**
- No fabricated extension IDs (referenced Spec Kit companion by marketplace search only).
- Example prompt exactly matches directive (greenfield ETL, spec contract, one member per speckit agent, Lead, Implement member orchestrates core team, Skills Manager using find-skills/skill-creator, two datasets → PostgreSQL).
- Colima documented for macOS Docker runtime (brew install colima docker, colima start).

**Supporting Files Updated:**
- `.squad/agents/mouse/history.md`: appended learning entry.
- `docs/prerequisites.md`: removed Squad UI extension.
- `examples/etl-climate-pipeline/README.md`: concise, mirrors scenario guide.

**Outcome:**
Scenario 5 is now concise, matches the tone/length of Scenario 3 & 4, uses real Copilot Chat Squad agent workflow, and highlights the two-prompt orchestration pattern that embodies SDD discipline.

## Governance

- All meaningful changes require team consensus
- Document architectural decisions here
- Keep history focused on work, decisions focused on direction
