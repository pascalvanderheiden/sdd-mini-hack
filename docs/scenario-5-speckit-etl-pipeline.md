# Scenario 5 — Greenfield ETL Pipeline with Squad + Spec Kit

Execute the **complete Spec Kit lifecycle** orchestrated by **Squad**, landing two public climate datasets into a local PostgreSQL container.

**Time:** ~60 minutes  
**Tooling:** Squad (Copilot CLI) + Spec Kit + Docker + Python 3.12+ + PostgreSQL

## Prereqs

See the consolidated prerequisites guide: [docs/prerequisites.md](prerequisites.md).

- VS Code with GitHub Copilot + Copilot Chat signed in.
- GitHub Copilot CLI installed (`copilot --help`).
- Squad: `npm install -g @bradygaster/squad-cli` (`squad doctor`).
- **Docker** with docker compose (`docker --version`, `docker compose version`).
- **Python 3.12+** and **uv**:
  - `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **Spec Kit**:
  - `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`
  - `specify check`
- **psql client** (optional but recommended for validation):
  - macOS: `brew install postgresql@16`
  - Linux: `sudo apt-get install -y postgresql-client`

## Step 0 — Verify source dataset endpoints (REQUIRED)

Never build an ETL on an endpoint you haven't verified. Test both data sources first.

**Dataset A — OWID CO₂ Emissions (CC-BY-4.0, ~6 MB CSV)**

```bash
curl -sI https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv
```

Healthy response:

```
HTTP/2 200
content-type: text/plain; charset=utf-8
```

Verify headers:

```bash
curl -s https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv | head -5
```

Expected columns include: `country, year, iso_code, co2, co2_per_capita, gdp, population, ...` (and others).

**Dataset B — Datahub Population (PDDL public domain, ~1 MB CSV)**

```bash
curl -sI https://raw.githubusercontent.com/datasets/population/main/data/population.csv
```

Healthy response:

```
HTTP/2 200
content-type: text/plain; charset=utf-8
```

Verify headers:

```bash
curl -s https://raw.githubusercontent.com/datasets/population/main/data/population.csv | head -5
```

Expected columns: `Country Name, Country Code, Year, Value`

> Both endpoints return 200 with CSV rows? Proceed to Step 1. Otherwise, fix network access or use a local copy of the data.

## Step 1 — Set up the target database

**Owner: 🔧 Tank** (Phase 0 — Setup)

Stand up and verify PostgreSQL before writing any pipeline code.

**Create the folder:**

```bash
mkdir -p examples/etl-climate-pipeline
cd examples/etl-climate-pipeline
```

**Create `docker-compose.yml`:**

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: etl
      POSTGRES_PASSWORD: etl_workshop
      POSTGRES_DB: climate_db
      POSTGRES_INITDB_ARGS: "-c max_connections=50"
    ports:
      - "5432:5432"
    volumes:
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U etl"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - climate_net

volumes:
  pgdata:

networks:
  climate_net:
    driver: bridge
```

**Create `init.sql` (target schema + 3 tables):**

```sql
CREATE SCHEMA IF NOT EXISTS climate;

-- 1. CO2 emissions (source A)
CREATE TABLE climate.co2_emissions (
    id SERIAL PRIMARY KEY,
    iso_code VARCHAR(3),
    year INTEGER,
    country VARCHAR(255),
    co2 NUMERIC,
    co2_per_capita NUMERIC,
    gdp NUMERIC,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Population (source B)
CREATE TABLE climate.population (
    id SERIAL PRIMARY KEY,
    iso_code VARCHAR(3),
    country_name VARCHAR(255),
    year INTEGER,
    value BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Materialized join (computed metrics)
CREATE TABLE climate.country_metrics (
    id SERIAL PRIMARY KEY,
    iso_code VARCHAR(3),
    country_name VARCHAR(255),
    year INTEGER,
    co2_mt NUMERIC,
    population BIGINT,
    co2_per_capita_check NUMERIC,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for join queries
CREATE INDEX idx_co2_iso_year ON climate.co2_emissions(iso_code, year);
CREATE INDEX idx_pop_iso_year ON climate.population(iso_code, year);
CREATE INDEX idx_metrics_iso_year ON climate.country_metrics(iso_code, year);
```

**Start the database:**

```bash
docker compose up -d
```

**Verify readiness:**

```bash
docker compose ps
pg_isready -h localhost -U etl -d climate_db
```

Both should show "accepting connections".

**Test a psql connection (if psql is installed):**

```bash
psql -h localhost -U etl -d climate_db -c "SELECT version();"
```

When prompted, enter password: `etl_workshop`

> Database running and healthy? Move to Step 2.

## Step 2 — Meet your Squad

The Squad team orchestrates the full Spec Kit lifecycle. Each member owns one phase, producing the artifact that mirrors the Spec Kit prompt.

