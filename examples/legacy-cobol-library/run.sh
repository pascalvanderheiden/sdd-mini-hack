#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build
cobc -x -o build/account-report cobol/ACCOUNT-REPORT.cob
./build/account-report
