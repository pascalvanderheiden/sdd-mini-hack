# Work Routing

How to decide who handles what in this dedicated build squad.

## Spec Kit Lifecycle Orchestration (ETL Pipeline)

Neo (Lead) orchestrates the full Spec Kit lifecycle by invoking each phase member in order. Each member produces the artifact for the speckit prompt they mirror. The implement member (Seraph) orchestrates the CORE team to build.

| Order | Phase / Spec Kit command | Owner | Produces |
|-------|--------------------------|-------|----------|
| 0 | Setup — `specify init`, Docker/Postgres, prereqs | 🔧 Tank | `.specify/`, `docker-compose.yml`, `init.sql` |
| 1 | `speckit.constitution` | 📜 Morpheus | constitution |
| 2 | `speckit.specify` + `speckit.clarify` | 🔮 Oracle | spec + clarifications |
| 3 | `speckit.plan` | 🗺️ Niobe | technical plan |
| 4 | `speckit.tasks` + `speckit.analyze` | 🧩 Dozer | task list + analysis |
| 5 | `speckit.checklist` (readiness gate) | ✅ Cypher | quality checklist |
| 6 | Skills provisioning (`find-skills` / `skill-creator`) | 🧰 Link | needed skills available |
| 7 | `speckit.implement` (orchestrates core team) | 🛠️ Seraph → Tank/Trinity/Switch | working pipeline |
| 8 | End-to-end validation | 🧪 Switch | verified data in PostgreSQL |

**Rules for this lifecycle:**
1. Phases run in order; each phase reads the upstream artifacts. Neo gates each handoff.
2. Cypher's checklist is a hard gate — Seraph does NOT start implementation until it passes.
3. Link provisions skills AFTER the checklist gate and BEFORE Seraph implements.
4. During implement, Seraph delegates: Tank (infra/tooling), Trinity (pipeline code), Switch (tests). Seraph never forces all the work onto one agent.
