# Scenario 6 — Angular → React Modernization with Squad + Spec Kit

Execute the **complete Spec Kit lifecycle** orchestrated by **Squad** to modernize the **Angular RealWorld** app's frontend to **React** — same UI, frontend only — and validate it with **Playwright**.

**Time:** ~75 minutes
**Tooling:** GitHub Copilot CLI (Squad custom agent) + Spec Kit + Node.js 20.19+ + Playwright (MCP or CLI)

## Prereqs

See [docs/prerequisites.md](prerequisites.md). Key for this scenario:
- GitHub Copilot CLI signed in: `brew install --cask copilot-cli` (macOS) or `npm install -g @github/copilot@latest`.
- Node.js 20.19+ (`node --version`).
- **Python 3.12+ & uv** (Spec Kit installs via `uv tool install`): `curl -LsSf https://astral.sh/uv/install.sh | sh` (macOS/Linux) or `powershell -c "irm https://astral.sh/uv/install.ps1 | iex"` (Windows). Restart your terminal, then `uv --version`.
- Spec Kit: `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` & `specify check`
- **Squad CLI**: `npm install -g @bradygaster/squad-cli` (`squad doctor`).
- **Playwright** — MCP is preconfigured (`.mcp.json` / `.vscode/mcp.json`). CLI backup: `npm install -g playwright && npx playwright install chromium`.

## Step 0 — Get the source app (the UI you must reproduce)

Clone the Angular RealWorld app into the scenario folder. This is the **reference frontend** — your React port must match it screen-for-screen.

```bash
cd examples/scenario-6-angular-realworld-react
git clone --recurse-submodules https://github.com/realworld-apps/angular-realworld-example-app.git angular-source
```

> **Submodule required:** the Angular app pulls its **theme/styling from a git submodule** (`realworld`, referenced by `angular.json` as `realworld/assets/theme/styles.css`). `--recurse-submodules` fetches it during the clone. If you already cloned **without** it (the app will look unstyled), initialize it now:
>
> ```bash
> cd angular-source
> git submodule update --init --recursive
> cd ..
> ```

Optionally run it to see the target UI (it talks to the public RealWorld API):

```bash
cd angular-source
npm install
npm start   # serves on http://localhost:4200
```

Browse the app: home feed, sign in / sign up, article view, editor, profile, settings. These are the screens you'll reproduce in React. When done, `cd ..` back to `examples/scenario-6-angular-realworld-react`.

> **Backend note:** RealWorld frontends use a hosted public API. You are modernizing the **frontend only** — do not build or change any backend.

## Step 1 — Initialize Spec Kit

From the scenario folder (`examples/scenario-6-angular-realworld-react`):

```bash
specify init .
```

When prompted, choose **Copilot** as the AI agent and your **terminal** choice. This creates `.specify/`, registers `/speckit.*`, and writes the `speckit.*.agent.md` definitions under `.github/agents`. The Squad creates **one extra member per speckit agent definition** it finds there.

## Step 2 — Install the skills tooling

The Skills Manager uses **find-skills** and **skill-creator** to give the team the capabilities it needs. Install both into this project:

```bash
npx skills add https://github.com/vercel-labs/skills --skill find-skills -y
npx skills add https://github.com/anthropics/skills --skill skill-creator -y
```

`find-skills` discovers skills from the open ecosystem; `skill-creator` scaffolds new ones when nothing suitable exists. The `-y` flag installs to the **Universal** location (`.agents/skills/`, which GitHub Copilot reads) without prompting for agent selection — omit it if you prefer to pick targets interactively.

## Step 3 — Initialize Squad and hire the team

Scaffold a **folder-scoped** Squad, then start the GitHub Copilot CLI with the Squad agent:

```bash
squad init
copilot --agent squad --yolo
```

In the Copilot CLI session, send one prompt to hire the team:

```
Hire a squad that can help me modernize this Angular Application
(https://github.com/realworld-apps/angular-realworld-example-app) to React using the Spec Kit method (https://github.com/github/spec-kit) and test using Playwright MCP or CLI, scoped to this folder.

The team needs:
- A core team with the members needed to build the React frontend (and run Playwright tests).
- One extra squad member for every speckit custom agent definition present in the .github/agents folder.
- The squad lead orchestrates the speckit method, invoking each speckit squad member at the right time.
- The member that follows the speckit.implement.agent.md directive orchestrates the core team to do the development.
- One extra squad member to manage skills, using find-skills or skill-creator. The Skills Manager searches for the skills the team needs right after the constitution and before the spec, so the capabilities are in place before specifying.

Keep all Spec Kit artifacts in the standard location under specs/<feature-name>/ (not inside .squad) so the work stays trackable. Use an Avengers theme for the team's cast names.
```

