# ETL Climate Pipeline (Scenario 5 sample)

This is the self-contained example folder for **Scenario 5 — Greenfield ETL Pipeline with Squad + Spec Kit**.

See the full scenario guide: [../../docs/scenario-5-speckit-etl-pipeline.md](../../docs/scenario-5-speckit-etl-pipeline.md)

## Structure

This folder contains:

- `docker-compose.yml` — PostgreSQL 16 container
- `init.sql` — target schema and three tables (co2_emissions, population, country_metrics)
- `.env.example` — connection string and dataset URLs
- `data/` — placeholder for downloaded CSVs
- `.squad/` — **Dedicated Squad for this scenario**, isolated from the repo-root `.squad/`

**Important:** This scenario has its **own Squad** living at `examples/etl-climate-pipeline/.squad/`, separate from the repo-root Squad (which is for extending the SDD mini-hacks themselves). Open **this folder** (`examples/etl-climate-pipeline`) in VS Code with the SquadUI extension so the dedicated squad is active.

## Quick Start

1. **Start the database:**
   ```bash
   docker compose up -d
   ```

2. **Follow the scenario guide** to run the Spec Kit lifecycle via the dedicated Squad: constitution → specify → clarify → plan → tasks → analyze → checklist → skills → implement → validate.

3. **Note:** `pipeline.py` is built **during the scenario** (not pre-made). The Squad orchestrates the full Spec Kit lifecycle to produce it.

## Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | PostgreSQL 16 container |
| `init.sql` | Target schema + 3 tables |
| `.env.example` | Connection string + dataset URLs |
| `data/` | Download target for CSVs |
| `.squad/` | Dedicated Squad for this scenario |
