# Scenario 2 — Brownfield Feature with Copilot Plan Mode

Add a feature to the included **Bookshelf** sample app and validate the result with Playwright MCP.

**Time:** ~45 minutes  
**Tooling:** GitHub Copilot Chat (Plan mode → Agent mode) + Playwright MCP

## Prereqs

- VS Code with GitHub Copilot + Copilot Chat signed in.
- Node.js 20.19+.

## Step 1 — Run the existing app

```bash
cd examples/bookshelf-app
npm install
npm start
```

Open <http://localhost:4173>.

Click around: list books, add a book, mark as **Read** / **Reading** / **Want to read**, delete a book. The app stores books in `examples/bookshelf-app/data/books.json`.

## Step 2 — Switch Copilot Chat to Plan Mode

In VS Code:

1. Open **Copilot Chat**.
2. Switch the mode dropdown from **Agent** to **Plan**.
3. Make sure the workspace is `sdd-mini-hack` so Copilot can see `examples/bookshelf-app`.

## Step 3 — Ask for a plan (do not implement yet)

Send this prompt in Plan Mode:

```text
Analyze examples/bookshelf-app. Do not change code yet.

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

## Step 4 — Implement the approved plan

Switch Copilot Chat back to **Agent mode** and send:

```text
Implement the approved plan for the "Reading progress" feature in small steps.
Preserve existing data/books.json. After each step, tell me what changed and how to validate it.
```

Restart `npm start` if Copilot did not.

## Step 5 — Validate with Playwright MCP

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
- Add a Playwright test file under `examples/bookshelf-app/tests/`.

## Troubleshooting

- Port 4173 in use → set `PORT=4180 npm start`.
- Plan Mode is missing → update VS Code and the GitHub Copilot Chat extension.
- Playwright MCP fails → run `npx playwright install chromium` once.
