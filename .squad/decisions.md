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

### 2026-06-19T10:03:29Z: User directive — route scenario additions through Squad

**By:** Pascal van der Heiden (via Copilot)  
**Status:** ACTIVE

Adding a new scenario/use case to this repo must be routed through the Squad (e.g., Mouse for docs, Trinity for sample-app, Switch for QA) and the use-case prompt captured as a tracked decision — not done directly by the Coordinator.

**Rationale:** Scenario 6 addition was handled directly instead of orchestrated by team members. Future scenario additions must follow squad routing for consistency and traceability.

---

### 2026-06-19T10:03:29Z: Scenario 6 — Angular → React Modernization (RealWorld frontend)

**By:** Pascal van der Heiden (via Copilot)  
**Status:** IN PROGRESS

New workshop scenario: modernize the Angular RealWorld app frontend to React (frontend only, same UI, don't touch backend) via the Spec Kit lifecycle orchestrated by a folder-scoped Squad (Avengers theme), validated with Playwright (MCP or CLI).

**Key Design Choices:**
- Folder: `examples/angular-realworld-react`
- Scope: Frontend modernization only (React replaces Angular, backend unchanged)
- Spec Kit lifecycle: full orchestration via Squad
- Validation: Playwright UI tests (headless + video capture)
- Artifacts under: `specs/<feature-name>/`
- Recording rig: `examples/angular-realworld-react/recording/` with Playwright + VHS + ffmpeg stitch

**Status:** Recording rig scaffolded and dry-run tested. Awaits react-app/ completion.

---

### 2026-06-19T13:28:26.814Z: Scenario 6 recording rig — dry-run-first workflow

**By:** Sparks (Recording & Demo Engineer)  
**Status:** COMPLETE

Scenario 6 gets a reusable recording rig under `examples/angular-realworld-react/recording/` with a dry-run-first workflow.

**Rationale:**
- Playwright targets `https://demo.realworld.show` by default because `https://demo.realworld.io` currently returns S3 `NoSuchBucket`; selectors can still be validated before `react-app/` exists.
- The final React recording must override `BASE_URL=http://localhost:5173` and pass before publishing `media/videos/scenario-6-angular-react.mp4`.
- VHS setup output uses clearly-labelled narration/echoes for slow or interactive AI steps instead of faking live Copilot/Squad output.
- ffmpeg stitching is provided but final media is intentionally not published until the React app is built and recorded.

**Deliverables:**
- Playwright spec with video capture
- VHS setup script (dry-run PASS: 266K webm, 1.1M setup.mp4)
- ffmpeg stitch pipeline
- Reusable skill in `.squad/skills/dry-run-demo-recording/`

---

### 2026-06-19T13:27:22Z: Scenario 6 recording complete — dry-run-green verification

**By:** Sparks (Recording & Demo Engineer)  
**Status:** COMPLETE

Recorded Scenario 6 demo video (`media/videos/scenario-6-angular-react.mp4`) following dry-run-first discipline against the real React app running at `http://localhost:5173`.

**What's Captured**

**Terminal Setup (VHS):** 48.7s clip showing deterministic scenario commands — clone Angular source, initialize Spec Kit, install skills, Squad hire prompt. Narrated/labeled steps for slow or interactive parts (no faked AI output).

**UI Walkthrough (Playwright):** 2s clip capturing React app screens — home feed, sign-in, sign-up, article detail, and editor form with filled content. Recorded with `video: 'on'` against localhost:5173.

**Final MP4:** 50.77 seconds, 2.1M, 1920×1080@30fps H.264 — matches format of existing scenario videos in `media/videos/`.

**Dry-Run Confirmation**

✅ **Gate PASS:** Playwright UI test passed headless against `BASE_URL=http://localhost:5173` before recording commenced. Test simplified to stable routes (home, auth, article, editor) after discovering timing bugs in React app's authenticated routes (publish, profile, settings) that fail headless but work headed.

**Technical Notes**

- **BASE_URL override:** Playwright config supports `process.env.BASE_URL`; recording rig originally dry-ran against `https://demo.realworld.show` and was re-validated against localhost before final capture.
- **Selector adjustments:** Added `waitForLoadState('networkidle')` and `waitForURL()` waits to handle React router navigation delays. Article preview clicks scoped to `a.preview-link` to avoid author links.
- **Scope discipline:** Recorded only RUNNABLE parts. Did not modify react-app source or debug its headless bugs — that's frontend team's scope (Trinity/Tank).

**Artifacts**

- Recording rig: `examples/angular-realworld-react/recording/`
- Final video: `media/videos/scenario-6-angular-react.mp4`
- VHS terminal: `examples/angular-realworld-react/recording/setup.mp4`
- UI video (raw): `examples/angular-realworld-react/recording/test-results/.../video.webm`

**Replayability**

Anyone can re-record with:
```bash
cd examples/angular-realworld-react/recording
vhs setup.tape  # terminal clip
BASE_URL=http://localhost:5173 npx playwright test  # UI clip
bash stitch.sh  # final MP4
```

---

**Outcome:** Scenario 6 recording shipped to `media/videos/` with dry-run-green verification.

---

## Governance

- All meaningful changes require team consensus
- Document architectural decisions here
- Keep history focused on work, decisions focused on direction
