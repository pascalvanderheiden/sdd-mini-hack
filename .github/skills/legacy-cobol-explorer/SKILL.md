---
name: legacy-cobol-explorer
description: Domain knowledge for the legacy COBOL accounting system used in Scenario 3 (cloned from github.com/tjsingh85/cobol-accounting-system into examples/scenario-3-legacy-cobol-library/cobol-source). Use when reading, explaining, or modernizing that program.
---

# Legacy COBOL explorer

This skill applies to the **COBOL accounting system** participants clone in Scenario 3 into
`examples/scenario-3-legacy-cobol-library/cobol-source/` (source:
[tjsingh85/cobol-accounting-system](https://github.com/tjsingh85/cobol-accounting-system)).
Use it whenever a participant or another agent needs to understand or modernize that program.

> The source is **not committed** to this repo — it is cloned during the scenario. The
> structure and rules below describe what you'll find once cloned.

## What the program does

An interactive, menu-driven single-account accounting app, split across three COBOL programs:

- `main.cob` (**MainProgram**) — the menu loop. Reads a choice (1-4) and calls the
  operations subprogram with a 6-char operation code:
  - `1` → `TOTAL ` (view balance)
  - `2` → `CREDIT`
  - `3` → `DEBIT `
  - `4` → exit
- `operations.cob` (**OperationsProgram**) — performs the chosen operation: prompts for an
  amount (credit/debit), reads/writes the balance via the data program, and prints results.
- `data.cob` (**DataProgram**) — stores the balance in working storage; supports `READ` and
  `WRITE` operations.

There is no file I/O, database, or network — the balance lives in memory for the session.

## Key facts to preserve in any rewrite

- **Starting balance is `1000.00`** (`PIC 9(6)V99`, i.e. up to 6 integer digits + 2 decimals,
  unsigned).
- **View balance** prints `Current balance: <balance>`.
- **Credit** prompts `Enter credit amount:`, adds it, prints `Amount credited. New balance: <balance>`.
- **Debit** prompts `Enter debit amount:`. If `balance >= amount`, subtract and print
  `Amount debited. New balance: <balance>`. Otherwise print `Insufficient funds for this debit.`
  and leave the balance unchanged (**no overdraft, ever**).
- Amounts are non-negative decimals with 2 implied decimal places.
- The balance is **session-scoped** — it resets to `1000.00` on each run (no persistence).

## Modernization checklist

When rewriting this in a modern language (Scenario 3 targets Node.js):

1. Mirror the three programs as small modules: `data` (balance store), `operations`
   (credit/debit/view with the overdraw guard), `main` (interactive menu loop).
2. Keep the **starting balance** and the **insufficient-funds** rule identical.
3. Reproduce the menu text and result messages so behavior matches the COBOL app.
4. Use the repo's `TESTPLAN.md` to derive tests: view balance, credit (valid + zero),
   debit (valid + insufficient funds).
5. Keep the cloned `cobol-source/` folder read-only — write the rewrite under `modern/`.

## Things to NOT change

- The starting balance (`1000.00`).
- The overdraft rejection rule (a debit larger than the balance is refused).
- The set of operations (view balance, credit, debit, exit).
