# Scenario 5 — Greenfield ETL Pipeline with Squad + Spec Kit

Execute the **complete Spec Kit lifecycle** orchestrated by **Squad**, landing two public climate datasets into a local PostgreSQL container.

**Time:** ~60 minutes  
**Tooling:** VS Code + GitHub Copilot (Squad custom agent) + Spec Kit + Docker + Python 3.12+ + PostgreSQL

## Prereqs

See [docs/prerequisites.md](prerequisites.md). Key for this scenario:
- VS Code + GitHub Copilot + Copilot Chat signed in.
- Docker — **Docker Desktop** (most users) or **colima** (macOS CLI alternative: `brew install colima docker`, then `colima start`).
- Python 3.12+ & uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Spec Kit: `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` & `specify check`
- Optional: Spec Kit companion extension (VS Code), psql client.
- **Squad is already installed as a repo prereq** — you use the Squad custom agent in Copilot Chat to hire your team.

## Step 0 — Test the source endpoints first

Verify both data sources before building the pipeline.

```bash
# OWID CO₂ (CC-BY-4.0)
curl -sI https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv
curl -s https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv | head -3

# Datahub Population (PDDL public domain)
curl -sI https://raw.githubusercontent.com/datasets/population/main/data/population.csv
curl -s https://raw.githubusercontent.com/datasets/population/main/data/population.csv | head -3
```

Both should return **HTTP 200** with CSV headers. If not, check network access or use local copies.

## Step 1 — Stand up the target database

The folder `examples/etl-climate-pipeline/` already has `docker-compose.yml` and `init.sql` (schema "climate" with tables: co2_emissions, population, country_metrics).

Start the container:

```bash
# Make sure Docker is running: start Docker Desktop, or on colima run `colima start`

cd examples/etl-climate-pipeline
docker compose up -d
docker compose ps
pg_isready -h localhost -U etl -d climate_db
```

Connection string: `postgresql://etl:etl_workshop@localhost:5432/climate_db`

## Step 2 — Switch to the Squad custom agent and hire the team

In VS Code, open **Copilot Chat** and select the **Squad** custom agent from the agent dropdown (defined in `.github/agents/squad.agent.md`). Then send one prompt:

```
Set up a Squad to build a greenfield ETL pipeline with Spec Kit, scoped to this folder.

We build the pipeline green-field: spec the contract, then the squad builds it. It's important the squad can execute the Spec Kit process completely. So, next to the core team needed to build the pipeline, add an extra squad member for every Spec Kit custom agent in .github/agents (constitution, specify, clarify, plan, tasks, analyze, checklist, implement). Have the Lead orchestrate the Spec Kit method, invoking each Spec Kit member at the right time. The member that follows speckit.implement should orchestrate the core team to do the development. Add an extra member to manage skills using find-skills or skill-creator, to give the team the capabilities they need before they implement.

Combine two public open datasets and land them in the local PostgreSQL container.
```

Review the proposed roster and confirm before proceeding.

## Step 3 — Initialize Spec Kit

From `examples/etl-climate-pipeline`:

```bash
specify init --here --ai copilot
```

Creates `.specify/` and registers `/speckit.*` commands.

## Step 4 — Run the Spec Kit process (one prompt) and stop for validation

The Squad Lead runs the entire upstream lifecycle from a **single prompt**. Send:

```
Lead, run the Spec Kit process for this pipeline: create the constitution, the spec, the plan, and the tasks, and have the Skills Manager find the skills we need. Then stop so I can validate the specs before implementation.
```

The Lead distributes to phase members. You get **constitution, spec, plan, tasks**, and a skills list. Review before continuing.

## Step 5 — Validate the specs

- Review **constitution** for principles (data sources, normalization, year range, load target).
- Review **spec** for data model (column mappings, join strategy, schema).
- Review **plan** for architecture (download → normalize → join → COPY-load).
- Review **tasks** for breakdown and dependencies.

Refine by replying to the Lead if needed. Otherwise, proceed.

## Step 6 — Implement (one prompt)

Once specs are validated, send:

```
Specs look good. Lead, kick off the implementation in one go following the Spec Kit implement pattern, distributing the tasks to the core team. Build the pipeline and load both datasets into PostgreSQL.
```

The Implement-phase member orchestrates the core team (database setup, pipeline code, tests) to build `examples/etl-climate-pipeline/pipeline.py` and load the data.

## Step 7 — Validate the pipeline

Run the pipeline (if not already done):

```bash
docker compose ps
python pipeline.py
```

Verify in psql:

```bash
psql -h localhost -U etl -d climate_db -c "SELECT count(*) FROM climate.co2_emissions;"
psql -h localhost -U etl -d climate_db -c "SELECT count(*) FROM climate.population;"
psql -h localhost -U etl -d climate_db -c "SELECT iso_code, country_name, year, co2_mt FROM climate.country_metrics LIMIT 3;"
```

Both tables populated? Validation complete.

## Troubleshooting

- **Docker daemon not running** → start Docker Desktop, or run `colima start` (colima users).
- **Endpoint returns 404** → Re-test Step 0; both URLs must return HTTP 200.
- **Port 5432 in use** → `docker compose down` or `lsof -i :5432` to find the process.
- **`specify` not found** → `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` and restart terminal.
- **Squad agent not in picker** → Ensure `.github/agents/squad.agent.md` exists.

## What you learned

✓ **Squad orchestrates the full Spec Kit lifecycle** from two prompts: (1) spec, (2) implement. No per-phase manual stepping.

✓ **Verified-source & verified-database-first discipline**: test endpoints and stand up the target schema *before* writing ETL code.

✓ **Spec-first greenfield ETL**: contract (spec) drives implementation. Lead gates handoffs; Checklist enforces quality.

✓ **Real persistence**: local PostgreSQL demonstrates how SDD applies to systems with side effects (databases, networks).
