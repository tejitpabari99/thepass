#!/usr/bin/env bash
# Checks: star is a suggestion only, setup ping files, privacy docs. Usage: bash tests/test_star_and_ping.sh
set -u
here=$(cd "$(dirname "$0")/.." && pwd)
gh="$here/plugin/skills/start/references/github-connect.md"
ping="$here/plugin/skills/start/references/usage-ping.md"
skill="$here/plugin/skills/start/SKILL.md"
fail=0
ok() { echo "ok   $1"; }
bad() { fail=$((fail + 1)); echo "FAIL $1"; }
has() { grep -qF -- "$2" "$3" 2>/dev/null && ok "$1" || bad "$1"; }
lacks() { grep -qF -- "$2" "$3" 2>/dev/null && bad "$1" || ok "$1"; }
lacks "github-connect: no user/starred" "user/starred" "$gh"
lacks "github-connect: no gh api -X PUT" "gh api -X PUT" "$gh"
has "usage-ping: plugin=thepass" "plugin=thepass" "$ping"
has "usage-ping: event=setup_done" "event=setup_done" "$ping"
[ -f "$here/plugin/skills/start/references/identity.md" ] && ok "identity.md exists" || bad "identity.md exists"
[ -f "$here/PRIVACY.md" ] && ok "PRIVACY.md exists" || bad "PRIVACY.md exists"
[ -f "$here/TERMS.md" ] && ok "TERMS.md exists" || bad "TERMS.md exists"
has "start SKILL references identity.md" "references/identity.md" "$skill"
idf="$here/plugin/skills/start/references/identity.md"
has "identity: anonymous org id fallback" 'org_' "$idf"
lacks "identity: no 'stop there'" "stop there" "$idf"
lacks "identity: org not required" "is required" "$idf"
lacks "identity: no 'needs an organization'" "needs an organization" "$idf"
echo "failed: $fail"
[ "$fail" -eq 0 ]
