# Scenario 2 — Brownfield Feature with Copilot Plan Mode

Add a feature to the included **Bookshelf** sample app and validate the result with Playwright MCP.

**Time:** ~45 minutes  
**Tooling:** GitHub Copilot Chat (Plan mode → Agent mode) + Playwright MCP

## Prereqs

See the consolidated prerequisites guide: [docs/prerequisites.md](prerequisites.md).

- VS Code with GitHub Copilot + Copilot Chat signed in.
- Node.js 20.19+.

## Step 1 — Open the scenario folder

This scenario runs from its example folder in the repo:

```bash
cd examples/scenario-2-bookshelf-app
code .
```

Open a terminal in this folder for the next steps.

## Step 2 — Generate Copilot instructions

Give Copilot project context before you start. In VS Code, open the **Command Palette**
(`Cmd/Ctrl+Shift+P`) and run **Chat: Generate Workspace Instructions File**. Copilot analyzes
the folder and writes `.github/copilot-instructions.md`.

> No command? Open **Copilot Chat → Agent mode** and ask:
> ```text
> Analyze this workspace and generate a .github/copilot-instructions.md that captures the
> stack, structure, conventions, and how to run and test this app.
> ```

Review the generated file and tweak anything that's off — it's loaded automatically into every Copilot request.

## Step 3 — Run the existing app

```bash
npm install
npm start
```

Open <http://localhost:4173>.

Click around: list books, add a book, mark as **Read** / **Reading** / **Want to read**, delete a book. The app stores books in `data/books.json`.

## Step 4 — Switch Copilot Chat to Plan Mode

**Plan Mode** is a built-in GitHub Copilot Chat mode. Instead of editing files right away (like
**Agent mode**), it researches your codebase and produces a step-by-step **implementation plan**
for you to review and refine — no code is changed until you approve. It's ideal for brownfield
work where you want to agree on the approach before touching existing code.

In VS Code:

1. Open **Copilot Chat**.
2. Switch the mode dropdown (top of the Chat view) from **Agent** to **Plan**.
3. The workspace is this folder, so Copilot already sees the bookshelf app.

## Step 5 — Ask for a plan (do not implement yet)

> 📋 **Make sure the Copilot Chat mode dropdown still says _Plan_**, then send the prompt below.
> In Plan Mode, Copilot replies with a plan to review — it will **not** edit any files yet.

```text
Analyze this bookshelf app (you're already in its folder). Do not change code yet.

Feature request: "Reading progress"

Acceptance criteria:
- Each book gains an integer field `pagesRead` (default 0) and `totalPages` (required when status is "reading" or "read").
- The book card shows a progress bar: pagesRead / totalPages.
- Editing a book lets me update pagesRead and totalPages with simple validation (0 <= pagesRead <= totalPages).
- Marking a book as "read" auto-sets pagesRead = totalPages.
- Existing books in data/books.json keep working (treat missing fields as 0/undefined).
- The /api/books endpoint returns the new fields.

Produce a short implementation plan with:
1. Files to change.
2. Data model migration approach.
3. UI changes.
4. Server changes.
5. Manual + Playwright validation steps.
```

Review the plan. Ask Copilot to shrink anything that feels too big.

## Step 6 — Implement the approved plan

Switch Copilot Chat back to **Agent mode** and send:

```text
Implement the approved plan for the "Reading progress" feature in small steps.
Preserve existing data/books.json. After each step, tell me what changed and how to validate it.
```

Restart `npm start` if Copilot did not.

## Step 7 — Validate with Playwright MCP

In Copilot Chat (Agent mode):

```text
Use the Playwright MCP server to validate the running app at http://localhost:4173.

Steps:
1. Add a book "Designing Data-Intensive Applications" with totalPages=600, status=reading, pagesRead=120.
2. Confirm the card shows a progress bar at ~20%.
3. Edit pagesRead to 600 and status to read; confirm progress bar = 100%.
4. Try setting pagesRead=700; confirm a validation error and that the value is rejected.
5. Reload the page; confirm the changes persisted.

Report pass/fail per step.
```

## Optional stretch goals

- Add a "Currently reading" filter.
- Show total pages read across all books.
- Add a Playwright test file under `examples/scenario-2-bookshelf-app/tests/`.

## Troubleshooting

- Port 4173 in use → set `PORT=4180 npm start`.
- Plan Mode is missing → update VS Code and the GitHub Copilot Chat extension.
- Playwright MCP fails → run `npx playwright install chromium` once.
