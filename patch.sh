#!/bin/bash
# HyperLnx OS — Upstream Patch Script
# Pulls latest OpenClaw changes without touching HyperLnx brand layer
# Usage: bash patch.sh [--dry-run]

set -e

UPSTREAM="https://github.com/openclaw/openclaw"
PROTECT_FILE=".upstream-protect"
DRY_RUN=false

[[ "$1" == "--dry-run" ]] && DRY_RUN=true

echo "==================================="
echo "  HyperLnx OS — Upstream Patcher"
echo "==================================="

# Ensure upstream remote exists
if ! git remote | grep -q "^upstream$"; then
  echo "[+] Adding upstream remote..."
  git remote add upstream "$UPSTREAM"
fi

# Fetch latest from upstream
echo "[+] Fetching from openclaw/openclaw..."
git fetch upstream

# Read protected directories
PROTECTED=()
while IFS= read -r line; do
  [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
  PROTECTED+=("$line")
done < "$PROTECT_FILE"

echo "[+] Protected paths:"
for p in "${PROTECTED[@]}"; do echo "    - $p"; done

if $DRY_RUN; then
  echo ""
  echo "[DRY RUN] Would merge upstream/main protecting: ${PROTECTED[*]}"
  echo "[DRY RUN] Changes that would arrive:"
  git log HEAD..upstream/main --oneline | head -20
  exit 0
fi

# Stash any local changes
git stash push -m "pre-patch stash $(date +%Y%m%d%H%M%S)" 2>/dev/null || true

# Merge upstream — protected dirs use ours strategy
echo "[+] Merging upstream/main..."
git merge upstream/main --no-edit -X ours 2>/dev/null || {
  echo "[!] Merge conflict — restoring protected files..."
  for path in "${PROTECTED[@]}"; do
    git checkout HEAD -- "$path" 2>/dev/null || true
  done
  git add .
  git commit -m "chore: merge upstream openclaw patch ($(date +%Y-%m-%d))"
}

# Force-restore all protected paths from HEAD (our version always wins)
echo "[+] Restoring protected HyperLnx files..."
for path in "${PROTECTED[@]}"; do
  if [ -e "$path" ]; then
    git checkout HEAD -- "$path" 2>/dev/null || true
  fi
done

# Restore stash if any
git stash pop 2>/dev/null || true

# Update npm dependencies if package.json changed
if git diff HEAD~1 --name-only | grep -q "package.json"; then
  echo "[+] package.json changed — running npm install..."
  npm install
fi

echo ""
echo "[✓] Patch complete."
echo "[✓] OpenClaw engine updated. HyperLnx brand layer intact."
echo ""
git log --oneline -5
