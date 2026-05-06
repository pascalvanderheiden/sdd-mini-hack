# Legacy COBOL banking sample (Scenario 3)

A small COBOL batch program used as the **legacy** input for the Spec Kit modernization scenario.

## What it does

Reads two fixed-width files, applies transactions, and prints a sorted account report.

- `data/accounts.dat` — initial accounts.
- `data/transactions.dat` — deposits (`D`) and withdrawals (`W`).
- Withdrawals that would overdraw an account are **rejected**.
- Transactions that reference an unknown account are **rejected**.
- The final report is sorted by account id.

The expected output is captured in `expected-output.txt`. Any modern rewrite must reproduce it byte-for-byte.

## Run

You need GnuCOBOL (`cobc -V`):

- macOS: `brew install gnu-cobol`
- Linux: `sudo apt-get install -y gnucobol`
- Windows: use WSL with the Linux command above.

```bash
./run.sh
```

This compiles `cobol/ACCOUNT-REPORT.cob` to `build/account-report` and runs it.

## File formats

`accounts.dat` (32 chars per line):

| Cols | Field   | PIC          |
|------|---------|--------------|
| 1-4  | id      | `9(4)`       |
| 5-24 | name    | `X(20)`      |
| 25-32| balance | `9(6)V99`    |

`transactions.dat` (13 chars per line):

| Cols  | Field  | PIC          |
|-------|--------|--------------|
| 1-4   | id     | `9(4)`       |
| 5     | type   | `X(1)` (`D`/`W`) |
| 6-13  | amount | `9(6)V99`    |

`9(6)V99` means 6 integer digits followed by 2 cent digits with an *implied* decimal point. So `00015050` represents `150.50`.

## Modernization tips

See `.github/skills/legacy-cobol-explorer/SKILL.md` for the rules a rewrite must preserve.