Review the proposed roster and confirm before proceeding.

## Step 4 — Run the Spec Kit process (one prompt) and stop for validation

The Squad Lead runs the entire upstream lifecycle from a **single prompt**:

```
Lead, run the Spec Kit process to modernize the frontend of this Angular Application
(https://github.com/realworld-apps/angular-realworld-example-app) to React as-is. Don't touch the backend components. I want exactly the same UI.

Run the phases in order: first the constitution, then have the Skills Manager find the skills we need (e.g. React/Vite scaffolding, Angular-to-React component migration, Playwright E2E testing), then the spec, the plan, and the tasks. Write all Spec Kit artifacts to the standard Spec Kit location under specs/<feature-name>/ (not inside .squad).
```

The Lead distributes to the phase members. You get **constitution, spec, plan, tasks**, and a skills list. Review before continuing.

## Step 5 — Validate the specs

- Review **constitution** for principles (frontend-only scope, same UI, same routes, reuse the RealWorld API).
- Review **spec** for the screen/route inventory (home feed, auth, article, editor, profile, settings) and component mapping.
- Review **plan** for architecture (React + Vite, routing, API client, state, Playwright test setup).
- Review **tasks** for the breakdown and dependencies.

Refine by replying to the Lead if needed. Otherwise, proceed.

## Step 6 — Implement (one prompt)

Once specs are validated, send:

```
Specs look good. Lead, kick off the implementation in one go following the Spec Kit implement pattern, distributing the tasks to the core team. Build the React frontend in react-app/ that reproduces the Angular UI exactly, reusing the existing RealWorld API.

As you complete each task, mark it done in specs/<feature-name>/tasks.md. When implementation finishes, write a short test report (Playwright tests run, pass/fail counts, screens covered) to specs/<feature-name>/test-report.md, and a short quickstart.md (in the example folder) with the exact commands to run the React app and the Playwright tests manually.
```

The Implement-phase member orchestrates the core team (scaffolding, components, routing, API client, Playwright tests) to build `examples/scenario-6-angular-realworld-react/react-app/`, **check off the tasks in `tasks.md`**, and produce a short **`test-report.md`** plus a **`quickstart.md`**.

## Step 7 — Validate the React app

You can validate two ways: ask the Squad in the Copilot CLI session, or run the commands yourself.

**Run the React app:**

> Prompt: `Lead, run the React app and confirm it serves the same screens as the Angular source.`

```bash
cd react-app
npm install
npm run dev   # serves the React app (Vite, e.g. http://localhost:3000 — it picks the next free port if 3000 is taken)
```

**Run the Playwright tests:**

> Prompt: `Run the Playwright suite and report pass/fail per screen.`

```bash
npx playwright test
```

**Compare against the Angular source:** open both apps side by side (Angular on `:4200`, React on `:3000`) and confirm the screens match — home feed, sign in/up, article view, editor, profile, settings. The Squad can drive Playwright MCP to walk the flows and report differences.

UI matches and the Playwright suite passes? Validation complete.

## Troubleshooting

- **`uv` not found / Spec Kit install fails** → install uv first: `curl -LsSf https://astral.sh/uv/install.sh | sh` (Windows: `powershell -c "irm https://astral.sh/uv/install.ps1 | iex"`), restart the terminal, then re-run the Spec Kit install. Needs Python 3.12+.
- **`specify` not found** → `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` and restart terminal.
- **Squad agent not in picker** → Ensure `.github/agents/squad.agent.md` exists.
- **No speckit members hired** → Run `specify init .` (Step 1) **before** hiring the squad so `.github/agents/speckit.*.agent.md` exist.
- **Angular app unstyled / missing theme** → the `realworld` submodule wasn't initialized. From `angular-source`, run `git submodule update --init --recursive`.
- **Angular app won't start** → use Node 20.19+, delete `angular-source/node_modules`, re-run `npm install`. Running the source is optional — the cloned code is enough reference.
- **Playwright browsers missing** → `npx playwright install chromium`.
- **Port already in use** → Vite picks the next free port; check the terminal for the actual URL.

## What you learned

✓ **Squad orchestrates the full Spec Kit lifecycle** from two prompts: (1) spec, (2) implement. No per-phase manual stepping.

✓ **Brownfield modernization, spec-first**: the source Angular UI is the contract; the spec captures it before any React code is written.

✓ **Frontend-only discipline**: reuse the existing API, port the UI as-is, leave the backend untouched.

✓ **Validation built in**: Playwright (MCP or CLI) proves the React port reproduces the Angular UI, screen by screen.
