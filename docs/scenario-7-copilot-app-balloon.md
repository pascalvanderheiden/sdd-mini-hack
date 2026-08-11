# Scenario 7 — Shareable Balloon Message with Copilot and Wayfinder SDD

Turn a playful idea into a reviewed implementation by moving from questions, to specification, to a GitHub Issue, to code.

**Time:** ~75 minutes  
**Tooling:** GitHub Copilot CLI or Desktop App + GitHub Issues + Matt Pocock skills + Playwright

## Prereqs

See [docs/prerequisites.md](prerequisites.md). Key requirements:

- GitHub Issues are recommended for this scenario. Matt Pocock's skills can also use local files or GitLab, but those variants are not covered by the workshop steps.
- A fork of this workshop repository, or a dedicated GitHub repository for Scenario 7.
- GitHub Copilot CLI, or the [GitHub Copilot Desktop App](https://github.com/features/ai/github-app):
  - [Install for macOS](https://gh.io/copilot-app-mac)
  - [Install for Windows](https://gh.io/copilot-app-win64)
- GitHub CLI installed and authenticated (`gh auth status`).
- Node.js 20.19+.
- Playwright through the repository MCP configuration or the CLI backup.

## Step 1 — Prepare the scenario repository

The repository intentionally contains no Balloon application. All app, specification, and test files are generated during this scenario.

### Option A — Fork the workshop repository (recommended)

Fork and clone the workshop:

```bash
gh repo fork pascalvanderheiden/sdd-mini-hack --clone
cd sdd-mini-hack/examples/scenario-7-balloon-message
code .
```

Enable GitHub Issues on the fork if needed. This option preserves the complete workshop context and links.

### Option B — Create a dedicated repository

From the root of a local workshop clone, copy this guide into a new folder, initialize Git, and publish it:

```bash
mkdir ../balloon-message
cp docs/scenario-7-copilot-app-balloon.md ../balloon-message/README.md
cd ../balloon-message
git init -b main
git add README.md
git commit -m "Add Scenario 7 instructions"
gh repo create balloon-message --source=. --remote=origin --push
code .
```

`gh repo create` prompts for the owner and repository visibility. Enable GitHub Issues if they are not already available.

In either option, use the VS Code terminal in the scenario workspace for the remaining setup commands. Confirm the remote and Issues access:

```bash
git remote -v
gh repo view --web
gh issue list --limit 1
```

## Step 2 — Install and configure Matt Pocock's skills

From the VS Code terminal in the scenario folder or dedicated repository, install the process skills:

```bash
npx skills@latest add mattpocock/skills
```

In the installer, include `setup-matt-pocock-skills`, `wayfinder`, `to-spec`, `to-ticket`, `implement`, and `code-review`, and install them for the Copilot client you will use.

Start Copilot CLI or a Desktop App session for the repository, then run:

```text
/setup-matt-pocock-skills
```

Choose **GitHub Issues** as the issue tracker for this workshop. The setup also supports local files and GitLab for other workflows. In a fork, keep generated documentation inside `examples/scenario-7-balloon-message/`; in a dedicated repository, keep it at the repository root.

## Step 3 — Chart the work with Wayfinder

Send:

```text
/wayfinder

I want to build a playful web app where a Sender creates and previews a Balloon
with a short Message for a Recipient, then shares an unguessable link. The
Recipient opens the link without an account and reveals the Message through an
animated balloon experience.
```

Wayfinder creates a `wayfinder:map` issue and child decision tickets. Resolve the frontier tickets one at a time by running `/wayfinder` with the map URL until the route to the specification is clear. Keep these decisions:

- Canonical terms are **Balloon**, **Sender**, **Recipient**, **Message**, and **Share Link**.
- Sender name, Recipient name, Message, color, creation time, and expiry time are stored.
- Message is required and limited to 280 characters.
- Share Links use cryptographically random URL-safe identifiers, never sequential IDs.
- A Share Link is reusable for seven days, then expires. It cannot be edited or revoked in version 1.
- No accounts, moderation, filtering, rate limiting, analytics, or delivery integrations.
- `CONTEXT.md` contains the glossary.
- ADR-0001 records the seven-day reusable-link decision.

## Step 4 — Convert decisions into a specification

Send:

```text
/to-spec
```

The skill uses the resolved Wayfinder context. Review the generated specification, `CONTEXT.md`, and ADR-0001 before continuing.

## Step 5 — Create the implementation GitHub Issue

Send:

```text
/to-ticket
```

The skill converts the current specification into an implementation issue. Open it and verify that another developer could implement it without the chat history.

## Step 6 — Implement from the issue

Open the issue in a new Copilot CLI or Desktop App coding session. Ask the agent to implement only inside this scenario folder:

```text
/implement
```

The skill reads the issue and linked specification, implements the work, runs validation, and invokes `/code-review` automatically.

Expected generated structure:

```text
examples/scenario-7-balloon-message/
├── CONTEXT.md
├── docs/adr/0001-seven-day-share-links.md
├── package.json
├── src/
├── public/
├── data/
├── tests/api/
└── tests/e2e/
```

The exact internal module layout may differ. The API, UX, accessibility, and lifecycle contracts must not. Review the automatic code-review findings and confirm blocking issues were fixed.

## Step 7 — Validate manually

Start the generated app using the command documented by the implementation, typically:

```bash
npm install
npm start
```

Run the generated suites:

```bash
npm run test:api
npm run test:e2e
```

Manual checklist:

1. Create a Balloon with Sender, Recipient, Message, and a chosen color.
2. Confirm preview matches the created Balloon.
3. Copy the Share Link and open it in a private browser window.
4. Reveal the Message with mouse, Enter, and Space.
5. Reload and reopen the same link; confirm it remains available.
6. Submit missing fields and a 281-character Message; confirm inline friendly errors.
7. Open unknown and expired links; confirm branded explanations without technical details.
8. Enable reduced motion; confirm the Message is available without celebratory movement.
9. Navigate the complete Sender and Recipient flows using only the keyboard.

## Troubleshooting

- Copilot cannot access the repository → confirm the selected client is authorized for the repository.
- `/wayfinder` or another process skill is missing → rerun `npx skills@latest add mattpocock/skills`, include `setup-matt-pocock-skills` and the required workflow skills, then run `/setup-matt-pocock-skills`.
- Issue creation fails → enable GitHub Issues and confirm write permission.
- `npm` or Node is missing → install Node.js 20.19+.
- Playwright browser is missing → run `npx playwright install chromium`.
- SQLite native package fails to install → use the Node version required by the generated `package.json`, reinstall dependencies, and rerun the API tests.

## What you learned

- Wayfinder turns uncertainty into a shared map of decision issues.
- A specification becomes a self-contained GitHub Issue.
- The implementation session works from repository artifacts instead of hidden chat context.
- Code review checks both engineering standards and the originating specification.
