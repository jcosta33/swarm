#!/bin/sh
# lint-artifact-refs.sh — the retired/relocated-artifact reference linter (ADR-0114 / AC-004).
#
# The re-architecture (8→6 agents, 7→11 skills, the kit/catalog split of ADR-0112) retired a set of
# agents, skills, and MCP tools. The Phase-3 family sweep found product/reference docs still naming
# retired artifacts as if active — a cross-repo fact restated by hand instead of resolved against one
# source. This linter is the gate that sweep found missing: it reads the NON-ACTIVE names from the
# canonical registry (docs/artifact-registry.md) and fails when a product or reference doc names one
# as if it were live.
#
# It is a RECORD/CHECK, not an executor (ADR-0077): it greps and reports; it edits nothing. And it is
# the SHIPPED check (ADR-0063), so it is kept LOW false-positive on purpose — a noisy gate gets muted:
#
#   SCOPE   — product + reference docs only: each repo's root README.md and docs/**/*.md.
#             NOT scanned: docs/adrs/** (immutable history that legitimately names retired things —
#             ADR-0114 §Consequences), CHANGELOG.md (release history), source/test code, node_modules.
#   EXCLUDE — the registry itself (it is the one place these names are catalogued) and the redirect-
#             stub files that legitimately self-name (a stub's whole job is to carry its own name).
#   ALLOW   — a mention on a line that ALSO carries retirement/redirect vocabulary (retired, redirect,
#             former, merged, folded, "no separate", "used to", …) is a legitimate redirect note, not
#             a stale active-reference. Only a NON-ACTIVE name with no such context on its line fails.
#
# Self-test: clean now over the real trees → exit 0; seed a doc naming a retired name as active → 1.
# Usage: run from anywhere.  `sh scripts/lint-artifact-refs.sh`  → exit 0 clean, non-zero on a hit.
set -eu

# Resolve the corpus repo root from this script's location, then the family root (its parent), so the
# linter can reach the sibling repos from any cwd / in CI.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CORPUS_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
FAMILY_ROOT=$(CDPATH= cd -- "$CORPUS_ROOT/.." && pwd)

REGISTRY="$CORPUS_ROOT/docs/artifact-registry.md"
if [ ! -f "$REGISTRY" ]; then
    echo "lint-artifact-refs: cannot find the registry at $REGISTRY" >&2
    echo "  This linter reads the non-active names from docs/artifact-registry.md (ADR-0114)." >&2
    exit 2
fi

# The repos whose product/reference docs are in scope. Only those present are scanned.
REPOS="corpus corpus-agents corpus-skills corpus-mcp corpus-cli corpus-starter-kit corpus-bench"

# Retirement/redirect vocabulary: a line carrying any of these is a legitimate redirect note, so a
# non-active name appearing on it is allowed (not a stale active-reference).
RETIRE_RE='retir|redirect|former|deprecat|relocat|folded|folds into|absorb|merged|spine of|no separate|used to|now the|the old |is gone|replaced by|points elsewhere'

# ---------------------------------------------------------------------------------------------------
# 1. Extract the NON-ACTIVE names from the registry's artifact tables.
#    Only the Agents / Skills / MCP-tools sections list artifacts; the "## Status values" legend is
#    skipped (its rows name status keywords, not artifacts). A registry row is:
#        | `name` | <status> | … |
#    and is NON-ACTIVE when the status cell BEGINS with retired / redirect-stub / relocated.
#    (active and "active (kit)" begin with "active" and are skipped.)
# ---------------------------------------------------------------------------------------------------
NON_ACTIVE=$(
    awk -F'|' '
        # Track which section we are in; only artifact sections contribute names.
        /^##[[:space:]]+Status values/   { in_artifacts = 0; next }
        /^##[[:space:]]+Agents/          { in_artifacts = 1; next }
        /^##[[:space:]]+Skills/          { in_artifacts = 1; next }
        /^##[[:space:]]+MCP tools/       { in_artifacts = 1; next }
        /^##[[:space:]]/                 { in_artifacts = 0; next }  # any other top section
        in_artifacts && /^\|[[:space:]]*`[^`]+`[[:space:]]*\|/ {
            name = $2; status = $3
            gsub(/[`[:space:]]/, "", name)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", status)
            if (name == "" || name == "Name") next
            if (status ~ /^retired/ || status ~ /^redirect-stub/ || status ~ /^relocated/) print name
        }
    ' "$REGISTRY" | sort -u
)

