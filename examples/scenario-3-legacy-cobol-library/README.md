# Legacy Modernization — COBOL → Modern Stack (Scenario 3 sample)

This is the self-contained working folder for **Scenario 3 — Legacy Modernization with Spec Kit (COBOL → Modern Stack)**.

See the full scenario guide: [../../docs/scenario-3-speckit-cobol.md](../../docs/scenario-3-speckit-cobol.md)

The legacy COBOL app is **not** committed here — you clone it as the source (same approach
as Scenario 6), then use Spec Kit to specify, plan, task, and implement a modern rewrite
that preserves its behavior.

## Quick Start

1. **Open this folder in VS Code** and open a terminal here:
   ```bash
   cd examples/scenario-3-legacy-cobol-library
   code .
   ```

2. **Generate Copilot instructions.** Open the **Command Palette** (`Cmd/Ctrl+Shift+P`) and
   run **Chat: Generate Workspace Instructions File** to create `.github/copilot-instructions.md`.
   No command? Ask Copilot Chat (Agent mode): *"Analyze this workspace and generate a
   .github/copilot-instructions.md."* (Re-run it after cloning the source so it captures the
   COBOL code.)

3. **Clone the legacy source** into this folder:
   ```bash
   git clone https://github.com/tjsingh85/cobol-accounting-system.git cobol-source
   ```

4. **Run the legacy app** to capture the behavior you must preserve (needs GnuCOBOL — `cobc -V`):
   ```bash
   cd cobol-source
   cobc -x main.cob operations.cob data.cob -o accountsystem
   ./accountsystem    # interactive menu: view balance, credit, debit, exit
   ```
   Try each menu option and note the outputs. When done, `cd ..` back to this folder.

5. **Run the Spec Kit lifecycle.** Follow the scenario guide: `specify init --here --ai copilot`, then
   `/speckit.constitution` → `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` →
   `/speckit.implement`. The modern rewrite is produced under `modern/`.

## Structure

This folder contains:
- `README.md` — this file
- `.gitignore` — ignores the cloned COBOL source, the generated rewrite, and build output

Created by you during the scenario:
- `cobol-source/` — the cloned legacy COBOL accounting system (reference only)
- `modern/` — the new modern rewrite the team builds
- `specs/<feature-name>/` — Spec Kit artifacts (constitution, spec, plan, tasks)
- `.specify/` — Spec Kit scaffolding (from `specify init --here --ai copilot`)

## Scope

- **Behavior preservation first.** The rewrite must reproduce the legacy app's operations —
  view balance, credit, debit — with the same results.
- **Keep the cloned `cobol-source/` untouched.** Treat it as read-only reference.

## Source

Legacy app: [tjsingh85/cobol-accounting-system](https://github.com/tjsingh85/cobol-accounting-system)
(`main.cob` drives an interactive menu; `operations.cob` handles credit/debit/view;
`data.cob` stores the balance). The repo also ships a `TESTPLAN.md` you can use to derive
acceptance criteria.
