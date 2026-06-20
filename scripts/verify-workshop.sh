#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
check() {
  if [ -e "$1" ]; then
    printf "  ✅ %s\n" "$1"
  else
    printf "  ❌ %s (missing)\n" "$1"
    fail=1
  fi
}

echo "🔎 Workshop docs"
check README.md
check docs/scenario-1-openspec-todo.md
check docs/scenario-2-plan-mode-bookshelf.md
check docs/scenario-3-speckit-cobol.md
check docs/scenario-4-cli-squad-assistant.md
check docs/scenario-5-speckit-etl-pipeline.md
check docs/scenario-6-speckit-angular-react.md

echo ""
echo "🔎 MCP and editor config"
check .mcp.json
check .vscode/mcp.json
check .vscode/extensions.json
check .devcontainer/devcontainer.json

echo ""
echo "🔎 Skills"
check .github/skills/frontend-design/SKILL.md
check .github/skills/legacy-cobol-explorer/SKILL.md

echo ""
echo "🔎 Sample apps"
check examples/bookshelf-app/server.mjs
check examples/bookshelf-app/public/index.html
check examples/bookshelf-app/data/books.json
check examples/legacy-cobol-library/cobol/ACCOUNT-REPORT.cob
check examples/legacy-cobol-library/data/accounts.dat
check examples/legacy-cobol-library/data/transactions.dat
check examples/legacy-cobol-library/expected-output.txt
check examples/legacy-cobol-library/run.sh
check examples/etl-climate-pipeline/docker-compose.yml
check examples/angular-realworld-react/README.md

echo ""
echo "🔎 Videos"
check media/videos/scenario-1-openspec-greenfield.mp4
check media/videos/scenario-2-plan-mode.mp4
check media/videos/scenario-3-speckit-legacy-modernization.mp4
check media/videos/scenario-4-squad-cli.mp4
check media/videos/scenario-5-cli-etl-pipeline.mp4
check media/videos/scenario-6-angular-react.mp4

echo ""
echo "🔎 JSON validity"
for f in .mcp.json .vscode/mcp.json .vscode/extensions.json .devcontainer/devcontainer.json examples/bookshelf-app/package.json examples/bookshelf-app/data/books.json; do
  if node -e "JSON.parse(require('fs').readFileSync('$f','utf8'))" 2>/dev/null; then
    printf "  ✅ %s parses\n" "$f"
  else
    # devcontainer.json allows comments — skip strict parse
    if [[ "$f" == *devcontainer.json || "$f" == *extensions.json || "$f" == *vscode/* ]]; then
      printf "  ⚠️  %s may use JSONC (skipping strict parse)\n" "$f"
    else
      printf "  ❌ %s does not parse\n" "$f"
      fail=1
    fi
  fi
done

echo ""
if [ "$fail" -eq 0 ]; then
  echo "✅ All checks passed."
else
  echo "❌ Some checks failed."
  exit 1
fi
