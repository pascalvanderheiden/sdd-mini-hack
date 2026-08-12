# Scenario 7 — Shareable Balloon Message with Copilot and Wayfinder SDD

> Scoped working folder for **Scenario 7**. Run the entire scenario from this folder.
> Canonical guide: [../../docs/scenario-7-copilot-app-balloon.md](../../docs/scenario-7-copilot-app-balloon.md)

Build a playful, shareable Balloon Message app through GitHub Copilot CLI or the Desktop App, GitHub Issues, and Matt Pocock's skills.

**Time:** ~75 minutes  
**Tooling:** GitHub Copilot CLI or Desktop App + GitHub Issues + Wayfinder + Playwright

This is a greenfield scenario. The folder starts with only this README; Copilot generates the application, specification, domain context, ADR, and tests during the workflow.

## Quick Start

1. Fork the workshop repository (recommended), then open this folder:

   ```bash
   gh repo fork pascalvanderheiden/sdd-mini-hack --clone
   cd sdd-mini-hack
   cd examples/scenario-7-balloon-message
   code .
   ```

   Alternatively, follow the canonical guide to create an empty folder, run `git init`, and publish a dedicated repository with `gh repo create --public`.

2. GitHub Issues are recommended for this workshop. Matt Pocock's setup also supports local files and GitLab.

3. In the VS Code terminal, install Matt Pocock's process skills:

   ```bash
   npx skills@latest add mattpocock/skills
   ```

   Include `setup-matt-pocock-skills`, `wayfinder`, `to-spec`, `to-ticket`, `implement`, and `code-review`. Run `/setup-matt-pocock-skills` once and choose GitHub Issues.

4. In [GitHub Copilot Desktop](https://github.com/features/ai/github-app) ([macOS installer](https://gh.io/copilot-app-mac), [Windows installer](https://gh.io/copilot-app-win64)), select **Add session** → **Local folder or repository**, then select the scenario folder you just prepared. Alternatively, start GitHub Copilot CLI from that folder.

5. Follow the canonical guide and run the workflow in order:

   ```text
   /wayfinder
   /wayfinder #<each-child-issue>
   /to-spec #<wayfinder-map-issue>
   /to-ticket
   /fleet /implement #<issue-1> #<issue-2> #<issue-3>
   ```

   In the Desktop App, type `#` to select issues. Fleet implements them in parallel, and `/implement` invokes `/code-review` automatically.

   After Fleet completes, create a pull request that links the specification and includes `Closes #...` references for the Wayfinder map, decision tickets, and implementation issues. Merge it only after checks pass.

6. Keep the agreed contract:

   - A Sender creates and previews a Balloon for a Recipient.
   - The Message is required and limited to 280 characters.
   - The Share Link token is cryptographically random and URL-safe.
   - Links are reusable for seven days, then expire.
   - The generated stack is Node.js + Express + SQLite with vanilla browser UI.
   - The experience supports keyboard users, screen readers, and reduced motion.
   - API and Playwright tests validate external behavior.

7. Expect Copilot to generate:

   ```text
   CONTEXT.md
   docs/adr/0001-seven-day-share-links.md
   package.json
   src/
   public/
   data/
   tests/api/
   tests/e2e/
   ```

## Scope

- The committed starter contains no implementation.
- The workshop uses GitHub Issues; local-file and GitLab tracker variants are supported but not covered here.
- Keep all generated files inside this folder.
- No accounts, moderation, rate limiting, analytics, delivery integrations, or production hosting.
- Demo video: [Watch Scenario 7 on YouTube](https://www.youtube.com/watch?v=F3lL98Pj90o&t=3s).

## Validation

Follow the exact run and test instructions produced by the completed implementation. Then complete the browser, keyboard, reduced-motion, unknown-link, and expired-link checks in the canonical guide.