**Spec Kit Lifecycle Orchestration — Squad Member Assignments:**

| Phase | Spec Kit Command | Squad Member | Role |
|-------|------------------|--------------|------|
| 0 | Setup | 🔧 Tank | infra, Docker, Spec Kit init |
| 1 | Constitution | 📜 Morpheus | principles & guardrails |
| 2 | Specify + Clarify | 🔮 Oracle | requirements & data model |
| 3 | Plan | 🗺️ Niobe | technical architecture |
| 4 | Tasks + Analyze | 🧩 Dozer | task breakdown & analysis |
| 5 | Checklist | ✅ Cypher | quality gate |
| 6 | Skills provisioning | 🧰 Link | install find-skills, provision capabilities |
| 7 | Implement | 🛠️ Seraph | orchestrates Tank/Trinity/Switch to build |
| 8 | Validation | 🧪 Switch | end-to-end tests, data verification |

**Key insights:**

- `/speckit.*` commands are interactive Copilot Chat directives. Each Squad member follows the equivalent speckit prompt and produces its artifact.
- **Neo (Lead)** sequences the phases, gates each handoff, and ensures artifacts feed into the next phase.
- **Cypher's checklist is a hard gate** — no implementation starts until it passes.
- **Link must provision skills BEFORE Seraph begins implementation.**

## Step 3 — Initialize Spec Kit

From `examples/etl-climate-pipeline`:

```bash
specify init --here --ai copilot
```

Accept the defaults. This creates `.specify/` and registers `/speckit.*` slash commands.

## Step 4 — Constitution (Morpheus)

In **Copilot Chat → Agent mode**, send:

```text
Neo, I'm Morpheus. Let's draft the constitution for this ETL pipeline.

Principles for the climate data ETL:
- Download OWID CO₂ data and Datahub Population data from public endpoints (no authentication).
- Normalize ISO-3166-alpha-3 country codes across both datasets.
- Filter to years 2000–2023.
- Join on (iso_code, year) and compute co2_per_capita_check = co2_mt*1e6/population as a validation field.
- Load into PostgreSQL 16 local container, schema "climate", three tables: co2_emissions, population, country_metrics.
- Python 3.12+ (stdlib csv + psycopg binary protocol, no pandas).
- Single entry point: python pipeline.py after docker compose up.
- Testable: validate row counts and join integrity in a run-test suite.
```

**Morpheus produces:** `constitution` artifact in `.specify/`.

## Step 5 — Specify + Clarify (Oracle)

In Copilot Chat:

```text
Oracle here. Let's specify and clarify the ETL.

/speckit.specify

Read the constitution. Download each dataset endpoint (curl) and inspect the raw CSV:
- OWID: https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv
- Datahub: https://raw.githubusercontent.com/datasets/population/main/data/population.csv

Derive the data model:
- Column mappings for each source.
- Normalization rules (how to map country names → ISO codes).
- Join strategy (year + iso_code).
- Materialized country_metrics table schema.

Then:

/speckit.clarify

Address open questions:
- How do we handle countries with missing data in either source?
- What happens if year ranges don't overlap?
- Should the pipeline be idempotent (truncate & reload each run)?
```

**Oracle produces:** `specification` and `clarifications` artifacts.

## Step 6 — Plan (Niobe)

In Copilot Chat:

```text
Niobe here. Let's plan the technical approach.

/speckit.plan

Given the spec:
- Architecture: download → normalize → join → COPY-load.
- Python modules: urllib or requests (choose one), csv stdlib, psycopg.
- Entry point: pipeline.py with a main() function.
- Config: connection string from environment (fallback to localhost defaults).
- Error handling: graceful exit on download/parse/DB failures.
- Deliverables: pipeline.py, config.py (or inline secrets), simple test harness.
```

**Niobe produces:** `plan` artifact.

## Step 7 — Tasks + Analyze (Dozer)

In Copilot Chat:

```text
Dozer here. Let's break down the work and analyze it.

/speckit.tasks

Create a task list (small, ordered):
1. Download OWID CSV, parse, normalize ISO codes.
2. Download Datahub CSV, parse, normalize ISO codes.
3. Filter both to year range 2000–2023.
4. Join on (iso_code, year), compute metrics.
5. Establish DB connection and create tables (schema already exists).
6. COPY-load co2_emissions table.
7. COPY-load population table.
8. Materialize country_metrics join.
9. Write smoke tests (row counts, sample queries).

Then:

/speckit.analyze

- What are the top risks? (endpoint downtime, encoding mismatches, NULL handling)
- What's the longest pole? (likely download + join compute time)
- Any dependencies between tasks? (schema must exist before COPY)
```

**Dozer produces:** `tasks` and `analysis` artifacts.

## Step 8 — Checklist (Cypher)

