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

In your terminal, first browse to the folder where you want to create the project. Then create and publish an empty repository:

```bash
mkdir balloon-message
cd balloon-message
git init -b main
git commit --allow-empty -m "Initialize Balloon project"
gh repo create balloon-message --public --source=. --remote=origin --push
code .
```

This creates a public repository. Replace `--public` with `--private` or `--internal` if needed. Enable GitHub Issues if they are not already available.

In either option, use the VS Code terminal in the scenario workspace for the remaining setup commands.

## Step 2 — Install and configure Matt Pocock's skills

From the VS Code terminal in the scenario folder or dedicated repository, install the process skills:

```bash
npx skills@latest add mattpocock/skills
```

In the installer, include `setup-matt-pocock-skills`, `wayfinder`, `to-spec`, `to-ticket`, `implement`, and `code-review`, and install them for the Copilot client you will use.

To use the **GitHub Copilot Desktop App**:

1. Open the app and select **Add session**.
2. Choose **Local folder or repository**.
3. Select the scenario folder from your fork, or the `balloon-message` folder you just created.

To use **GitHub Copilot CLI**, open it from that same folder.

In the new Desktop App or CLI session, run:

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

Wayfinder creates a `wayfinder:map` issue and child decision tickets.

## Step 4 — Resolve every Wayfinder issue

In the GitHub Copilot Desktop App, type `#` to search for and select each child issue created by the map, then run:

```text
/wayfinder #<selected-issue>
```

In Copilot CLI, paste the issue URL if the `#` picker is unavailable. Depending on the ticket, Wayfinder may guide a research task, a grilling conversation, or a prototype. Repeat this for every issue until all decision tickets are resolved and the map's route is clear.

Keep these decisions:

- Canonical terms are **Balloon**, **Sender**, **Recipient**, **Message**, and **Share Link**.
- Sender name, Recipient name, Message, color, creation time, and expiry time are stored.
- Message is required and limited to 280 characters.
- Share Links use cryptographically random URL-safe identifiers, never sequential IDs.
- A Share Link is reusable for seven days, then expires. It cannot be edited or revoked in version 1.
- No accounts, moderation, filtering, rate limiting, analytics, or delivery integrations.
- `CONTEXT.md` contains the glossary.
- ADR-0001 records the seven-day reusable-link decision.

## Step 5 — Convert the map into a specification

Select the resolved Wayfinder map with `#` in the Desktop App, then run:

```text
/to-spec #<wayfinder-map-issue>
```

In Copilot CLI, use the map issue URL instead. Review the generated specification, `CONTEXT.md`, and ADR-0001 before continuing.

## Step 6 — Create the implementation GitHub Issues

Send:

```text
/to-ticket
```

The skill converts the current specification into implementation issues. Open them and verify that another developer could implement each one without the chat history.

## Step 7 — Implement the issues with Fleet

Open a new Copilot CLI or Desktop App coding session. Use Fleet to implement all generated issues in parallel. In the Desktop App, type `#` and select every implementation issue:

```text
/fleet /implement #<issue-1> #<issue-2> #<issue-3>
```

In Copilot CLI, use the issue URLs if the `#` picker is unavailable. Fleet distributes the issues across agents; each `/implement` run reads its issue and linked specification, validates the work, and invokes `/code-review` automatically.

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

## Step 8 — Validate manually

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
