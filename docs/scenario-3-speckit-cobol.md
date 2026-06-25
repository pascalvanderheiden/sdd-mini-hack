# Scenario 3 — Legacy Modernization with Spec Kit (COBOL → Modern Stack)

Clone a legacy **COBOL accounting system**, run it, then use **Spec Kit** to specify, plan,
task, and implement a modern rewrite that preserves the **same behavior**.

**Time:** ~50 minutes
**Tooling:** GnuCOBOL + Spec Kit + GitHub Copilot Chat (Agent mode)

## Prereqs

See the consolidated prerequisites guide: [docs/prerequisites.md](prerequisites.md).

- VS Code with GitHub Copilot + Copilot Chat signed in.
- Node.js 20.19+.
- **GnuCOBOL** (`cobc -V`):
  - macOS: `brew install gnu-cobol`
  - Linux: `sudo apt-get install -y gnucobol`
  - Windows: use WSL with the Linux command above.
- **Python 3.12+** and **uv**:
  - `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **Spec Kit**:
  - `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git`
  - `specify check`

## Step 1 — Open the scenario folder

This scenario runs from its example folder in the repo (everything you create stays scoped here):

```bash
cd examples/scenario-3-legacy-cobol-library
code .
```

Open a terminal in this folder for the next steps.

## Step 2 — Get the source app (the behavior you must preserve)

Clone the legacy COBOL accounting system into the scenario folder. This is the **reference
program** — your modern rewrite must reproduce its operations.

```bash
git clone https://github.com/tjsingh85/cobol-accounting-system.git cobol-source
```

The source is three COBOL programs:
- `main.cob` — interactive menu (view balance, credit, debit, exit).
- `operations.cob` — the actual credit / debit / view-balance logic.
- `data.cob` — stores the account balance.

It also ships a `TESTPLAN.md` describing the business rules — useful input for the spec.

## Step 3 — Generate Copilot instructions

Now that the source app is cloned, give Copilot project context. In VS Code, open the
**Command Palette** (`Cmd/Ctrl+Shift+P`) and run **Chat: Generate Workspace Instructions File**.
Copilot analyzes the folder — including the COBOL code — and writes
`.github/copilot-instructions.md`.

> No command? Open **Copilot Chat → Agent mode** and ask:
> ```text
> Analyze this workspace and generate a .github/copilot-instructions.md that captures the
> stack, structure, conventions, and how to run and test this app.
> ```

Review the generated file — it's loaded automatically into every Copilot request, so it now
captures the COBOL code you just cloned.

## Step 4 — Run the legacy COBOL app

Compile and run it to capture the behavior the rewrite must match:

```bash
cd cobol-source
cobc -x main.cob operations.cob data.cob -o accountsystem
./accountsystem
```

Walk through the menu:
- **1 — View Balance** shows the current balance.
- **2 — Credit Account** adds an amount and shows the new balance.
- **3 — Debit Account** subtracts an amount (only if funds allow) and shows the new balance.
- **4 — Exit** quits.

Note the exact prompts and outputs. When done, `cd ..` back to `examples/scenario-3-legacy-cobol-library`.

## Step 5 — Initialize Spec Kit

From the scenario folder (`examples/scenario-3-legacy-cobol-library`):

```bash
specify init --here --ai copilot
```

When prompted, accept the defaults. This creates `.specify/` and registers `/speckit.*` slash commands in Copilot Chat.

## Step 6 — Constitution

In **Copilot Chat → Agent mode**:

```text
/speckit.constitution

Principles for modernizing the COBOL accounting system under cobol-source/:
- Behavior preservation comes first. The rewrite must reproduce the same operations and results as the COBOL app (view balance, credit, debit), including rejecting debits that would overdraw the balance.
- Target stack: Node.js 20+, vanilla JavaScript, no external runtime dependencies.
- Provide a single command (npm start) that runs the same interactive menu.
- Add automated tests derived from cobol-source/TESTPLAN.md (view balance, credit valid/zero, debit valid/insufficient funds).
```

## Step 7 — Specify

```text
/speckit.specify

The legacy app under cobol-source/ is a COBOL accounting system:
- main.cob drives an interactive menu (view balance, credit, debit, exit).
- operations.cob performs credit, debit, and view-balance.
- data.cob stores the running balance.

Read these sources and TESTPLAN.md to derive the spec.

Goals:
- Reimplement the same business logic in Node.js under a new folder modern/.
- Keep the cobol-source/ folder untouched (read-only reference).
- Document the operations, the starting balance, and the overdraw rule.
```

## Step 8 — Plan

```text
/speckit.plan

Use Node.js with built-in modules only (readline for the menu). Mirror the COBOL programs as small modules:
- data.js       — holds and updates the balance (mirrors data.cob)
- operations.js — credit, debit (with overdraw guard), viewBalance (mirrors operations.cob)
- main.js       — the interactive menu loop (mirrors main.cob)

Deliverables:
- modern/main.js, modern/operations.js, modern/data.js
- modern/package.json with "start" and "test" scripts
- modern/tests/ covering the TESTPLAN.md cases
```

## Step 9 — Tasks

```text
/speckit.tasks
```

Review the task list. Keep it small and ordered.

## Step 10 — Implement in steps

```text
/speckit.implement
```

Copilot will execute one task at a time. After each task, ask:

```text
Run the modern tests (npm test in modern/) and show pass/fail.
```

## Step 11 — Final validation

Run the modern app and exercise the same menu operations you ran in Step 4, confirming the
results match:

```bash
cd modern
npm start    # same menu, same results as ./accountsystem
npm test     # TESTPLAN-derived tests pass
```

## Optional stretch goals

- Add a transaction history / statement view.
- Persist the balance to a file so it survives restarts.
- Wrap `modern/` in a tiny HTTP endpoint that returns the balance as JSON.

## Troubleshooting

- `cobc: command not found` → install GnuCOBOL (see prereqs).
- `specify` not found → `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` and reopen the terminal.
- Behavior differs from the legacy app → ask Copilot to compare against the COBOL sources and `TESTPLAN.md` and adjust.
