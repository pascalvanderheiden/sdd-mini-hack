# Scenario 4 — Personal Assistant with Squad + OpenSpec via Copilot CLI

Use the **Copilot CLI** with the **Squad** agent. Add a Squad team member that owns OpenSpec, then have them propose and execute a small personal assistant app.

**Time:** ~50 minutes  
**Tooling:** GitHub Copilot CLI + Squad + OpenSpec

## Prereqs

- GitHub Copilot CLI installed and signed in (`copilot --help`).
- Node.js 20.19+.
- Squad: `npm install -g @bradygaster/squad-cli` (`squad doctor`).
- OpenSpec: `npm install -g @fission-ai/openspec@latest`.
- `gh` CLI signed in (`gh auth status`).

## Step 1 — Create a clean workspace

```bash
mkdir ~/sdd-assistant
cd ~/sdd-assistant
git init
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

Set up a small Squad team for this project:
- a product/spec lead
- a frontend implementer
- a validation/tester role

Then add a fourth specialist member named "Specs" who owns OpenSpec and is the only member allowed to run /opsx commands.

Show me the proposed roster and wait for my approval.
```

Approve the roster.

## Step 5 — Have the Specs member create the proposal

```text
Specs: please create an OpenSpec proposal for DayDesk.

Scope:
- Capture short notes (add, list, delete).
- Reminders with a title and due date.
- "Today" view that shows reminders due today.
- Persist data in localStorage.
- Browser app, vanilla HTML/CSS/JS, no framework, single Node http server (npm start).
- No external APIs, secrets, or auth.

Use /opsx:propose. Include acceptance criteria and validation steps. Pause for my review before applying.
```

When the proposal is ready, review the change folder under `openspec/changes/`. Ask Specs to simplify if needed.

## Step 6 — Apply with the Squad executing it

```text
Specs: run /opsx:apply.
Frontend implementer: implement the tasks in small steps.
Validation lead: after each step, list the manual checks I should run and update a CHECKLIST.md.

Coordinate the handoffs and report back after each task.
```

## Step 7 — Run and validate

Open a second terminal:

```bash
cd ~/sdd-assistant
npm start
```

Open the printed URL and walk through the validation lead's checklist.

Back in the Copilot CLI:

```text
Specs: archive the change with /opsx:archive once validation passes.
Squad lead: write a short SUMMARY.md describing the architecture, decisions, and next steps.
```

## Optional stretch goals

- Add a natural-language reminder input ("remind me to call Sam tomorrow at 3pm") parsed locally.
- Add categories for notes.
- Add an "Overdue" section.

## Troubleshooting

- `copilot --agent squad` not recognized → upgrade Copilot CLI and run `squad doctor`.
- Squad uses too many tokens → run `squad nap` between phases.
- OpenSpec slash commands missing → `openspec update` and restart the CLI.
