# Scenario 5 — Greenfield ETL Pipeline with Squad + Spec Kit

Execute the **complete Spec Kit lifecycle** orchestrated by **Squad**, landing two public climate datasets into a local PostgreSQL container.

**Time:** ~60 minutes  
**Tooling:** GitHub Copilot CLI (Squad custom agent) + Spec Kit + Docker + Python 3.12+ + PostgreSQL

## Prereqs

See [docs/prerequisites.md](prerequisites.md). Key for this scenario:
- GitHub Copilot CLI signed in: `brew install --cask copilot-cli` (macOS) or `npm install -g @github/copilot@latest`.
- Docker — **Docker Desktop** (most users) or **colima** (macOS CLI alternative: `brew install colima docker`, then `colima start`).
- Python 3.12+ & uv: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Spec Kit: `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` & `specify check`
- Optional: psql client.
- **Squad CLI**: `npm install -g @bradygaster/squad-cli`

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
docker-compose up -d
docker-compose ps
pg_isready -h localhost -U etl -d climate_db
```

Connection string: `postgresql://etl:etl_workshop@localhost:5432/climate_db`

## Step 2 — Initialize Spec Kit

Open a terminal and `cd` into the example folder (if you aren't already there from Step 1):

```bash
cd examples/etl-climate-pipeline
```

Initialize Spec Kit **first** — it creates the `/speckit.*` commands and the speckit custom agent definitions in `.github/agents` that the Squad needs to reference:

```bash
specify init .
```

When prompted, choose **Copilot** as the AI agent and your **terminal** choice. This creates `.specify/`, registers `/speckit.*`, and writes the `speckit.*.agent.md` definitions under `.github/agents`.

## Step 3 — Install the skills tooling

The Skills Manager uses **find-skills** and **skill-creator** to give the team the capabilities it needs. Install both into this project so the Squad can use them:

```bash
npx skills add https://github.com/vercel-labs/skills --skill find-skills
npx skills add https://github.com/anthropics/skills --skill skill-creator
```

`find-skills` discovers skills from the open ecosystem; `skill-creator` scaffolds new ones when nothing suitable exists.

## Step 4 — Initialize Squad and hire the team

Scaffold a **folder-scoped** Squad, then start the GitHub Copilot CLI with the Squad agent:

```bash
squad init
copilot --agent squad --yolo
```

In the Copilot CLI session, send one prompt to hire the team:

```
Set up a Squad to build a greenfield ETL pipeline with Spec Kit, scoped to this folder. We build the pipeline green-field: spec the contract, then the agents build the pipeline.

The team needs:
- A core team with the members needed to build the pipeline.
- One extra squad member for every speckit custom agent definition present in the .github/agents folder.
- The squad lead orchestrates the speckit method, invoking each speckit squad member at the right time.
- The member that follows the speckit.implement.agent.md directive orchestrates the core team to do the development.
- One extra squad member to manage skills, using find-skills or skill-creator, to give the team the capabilities they need to execute this task before they implement.

Keep all Spec Kit artifacts in the standard location under specs/<feature-name>/ (not inside .squad) so the work stays trackable.

The use case: combine two public open datasets and land them in the local PostgreSQL container.
```

Review the proposed roster and confirm before proceeding.

## Step 5 — Run the Spec Kit process (one prompt) and stop for validation

The Squad Lead runs the entire upstream lifecycle from a **single prompt**. Give it the concrete use case so the spec is grounded in real data:

```
Lead, run the Spec Kit process for this ETL pipeline, then stop so I can validate the specs before implementation.

Use case: build a Python pipeline that combines two public datasets and loads them into the local PostgreSQL "climate" schema (already created by init.sql with tables co2_emissions, population, country_metrics).

Source 1 — OWID CO₂ (CC-BY-4.0):
https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv
columns include country, year, iso_code, co2, co2_per_capita, population.

Source 2 — Datahub population (PDDL):
https://raw.githubusercontent.com/datasets/population/main/data/population.csv
columns: Country Name, Country Code (ISO-3), Year, Value.

Requirements:
- Download both CSVs, normalize column names and types, drop rows without an ISO-3 code.
- Load co2_emissions from Source 1 and population from Source 2.
- Build country_metrics by joining the two on iso_code + year (CO₂ totals/per-capita alongside population).
- Idempotent loads (safe to re-run), use bulk COPY/insert, and connect via postgresql://etl:etl_workshop@localhost:5432/climate_db.

Create the constitution, the spec, the plan, and the tasks, and have the Skills Manager find the skills we need (e.g. Postgres loading, CSV/ETL, data validation). Write all Spec Kit artifacts to the standard Spec Kit location under specs/<feature-name>/ (not inside .squad).
```

The Lead distributes to the phase members. You get **constitution, spec, plan, tasks**, and a skills list. Review before continuing.

## Step 6 — Validate the specs

- Review **constitution** for principles (data sources, normalization, year range, load target).
- Review **spec** for data model (column mappings, join strategy, schema).
- Review **plan** for architecture (download → normalize → join → COPY-load).
- Review **tasks** for breakdown and dependencies.

Refine by replying to the Lead if needed. Otherwise, proceed.

## Step 7 — Implement (one prompt)

Once specs are validated, send:

```
Specs look good. Lead, kick off the implementation in one go following the Spec Kit implement pattern, distributing the tasks to the core team. Build the pipeline and load both datasets into PostgreSQL.
```

The Implement-phase member orchestrates the core team (database setup, pipeline code, tests) to build `examples/etl-climate-pipeline/pipeline.py` and load the data.

## Step 8 — Validate the pipeline

Run the pipeline (if not already done):

```bash
docker-compose ps
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
- **Port 5432 in use** → `docker-compose down` or `lsof -i :5432` to find the process.
- **`specify` not found** → `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` and restart terminal.
- **Squad agent not in picker** → Ensure `.github/agents/squad.agent.md` exists.

## What you learned

✓ **Squad orchestrates the full Spec Kit lifecycle** from two prompts: (1) spec, (2) implement. No per-phase manual stepping.

✓ **Verified-source & verified-database-first discipline**: test endpoints and stand up the target schema *before* writing ETL code.

✓ **Spec-first greenfield ETL**: contract (spec) drives implementation. Lead gates handoffs; Checklist enforces quality.

✓ **Real persistence**: local PostgreSQL demonstrates how SDD applies to systems with side effects (databases, networks).
