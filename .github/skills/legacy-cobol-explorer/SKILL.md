---
name: legacy-cobol-explorer
description: Domain knowledge for the legacy COBOL banking sample in examples/legacy-cobol-library. Use when reading, explaining, or modernizing that program.
---

# Legacy COBOL explorer

This skill applies only to `examples/legacy-cobol-library/cobol/ACCOUNT-REPORT.cob` and its data files. Use it whenever a participant or another agent needs to understand or modernize that program.

## What the program does

`ACCOUNT-REPORT.cob` is a small batch program that:

1. Reads a fixed-width **accounts** file (`data/accounts.dat`).
2. Reads a fixed-width **transactions** file (`data/transactions.dat`).
3. Applies each transaction to the matching account in memory.
4. Prints a final report to STDOUT.

There is no database, no network, no UI.

## Data formats (fixed width)

`accounts.dat` — one line per account:

| Cols | Field        | Notes                                    |
|------|--------------|------------------------------------------|
| 1-4  | account-id   | 4 digits, zero-padded                    |
| 5-24 | name         | 20 chars, space-padded                   |
| 25-34| balance      | signed decimal, 2 implied decimals (S9(8)V99 → "0000123456" = 1234.56) |

`transactions.dat` — one line per transaction:

| Cols | Field        | Notes                                    |
|------|--------------|------------------------------------------|
| 1-4  | account-id   | matches accounts.dat                     |
| 5    | type         | `D` = deposit, `W` = withdrawal          |
| 6-15 | amount       | unsigned decimal, 2 implied decimals     |

## Business rules to preserve in any rewrite

- Transactions apply in file order.
- A withdrawal that would make the balance go negative is **rejected** (the report shows it as REJECTED) and the balance is unchanged.
- Unknown account-ids are **rejected**.
- Final report is sorted by **account-id ascending**.
- Currency is printed as `$###,##0.00` with a leading `$` and thousands separators.
- The exact text format of the report is captured in `expected-output.txt`. Output **must** match byte-for-byte.

## Modernization checklist

When rewriting this in a modern language:

1. Read both files line by line; preserve fixed-width parsing.
2. Convert "implied decimals" by dividing the integer by 100 (or use a `Decimal`/`BigInt` approach).
3. Apply transactions in order, enforcing the rejection rules above.
4. Sort accounts by id before printing.
5. Re-create the report header, separator lines, and the trailing totals line exactly.
6. Add a small test that diffs program output against `expected-output.txt`.

## Things to NOT change

- Input file names, locations, or formats.
- Output line ordering, spacing, or the leading `$`.
- Rejection semantics (no overdraft, ever).
