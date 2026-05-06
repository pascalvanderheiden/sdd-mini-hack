# Scenario 3 — Legacy Modernization with Spec Kit (COBOL → Modern Stack)

Run a small COBOL banking program, then use **Spec Kit** to specify, plan, task, and implement a modern rewrite that produces the **same output**.

**Time:** ~50 minutes  
**Tooling:** GnuCOBOL + Spec Kit + GitHub Copilot Chat (Agent mode)

## Prereqs

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

## Step 1 — Run the legacy COBOL app

```bash
cd examples/legacy-cobol-library
./run.sh
```

You will see:
- A list of seeded bank accounts.
- A few transactions applied (deposits and withdrawals).
- A final account balance report.

Keep the file `expected-output.txt` open. The modern rewrite must produce the **exact same lines** in the same order.

## Step 2 — Initialize Spec Kit

From `examples/legacy-cobol-library`:

```bash
specify init --here --ai copilot
```

When prompted, accept the defaults. This creates `.specify/` and registers `/speckit.*` slash commands in Copilot Chat.

## Step 3 — Constitution

In **Copilot Chat → Agent mode**:

```text
/speckit.constitution

Principles for modernizing the COBOL banking app:
- Behavior preservation comes first. The new program must produce the exact same output as expected-output.txt.
- Target stack: Node.js 20+, vanilla JavaScript, no external dependencies.
- Same input data (data/accounts.dat and data/transactions.dat) must continue to work.
- Provide a single command (npm start) that reproduces the report.
- Add a small test that asserts output matches expected-output.txt.
```

## Step 4 — Specify

```text
/speckit.specify

The legacy app under examples/legacy-cobol-library/cobol/ runs ACCOUNT-REPORT.cob.
Read its source, the .dat files, and expected-output.txt to derive the spec.

Goals:
- Reimplement the same business logic in Node.js under a new folder examples/legacy-cobol-library/modern/.
- Keep the legacy folder untouched.
- Document the data file format and any assumptions.
```

## Step 5 — Plan

```text
/speckit.plan

Use Node.js with built-in modules only (fs, readline). Mirror the COBOL paragraphs as small functions:
- loadAccounts
- loadTransactions
- applyTransaction
- printReport

Deliverables:
- modern/index.mjs
- modern/package.json with "start" and "test" scripts
- modern/test.mjs that diffs program output against ../expected-output.txt
```

## Step 6 — Tasks

```text
/speckit.tasks
```

Review the task list. Keep it small and ordered.

## Step 7 — Implement in steps

```text
/speckit.implement
```

Copilot will execute one task at a time. After each task, ask:

```text
Run modern/test.mjs and show pass/fail.
```

## Step 8 — Final validation

```bash
cd examples/legacy-cobol-library
diff <(./run.sh) <(cd modern && npm start --silent)
```

The diff should be empty.

## Optional stretch goals

- Add a transaction type for **transfer** between two accounts.
- Add a CSV export of the report.
- Wrap `modern/` in a tiny HTTP endpoint that returns the report as JSON.

## Troubleshooting

- `cobc: command not found` → install GnuCOBOL (see prereqs).
- `specify` not found → `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git` and reopen the terminal.
- Output diff is non-empty → ask Copilot to compare line-by-line and adjust formatting.
