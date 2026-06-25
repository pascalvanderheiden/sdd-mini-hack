# Scenario 1 — Greenfield Todo App with OpenSpec

Build a tiny todo app from a spec, then validate it with Playwright MCP.

**Time:** ~45 minutes  
**Tooling:** OpenSpec + GitHub Copilot Chat (Agent mode) + Playwright MCP

## Prereqs

See the consolidated prerequisites guide: [docs/prerequisites.md](prerequisites.md).

- VS Code with GitHub Copilot + Copilot Chat signed in.
- Node.js 20.19+.
- OpenSpec: `npm install -g @fission-ai/openspec@latest`.

## Step 1 — Open the scenario folder

This scenario runs from its example folder in the repo (everything you create stays scoped here):

```bash
cd examples/scenario-1-openspec-todo
code .
```

Open a terminal in this folder for the next steps.

## Step 2 — Initialize OpenSpec

```bash
openspec init
```

When prompted **"Which AI tools do you use?"**, select **GitHub Copilot**.

## Step 3 — Create the proposal

Open **Copilot Chat → Agent mode** and send:

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

Review the generated `openspec/changes/<change-id>/` files: `proposal.md`, `tasks.md`, and the spec deltas. Ask Copilot to simplify if anything looks too big.

## Step 4 — Apply the proposal

In Copilot Chat:

```text
/openspec-apply-change
```

Approve when asked. Copilot will create the project files and tasks.

## Step 5 — Run the app

Ask Copilot:

```text
Show me the exact command to start the app and the URL to open.
```

Run it (typically `npm start`) and open the URL it prints.

## Step 6 — Validate with Playwright MCP

Still in **Copilot Chat → Agent mode**, send:

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

Copilot will drive a real browser through Playwright MCP and report results.

## Step 7 — Archive the change

```text
/openspec-archive
```

This locks in the spec, so the next change starts from a clean baseline.

## Optional stretch goals

- Add a "Clear completed" button (new proposal).
- Add a due-date field.
- Generate a Playwright spec file (`tests/todo.spec.ts`) so validation runs from CLI.

## Troubleshooting

- `openspec` not found → `npm install -g @fission-ai/openspec@latest`.
- Copilot does not see slash commands → run `openspec update` and reload VS Code.
- Playwright MCP fails to launch → run `npx playwright install chromium` once.