In Copilot Chat:

```text
Cypher here. Quality gate check.

/speckit.checklist

Verify against plan:
☐ Spec is complete (data model, join logic, nullable fields documented).
☐ No external dependencies beyond psycopg (no pandas).
☐ Error handling for network, parsing, DB connection.
☐ Config uses environment variables (DB_HOST, DB_USER, DB_PASS, DB_NAME).
☐ Target tables exist in PostgreSQL (schema "climate").
☐ Entry point is `python pipeline.py` from the folder.
☐ Test suite validates row counts in each table.
☐ CSV download URLs are verified (both return HTTP 200).
```

**Cypher produces:** `checklist` artifact. **All items must pass before proceeding.**

## Step 9 — Skills Provisioning (Link)

In Copilot Chat:

```text
Link here. Installing skills before implementation.

find-skills is currently missing. Let me install it and provision the two skills we need:

1. find-skills — discovery tool for existing skills.
2. postgres-etl — skill for psycopg setup, connection patterns, COPY operations.
3. dataset-ingestion — skill for CSV download, parsing, normalization.

I'll use skill-creator to scaffold both, then Seraph will reference them during implementation.
```

**Link produces:** find-skills installed, `postgres-etl` and `dataset-ingestion` skills registered.

## Step 10 — Implement (Seraph orchestrates Tank/Trinity/Switch)

In Copilot Chat:

```text
Seraph here. Orchestrating implementation.

/speckit.implement

I'm delegating to the core team:
- Tank: database setup (connection pooling, retry logic).
- Trinity: pipeline.py main logic (download, parse, join, load).
- Switch: smoke tests (verify row counts, sample queries).

Each task in order. After each, I'll ask for the code and confirm it runs.
```

**Expected deliverables in `examples/etl-climate-pipeline/`:**

- `pipeline.py` — main ETL script
- `config.py` (or inline config) — DB connection params
- `test_pipeline.py` — smoke tests
- `.specify/` — Spec Kit artifacts
- `docker-compose.yml` + `init.sql` — (already created in Step 1)

**After implementation, test locally:**

```bash
docker compose ps  # Verify DB is running
python pipeline.py
```

Expected output: row counts for each table and validation queries.

## Step 11 — Validation (Switch)

In Copilot Chat:

```text
Switch here. Final validation.

Run the smoke tests:
python test_pipeline.py

Then verify in PostgreSQL:
psql -h localhost -U etl -d climate_db
```

**Sample psql validation queries:**

```sql
-- Check table row counts
SELECT 'co2_emissions' AS table_name, COUNT(*) AS rows FROM climate.co2_emissions
UNION ALL
SELECT 'population', COUNT(*) FROM climate.population
UNION ALL
SELECT 'country_metrics', COUNT(*) FROM climate.country_metrics;

-- Sample join: CO₂ + population for USA in 2023
SELECT c.iso_code, c.country, c.co2, p.value AS population, c.co2_per_capita
FROM climate.co2_emissions c
LEFT JOIN climate.population p ON c.iso_code = p.iso_code AND c.year = p.year
WHERE c.iso_code = 'USA' AND c.year = 2023;

-- Materialized metrics for top CO₂ emitters (2023)
SELECT iso_code, country_name, year, co2_mt, population, co2_per_capita_check
FROM climate.country_metrics
WHERE year = 2023
ORDER BY co2_mt DESC
LIMIT 10;
```

All tables populated and joins working? **Validation complete.**

## Step 12 — Troubleshooting

| Issue | Solution |
|-------|----------|
| `curl` returns 404 on dataset URLs | Re-run Step 0 endpoint checks. Both must return HTTP 200. |
| Port 5432 already in use | `lsof -i :5432` to find the process; `docker compose down` if another container is running. |
| `psycopg` import error | `pip install psycopg[binary]` or `uv pip install psycopg[binary]` |
| `specify` not found | `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` and restart terminal. |
| DB connection refused | Verify `docker compose ps` shows postgres as "Up". Run `pg_isready -h localhost -U etl`. |
| CSV parsing errors | Inspect raw CSV with `curl -s <url> | head -20`. Check for encoding, quoting, or delimiter mismatches. |

## What you learned

✓ **Spec Kit full lifecycle**: constitution → specify → clarify → plan → tasks → analyze → checklist → skills → implement → validate.

✓ **Squad orchestration**: each phase owner (Morpheus, Oracle, Niobe, etc.) produces its artifact, with Neo gating handoffs and Cypher enforcing quality.

✓ **Data-first discipline**: verify source endpoints and target database readiness BEFORE writing ETL code.

✓ **Greenfield ETL patterns**: download + normalize + join + COPY-load with psycopg, minimal external dependencies.

✓ **Real persistence**: local PostgreSQL container demonstrates how SDD applies to systems with side effects (databases, networks).
