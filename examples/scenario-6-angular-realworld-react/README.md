# Angular → React Modernization (Scenario 6 sample)

This is the self-contained working folder for **Scenario 6 — Angular → React Modernization with Squad + Spec Kit**.

See the full scenario guide: [../../docs/scenario-6-speckit-angular-react.md](../../docs/scenario-6-speckit-angular-react.md)

## Quick Start

1. **Follow the scenario guide** step-by-step. You'll:
   - Clone the source Angular app for reference (the UI you must reproduce)
   - Initialize Spec Kit and a folder-scoped Squad (Avengers theme)
   - Run the Spec Kit lifecycle via two prompts: (1) spec phase, (2) implement phase
   - Build a React port of the frontend and validate it with Playwright (MCP or CLI)

2. **Clone the source app** (Step 0), into this folder:
   ```bash
   cd examples/scenario-6-angular-realworld-react
   git clone https://github.com/realworld-apps/angular-realworld-example-app.git angular-source
   ```

3. **Note:** the React app (`react-app/`) is built **during the scenario** (not pre-made). The Squad orchestrates the Spec Kit lifecycle to produce it.

## Structure

This folder contains:
- `README.md` — this file
- `.gitignore` — ignores the cloned Angular source, the generated React app, and build output

Created by you during the scenario:
- `angular-source/` — the cloned Angular RealWorld app (reference only, frontend you must match)
- `react-app/` — the new React frontend the Squad builds
- `specs/<feature-name>/` — Spec Kit artifacts (constitution, spec, plan, tasks)
- `.specify/` — Spec Kit scaffolding (from `specify init .`)
- `.squad/` — folder-scoped, isolated squad (from `squad init`)

## Scope

- **Frontend only.** Port the Angular UI to React **as-is** — same screens, same layout, same flows.
- **Do not touch the backend.** The RealWorld frontend talks to the public RealWorld API; keep using it.
