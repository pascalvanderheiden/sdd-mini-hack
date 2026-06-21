# Scenario 4 — Personal Assistant with Squad + OpenSpec via Copilot CLI

Use the **Copilot CLI** with the **Squad** agent. Add a Squad team member that owns OpenSpec, then have them propose and execute a small personal assistant app.

**Time:** ~50 minutes  
**Tooling:** GitHub Copilot CLI + Squad + OpenSpec

## Prereqs

See the consolidated prerequisites guide: [docs/prerequisites.md](prerequisites.md).

- GitHub Copilot CLI installed and signed in (`copilot --help`).
- Node.js 20.19+.
- Squad: `npm install -g @bradygaster/squad-cli` (`squad doctor`).
- OpenSpec: `npm install -g @fission-ai/openspec@latest`.
- `gh` CLI signed in (`gh auth status`).

## Step 1 — Open the scenario folder

This scenario runs from its example folder in the repo (the Squad and OpenSpec artifacts stay scoped here):

```bash
cd examples/scenario-4-cli-squad-assistant
```

## Step 2 — Initialize OpenSpec and Squad

```bash
openspec init
```

Choose **GitHub Copilot** when prompted.

```bash
squad init
```

Verify:

```bash
ls .squad
ls openspec
```

## Step 3 — Open Copilot CLI with Squad

```bash
copilot --agent squad --yolo
```

> `--yolo` skips per-tool approval prompts. Squad makes many calls per session.

## Step 4 — Set up the team

In the Copilot CLI session, send:

```text
I'm starting a small personal assistant app called DayDesk.
Set up a small Squad team for this project.

Then add a specialized member who manages OpenSpec proposals. 

Show me the proposed roster and wait for my approval.
```

Approve the roster.

## Step 5 — Have the Specs member create the proposal

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

When the proposal is ready, review the change folder under `openspec/changes/`. Ask Specs to simplify if needed.

## Step 6 — Apply with the Squad executing it

```text
Squad, please apply the approved OpenSpec proposal and implement the app.
Coordinate the handoffs and report back after each task.
```

## Step 7 — Test with Playwright

In the Copilot CLI session, ask Squad to run a Playwright validation pass before final sign-off:

```text
Squad, run Playwright tests against the running app and report pass/fail for core flows:
- add note
- delete note
- add reminder
- today view filtering
```

If MCP is unavailable, run Playwright CLI as backup (`npx playwright test`) and share results.

## Step 8 — Run and validate

Open a second terminal:

```bash
cd examples/scenario-4-cli-squad-assistant
npm start
```

Open the printed URL and walk through the validation lead's checklist.

Back in the Copilot CLI:

```text
Squad, archive the change once validation passes and sync all specs and write a short SUMMARY.md describing the architecture, decisions, and next steps.
```

## Optional stretch goals

- Add a natural-language reminder input ("remind me to call Sam tomorrow at 3pm") parsed locally.
- Add categories for notes.
- Add an "Overdue" section.

## Troubleshooting

- `copilot --agent squad` not recognized → upgrade Copilot CLI and run `squad doctor`.
- Squad uses too many tokens → run `squad nap` between phases.
- OpenSpec slash commands missing → `openspec update` and restart the CLI.
