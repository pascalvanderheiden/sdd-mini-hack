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

## Governance

- All meaningful changes require team consensus
- Document architectural decisions here
- Keep history focused on work, decisions focused on direction
