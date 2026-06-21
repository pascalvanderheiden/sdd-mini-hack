# Scenario 4 — Personal Assistant with Squad + OpenSpec via Copilot CLI (scoped example folder)

> Scoped working folder for **Scenario 4**. Run the whole scenario from inside this
> folder so the Squad and OpenSpec artifacts stay isolated and trackable.
> Canonical guide (keep in sync): [../../docs/scenario-4-cli-squad-assistant.md](../../docs/scenario-4-cli-squad-assistant.md)

Use the **Copilot CLI** with the **Squad** agent. Add a Squad team member that owns
OpenSpec, then have them propose and execute a small personal assistant app (**DayDesk**).

**Time:** ~50 minutes
**Tooling:** GitHub Copilot CLI + Squad + OpenSpec

Everything in this scenario is created **from scratch** — this folder starts with only
this `README.md`. The Squad, OpenSpec artifacts, and app files are generated as you go.

## Prereqs

See the consolidated prerequisites guide: [../../docs/prerequisites.md](../../docs/prerequisites.md).

- GitHub Copilot CLI installed and signed in (`copilot --help`).
- Node.js 20.19+.
- Squad: `npm install -g @bradygaster/squad-cli` (`squad doctor`).
- OpenSpec: `npm install -g @fission-ai/openspec@latest`.
- `gh` CLI signed in (`gh auth status`).

## Quick Start

1. **Open a terminal in this folder** (`examples/scenario-4-cli-squad-assistant`).

2. **Initialize OpenSpec and Squad** (scoped to this folder):
   ```bash
   openspec init      # choose GitHub Copilot when prompted
   squad init
   ls .squad openspec
   ```

3. **Open Copilot CLI with Squad:**
   ```bash
   copilot --agent squad --yolo
   ```
   > `--yolo` skips per-tool approval prompts. Squad makes many calls per session.

4. **Set up the team.** In the CLI session, send:
   ```text
   I'm starting a small personal assistant app called DayDesk.
   Set up a small Squad team for this project.

   Then add a specialized member who manages OpenSpec proposals.

   Show me the proposed roster and wait for my approval.
   ```
   Approve the roster.

5. **Have the Specs member create the proposal:**
   ```text
   Squad, please create an OpenSpec proposal for DayDesk.

   Scope:
   - Capture short notes (add, list, delete).
   - Reminders with a title and due date.
   - "Today" view that shows reminders due today.
   - Persist data in localStorage.
   - Browser app, vanilla HTML/CSS/JS, no framework, single Node http server (npm start).
   - No external APIs, secrets, or auth.

   Include acceptance criteria and validation steps. Pause for my review before applying.
   ```
   Review the change folder under `openspec/changes/`. Ask Specs to simplify if needed.

6. **Apply with the Squad executing it:**
   ```text
   Squad, please apply the approved OpenSpec proposal and implement the app.
   Coordinate the handoffs and report back after each task.
   ```

7. **Test with Playwright:**
   ```text
   Squad, run Playwright tests against the running app and report pass/fail for core flows:
   - add note
   - delete note
   - add reminder
   - today view filtering
   ```
   If MCP is unavailable, run Playwright CLI as backup (`npx playwright test`).

8. **Run, validate, and archive.** In a second terminal: `npm start`, open the printed URL,
   and walk the checklist. Back in the CLI:
   ```text
   Squad, archive the change once validation passes and sync all specs and write a short SUMMARY.md describing the architecture, decisions, and next steps.
   ```

## Optional stretch goals

- Add a natural-language reminder input ("remind me to call Sam tomorrow at 3pm") parsed locally.
- Add categories for notes.
- Add an "Overdue" section.

## Scope

- Greenfield: all files are created during the scenario.
- Keep the Squad and OpenSpec artifacts in this folder (`.squad/`, `openspec/`).
- Browser app, vanilla HTML/CSS/JS, single Node http server. No external APIs or auth.

## Troubleshooting

- `copilot --agent squad` not recognized → upgrade Copilot CLI and run `squad doctor`.
- Squad uses too many tokens → run `squad nap` between phases.
- OpenSpec slash commands missing → `openspec update` and restart the CLI.
