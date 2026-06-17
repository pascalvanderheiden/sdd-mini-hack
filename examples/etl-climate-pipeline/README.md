# ETL Climate Pipeline (Scenario 5 sample)

This is the self-contained example folder for **Scenario 5 — Greenfield ETL Pipeline with Squad + Spec Kit**.

See the full scenario guide: [../../docs/scenario-5-speckit-etl-pipeline.md](../../docs/scenario-5-speckit-etl-pipeline.md)

## Quick Start

1. **Follow the scenario guide** step-by-step. You'll:
   - Switch to the Squad custom agent in Copilot Chat and hire your team
   - Run the Spec Kit lifecycle via two prompts: (1) spec phase, (2) implement phase
   - Build `pipeline.py` and load both datasets into PostgreSQL

2. **Start the database** (Step 1):
   ```bash
   # Make sure Docker is running (Docker Desktop, or `colima start` on colima)
   cd examples/etl-climate-pipeline
   docker compose up -d
   ```

3. **Note:** `pipeline.py` is built **during the scenario** (not pre-made). The Squad orchestrates the Spec Kit lifecycle to produce it.

## Structure

This folder contains:
- `docker-compose.yml` — PostgreSQL 16 container
- `init.sql` — target schema (climate) with three tables: co2_emissions, population, country_metrics
- `.env.example` — connection string and dataset URLs
- `data/` — placeholder for downloaded CSVs
- `.squad/` — Created by you during the scenario (folder-scoped, isolated squad)
