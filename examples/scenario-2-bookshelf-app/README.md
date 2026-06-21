# Scenario 2 — Brownfield Feature with Copilot Plan Mode (scoped example folder)

> Scoped working folder for **Scenario 2**. Run the whole scenario from inside this folder.
> Canonical guide (keep in sync): [../../docs/scenario-2-plan-mode-bookshelf.md](../../docs/scenario-2-plan-mode-bookshelf.md)

Add a **"Reading progress"** feature to the included **Bookshelf** sample app (described
below) using **Copilot Plan Mode**, then validate with **Playwright MCP**.

**Time:** ~45 minutes
**Tooling:** GitHub Copilot Chat (Plan mode → Agent mode) + Playwright MCP

## Prereqs

See the consolidated prerequisites guide: [../../docs/prerequisites.md](../../docs/prerequisites.md).

- VS Code with GitHub Copilot + Copilot Chat signed in.
- Node.js 20.19+.

## Quick Start

1. **Open this folder in VS Code** and open a terminal here:
   ```bash
   cd examples/scenario-2-bookshelf-app
   code .
   ```

2. **Generate Copilot instructions.** Open the **Command Palette** (`Cmd/Ctrl+Shift+P`) and
   run **Chat: Generate Workspace Instructions File** to create `.github/copilot-instructions.md`.
   No command? Ask Copilot Chat (Agent mode): *"Analyze this workspace and generate a
   .github/copilot-instructions.md."* Review the result.

3. **Run the existing app** (from this folder):
   ```bash
   npm install
   npm start
   ```
   Open <http://localhost:4173> and click around: list books, add a book, mark
   **Read** / **Reading** / **Want to read**, delete a book. Data is stored in `data/books.json`.

4. **Switch Copilot Chat to Plan Mode.** Open **Copilot Chat**, switch the mode dropdown
   from **Agent** to **Plan**. The workspace is this folder, so Copilot already
   sees the app.

5. **Ask for a plan (do not implement yet).** Send in Plan Mode:
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

6. **Implement the approved plan.** Switch Copilot Chat back to **Agent mode** and send:
   ```text
   Implement the approved plan for the "Reading progress" feature in small steps.
   Preserve existing data/books.json. After each step, tell me what changed and how to validate it.
   ```
   Restart `npm start` if Copilot did not.

7. **Validate with Playwright MCP.** In Copilot Chat (Agent mode):
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
- Add a Playwright test file under `tests/`.

## Troubleshooting

- Port 4173 in use → set `PORT=4180 npm start`.
- Plan Mode is missing → update VS Code and the GitHub Copilot Chat extension.
- Playwright MCP fails → run `npx playwright install chromium` once.

---

## About the starter app (foundational files)

A tiny reading-list app: list, add, advance status, delete books.

- Node.js HTTP server, no external dependencies.
- Vanilla HTML/CSS/JS, no build step.
- Persists to `data/books.json`.

### Run

```bash
npm install   # nothing to install, but harmless
npm start
```

Open <http://localhost:4173>.

Override the port:

```bash
PORT=4180 npm start
```

### API

- `GET /api/books` — list
- `POST /api/books` — `{ title, author, status? }`
- `PATCH /api/books/:id` — `{ title?, author?, status? }`
- `DELETE /api/books/:id`

`status` is one of `want`, `reading`, `read`.