if [ -z "$NON_ACTIVE" ]; then
    echo "lint-artifact-refs: no non-active names in the registry — nothing to lint. OK."
    exit 0
fi

# ---------------------------------------------------------------------------------------------------
# 2. Build the in-scope doc list: each repo's root README.md + docs/**/*.md, minus the exclusions.
# ---------------------------------------------------------------------------------------------------
DOCS=$(
    for repo in $REPOS; do
        base="$FAMILY_ROOT/$repo"
        [ -d "$base" ] || continue
        [ -f "$base/README.md" ] && printf '%s\n' "$base/README.md"
        [ -d "$base/docs" ] && find "$base/docs" -type f -name '*.md' 2>/dev/null
    done | while IFS= read -r f; do
        # Leading "(" on each pattern: a quoted pattern + ")" as the FIRST case arm inside $(...)
        # otherwise trips bash-in-POSIX-mode (it reads the ")" as closing the substitution).
        case "$f" in
            ("$REGISTRY")               continue ;;  # the registry catalogues these names by design
            (*/docs/adrs/*)             continue ;;  # immutable history (ADR-0114 Consequences)
            (*/CHANGELOG.md)            continue ;;  # release history legitimately names retired things
            (*/persona-skeptic/*)       continue ;;  # redirect-stub self-naming (skill)
            (*/corpus-evidence-checker*) continue ;; # redirect-stub self-naming (agent)
        esac
        printf '%s\n' "$f"
    done
)

# ---------------------------------------------------------------------------------------------------
# 3. Grep each in-scope doc for each non-active name; a hit on a line WITHOUT retirement context fails.
# ---------------------------------------------------------------------------------------------------
violations=0
for name in $NON_ACTIVE; do
    # word-ish match: the name as a token (allow backtick/quote/word boundaries around it).
    for f in $DOCS; do
        [ -f "$f" ] || continue
        grep -n -- "$name" "$f" 2>/dev/null | while IFS= read -r hit; do
            if printf '%s\n' "$hit" | grep -qiE "$RETIRE_RE"; then
                continue  # legitimate redirect/retirement note
            fi
            printf 'VIOLATION %s:%s\n' "$f" "$hit"
        done
    done
done >/tmp/lint-artifact-refs.$$ 2>/dev/null || true

if [ -s /tmp/lint-artifact-refs.$$ ]; then
    echo "lint-artifact-refs: FAIL — product/reference doc(s) name a NON-ACTIVE artifact as if active:" >&2
    echo "" >&2
    # Re-print each hit with a pointer to the registry status, trimmed for readability.
    while IFS= read -r v; do
        # v looks like: VIOLATION <file>:<lineno>:<text>
        loc=$(printf '%s' "$v" | sed -e 's/^VIOLATION //')
        echo "  $loc" | cut -c1-200 >&2
    done < /tmp/lint-artifact-refs.$$
    echo "" >&2
    echo "  Each name above is non-active in $REGISTRY." >&2
    echo "  Fix: link to the registry / name the replacement, or move the mention into history (ADR/CHANGELOG)." >&2
    echo "  If the mention is a legitimate redirect note, phrase it as one (retired / former / redirects to …)." >&2
    violations=1
fi
rm -f /tmp/lint-artifact-refs.$$

if [ "$violations" -ne 0 ]; then
    exit 1
fi

echo "lint-artifact-refs: OK — no product/reference doc names a non-active artifact as active."
echo "  Scanned $(printf '%s\n' "$DOCS" | grep -c . ) doc(s) for: $(printf '%s ' $NON_ACTIVE)"
