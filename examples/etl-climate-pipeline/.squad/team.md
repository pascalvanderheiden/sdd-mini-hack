# Squad Team

> ETL Climate Pipeline (Scenario 5 — Dedicated Build Squad)

## Coordinator

| Name | Role | Notes |
|------|------|-------|
| Squad | Coordinator | Routes work, enforces handoffs and reviewer gates. |

## Members

| Name | Role | Charter | Status |
|------|------|---------|--------|
| 🏗️ Neo | Lead / SDD Architect | `.squad/agents/neo/charter.md` | active |
| 📜 Morpheus | Constitution Architect — `speckit.constitution` | `.squad/agents/morpheus/charter.md` | active |
| 🔮 Oracle | Requirements Analyst — `speckit.specify` + `speckit.clarify` | `.squad/agents/oracle/charter.md` | active |
| 🗺️ Niobe | Technical Planner — `speckit.plan` | `.squad/agents/niobe/charter.md` | active |
| 🧩 Dozer | Task Engineer — `speckit.tasks` + `speckit.analyze` | `.squad/agents/dozer/charter.md` | active |
| ✅ Cypher | Quality Gatekeeper — `speckit.checklist` | `.squad/agents/cypher/charter.md` | active |
| 🧰 Link | Skills Manager — `find-skills` / `skill-creator` | `.squad/agents/link/charter.md` | active |
| 🛠️ Seraph | Implementation Orchestrator — `speckit.implement` | `.squad/agents/seraph/charter.md` | active |
| ⚛️ Trinity | Sample-App Engineer | `.squad/agents/trinity/charter.md` | active |
| 🔧 Tank | Tooling & Skills Engineer | `.squad/agents/tank/charter.md` | active |
| 🧪 Switch | Tester / QA | `.squad/agents/switch/charter.md` | active |
| 📋 Scribe | Session Logger | `.squad/agents/scribe/charter.md` | active |

## Project Context

- **Owner:** Pascal van der Heiden
- **Project:** ETL Climate Pipeline — Build an ETL pipeline that lands OWID CO₂ + Datahub population data into local PostgreSQL via the full Spec Kit lifecycle.
- **Scope:** **Dedicated build squad** for Scenario 5 example (`examples/etl-climate-pipeline`), **isolated from the repo-root squad** (which is the meta team for extending the SDD mini-hacks).
- **Tooling:** Spec Kit (specify CLI, /speckit.* commands), Squad orchestration, Python + psycopg, PostgreSQL (docker), public open datasets (OWID CO2 + Datahub population).
- **Cast universe:** The Matrix
- **Created:** 2026-06-17
