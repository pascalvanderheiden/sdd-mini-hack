# Scenario 1 — Greenfield Todo App with OpenSpec (scoped example folder)

> Scoped working folder for **Scenario 1**. Run the whole scenario from inside this
> folder so everything stays trackable and isolated.
> Canonical guide (keep in sync): [../../docs/scenario-1-openspec-todo.md](../../docs/scenario-1-openspec-todo.md)

Build a tiny todo app from a spec with **OpenSpec**, then validate it with **Playwright MCP**.

**Time:** ~45 minutes
**Tooling:** OpenSpec + GitHub Copilot Chat (Agent mode) + Playwright MCP

Everything in this scenario is created **from scratch** — this folder starts with only
this `README.md`. The OpenSpec artifacts and app files are generated as you go.

## Prereqs

See the consolidated prerequisites guide: [../../docs/prerequisites.md](../../docs/prerequisites.md).

- VS Code with GitHub Copilot + Copilot Chat signed in.
- Node.js 20.19+.
- OpenSpec: `npm install -g @fission-ai/openspec@latest`.

## Quick Start

1. **Open this folder as your workspace.** Open a terminal here (`examples/scenario-1-openspec-todo`).

2. **Initialize OpenSpec** (scoped to this folder):
   ```bash
   openspec init
   ```
   When prompted **"Which AI tools do you use?"**, select **GitHub Copilot**. Verify:
   ```bash
   ls openspec   # project.md, AGENTS.md, and supporting folders
   ```

3. **Create the proposal.** Open **Copilot Chat → Agent mode** and send:
   ```text
   /openspec-proposal

   I want to build TodoLite, a small browser-based todo app.

   Requirements:
   - Add a todo with a required title.
   - Mark a todo complete or active.
   - Delete a todo.
   - Filter all / active / completed.
   - Persist in localStorage.
   - Plain HTML + CSS + vanilla JS, no build step, no framework.
   - Single page served by a tiny Node http server (npm start).

   Create the OpenSpec change proposal and pause for review.
   ```
   Review `openspec/changes/<change-id>/` (`proposal.md`, `tasks.md`, spec deltas). Ask Copilot to simplify if anything looks too big.

4. **Apply the proposal.** In Copilot Chat: `/openspec-apply-change` — approve when asked.

5. **Run the app.** Ask Copilot for the exact start command and URL, then run it (typically `npm start`).

6. **Validate with Playwright MCP.** In **Copilot Chat → Agent mode**:
   ```text
   Use the Playwright MCP server to validate the running todo app at the URL above.

   Run these checks and report pass/fail:
   1. Page loads with title "TodoLite".
   2. Adding "Buy milk" creates a new todo card.
   3. Submitting an empty title shows an error and adds nothing.
   4. Marking the todo complete moves it under the Completed filter.
   5. Reloading the page keeps the todo (localStorage).
   6. Deleting the todo removes it.
   ```

7. **Archive the change** to lock in the spec: `/openspec-archive`

## Optional stretch goals

- Add a "Clear completed" button (new proposal).
- Add a due-date field.
- Generate a Playwright spec file (`tests/todo.spec.ts`) so validation runs from CLI.

## Scope

- Greenfield: all files are created during the scenario.
- Frontend-only, no framework, no build step. Single Node http server.
- Keep all OpenSpec artifacts under `openspec/` in this folder.

## Troubleshooting

- `openspec` not found → `npm install -g @fission-ai/openspec@latest`.
- Copilot does not see slash commands → run `openspec update` and reload VS Code.
- Playwright MCP fails to launch → run `npx playwright install chromium` once.
