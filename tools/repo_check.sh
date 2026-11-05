#!/bin/sh
# Repository sanity checks (stage 0.1): required files and a secret scan.
set -eu
fail=0
for f in LICENSE README.md docs/HANDOFF.md docs/PROJECT_RULES.md docs/AI_REFERENCE.md docs/adr/0000-template.md docs/architecture/spec.md docs/architecture/phase0-design.md; do
  if [ ! -f "$f" ]; then echo "MISSING: $f"; fail=1; fi
done
if ! grep -q "BSD Zero Clause License" LICENSE; then echo "LICENSE is not 0BSD"; fail=1; fi
# GitHub token prefixes must never appear in the repository.
if git grep -nE 'github_pat_[A-Za-z0-9_]{20,}|ghp_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}' -- . ':!tools/repo_check.sh'; then
  echo "SECRET-LIKE TOKEN FOUND"; fail=1
fi
exit $fail
