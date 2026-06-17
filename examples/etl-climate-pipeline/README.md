# ETL Climate Pipeline (Scenario 5 sample)

This is the self-contained example folder for **Scenario 5 — Greenfield ETL Pipeline with Squad + Spec Kit**.

See the full scenario guide: [../../docs/scenario-5-speckit-etl-pipeline.md](../../docs/scenario-5-speckit-etl-pipeline.md)

## Structure

This folder contains:

- `docker-compose.yml` — PostgreSQL 16 container
- `init.sql` — target schema and three tables (co2_emissions, population, country_metrics)
- `.env.example` — connection string and dataset URLs
- `data/` — placeholder for downloaded CSVs

**Important:** You **create your own Squad for this scenario** by running `squad init` in this folder during the scenario (see Step 3 of the scenario guide). This creates a folder-scoped `.squad/` isolated from the repo-root Squad (which is for extending the SDD mini-hacks themselves). The two squads never conflict because they are in separate folders.

## Quick Start

1. **Follow the scenario guide** step-by-step. You'll:
   - Create your own folder-scoped Squad via `squad init`
   - Prompt the Squad coordinator for a crystal-clear team
   - Run the Spec Kit lifecycle: constitution → specify → clarify → plan → tasks → analyze → checklist → skills → implement → validate

2. **Start the database** (Step 2):
   ```bash
   # macOS only: start colima first
   colima start
   
   # Then start PostgreSQL
   docker compose up -d
   ```

3. **Note:** `pipeline.py` is built **during the scenario** (not pre-made). The Squad orchestrates the full Spec Kit lifecycle to produce it.

## Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | PostgreSQL 16 container |
| `init.sql` | Target schema + 3 tables |
| `.env.example` | Connection string + dataset URLs |
| `data/` | Download target for CSVs |
| `.squad/` | Created by you during Step 3 (folder-scoped, isolated squad) |
