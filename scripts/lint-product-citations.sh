#!/bin/sh
# lint-product-citations.sh — the ADR-0113 product-vs-docs citation gate (method-gate 0113-product-citations).
#
# Product surfaces (what a user installs and reads) must not carry the workspace's internal
# provenance markers. Those markers are how the Suspec repo records WHY a decision was made
# (ADR-NNNN), what audit surfaced a fact (AUDIT-...), and where a primary source lives
# (github / doi.org URLs). They belong in the docs/specs/ADRs of the Suspec workspace, NOT in
# the shipped skill guides, agent definitions, and product READMEs — a user reading a SKILL.md
# should see the rule, not the citation trail behind it.
#
# This gate greps the PRODUCT MARKDOWN files for those forbidden markers and fails on any hit.
# It is a RECORD/CHECK, not an executor (ADR-0077): it reads and reports, it edits nothing.
#
# SCOPE — deliberately MARKDOWN-ONLY, to stay low false-positive (ADR-0063: a noisy gate gets
# muted). In a .md product file a citation is unambiguously a citation. In a code file (e.g.
# suspec-mcp/src/tools.ts) grep cannot tell a forbidden citation in prose from the same string
# inside a code comment or a test fixture, so code files are OUT OF SCOPE here — they are
# reviewed by a human, not linted by this gate.
#
# The linted set, per repo (sibling repos under /Users/josecosta/dev by default):
#   suspec-skills/skills/<name>/SKILL.md          + that skill's references/*.md
#   suspec-agents/agents/*.md                     (top-level agent definitions)
#   suspec-starter-kit/.agents/skills/<name>/SKILL.md
#   suspec-skills/README.md , suspec-mcp/README.md   (the two product READMEs)
#
# Forbidden patterns (extended regex):
#   ADR-[0-9]            an Architecture Decision Record reference
#   AUDIT-               an audit reference
#   https?://github      a GitHub source URL  (http or https)
#   doi.org              a DOI source URL
#
# Usage:
#   scripts/lint-product-citations.sh [REPO_PARENT_DIR]
#     REPO_PARENT_DIR  directory holding the sibling repos (suspec-skills, suspec-agents, …).
#                      Defaults to /Users/josecosta/dev. Pass a temp dir to self-test a seed.
#
# Exit: 0 when every linted file is clean; 1 on any forbidden citation; 2 on a usage/scope error.
set -eu

# --- Resolve the parent directory that holds the sibling product repos ---------
DEV_DIR="${1:-/Users/josecosta/dev}"
if [ ! -d "$DEV_DIR" ]; then
    echo "lint-product-citations: not a directory: $DEV_DIR" >&2
    echo "  Pass the directory that holds the sibling repos (suspec-skills, suspec-agents, …)," >&2
    echo "  or run with no argument to use the default (/Users/josecosta/dev)." >&2
    exit 2
fi

# Forbidden-citation patterns (extended regex). A skill/agent BODY carries no sourcing at all —
# including source URLs. A product README legitimately links to the repo and install instructions, so
# a README forbids only the provenance CITATIONS (ADR-/AUDIT-/doi), never github repo/install URLs.
FORBIDDEN_BODY='ADR-[0-9]|AUDIT-|https?://github|doi\.org'
FORBIDDEN_README='ADR-[0-9]|AUDIT-|doi\.org'

# --- Collect the in-scope product markdown files ------------------------------
# Built into a newline-delimited list so paths with unusual characters survive; the find
# expressions encode the scope exactly (markdown only; the named subtrees only).
repo_dir() {
    new=$1
    old=$2
    if [ -d "$DEV_DIR/$new" ]; then
        printf '%s\n' "$DEV_DIR/$new"
    elif [ -d "$DEV_DIR/$old" ]; then
        printf '%s\n' "$DEV_DIR/$old"
    else
        printf '%s\n' "$DEV_DIR/$new"
    fi
}

SUSPEC_SKILLS_DIR=$(repo_dir suspec-skills corpus-skills)
SUSPEC_AGENTS_DIR=$(repo_dir suspec-agents corpus-agents)
SUSPEC_KIT_DIR=$(repo_dir suspec-starter-kit corpus-starter-kit)
SUSPEC_MCP_DIR=$(repo_dir suspec-mcp corpus-mcp)

files=$(
    # suspec-skills: each skill's SKILL.md + that skill's references/*.md
    if [ -d "$SUSPEC_SKILLS_DIR/skills" ]; then
        find "$SUSPEC_SKILLS_DIR/skills" -type f \
            \( -name 'SKILL.md' -o -path '*/references/*.md' \)
    fi
    # suspec-agents: top-level agent definitions only
    if [ -d "$SUSPEC_AGENTS_DIR/agents" ]; then
        find "$SUSPEC_AGENTS_DIR/agents" -maxdepth 1 -type f -name '*.md'
    fi
    # suspec-starter-kit: bundled skill guides (.claude/skills is a symlink to this)
    if [ -d "$SUSPEC_KIT_DIR/.agents/skills" ]; then
        find "$SUSPEC_KIT_DIR/.agents/skills" -type f -name 'SKILL.md'
    fi
    # The two product READMEs (named explicitly; print only if present).
    # NB: the final command in this $(...) must succeed, or `set -e` would fail the
    # whole assignment — so the `[ -f ]` test is guarded with `|| :` (true) and the
    # loop closes cleanly even when a README is absent (e.g. a partial seed tree).
    for r in "$SUSPEC_SKILLS_DIR/README.md" "$SUSPEC_MCP_DIR/README.md"; do
        if [ -f "$r" ]; then printf '%s\n' "$r"; fi
    done
    :
)

# A scope that matched nothing means the parent dir is wrong — fail loudly, don't pass vacuously.
if [ -z "$files" ]; then
    echo "lint-product-citations: no in-scope product markdown files found under $DEV_DIR" >&2
    echo "  Expected sibling repos like $DEV_DIR/suspec-skills, $DEV_DIR/suspec-agents." >&2
    echo "  Check the REPO_PARENT_DIR argument." >&2
    exit 2
fi

# --- Grep each file; collect offending file:line lines ------------------------
# grep -H prints file:line:match; we keep the file:line and the matched text for the report.
# `set +e` around the grep so a clean file (grep exit 1) does not trip `set -e`.
hits=$(
    printf '%s\n' "$files" | while IFS= read -r f; do
        [ -n "$f" ] || continue
        case "$f" in
            (*/README.md) pat="$FORBIDDEN_README" ;;
            (*)           pat="$FORBIDDEN_BODY" ;;
        esac
        grep -HnE "$pat" "$f" 2>/dev/null || true
    done
)

count=$(printf '%s\n' "$files" | grep -c . || true)

if [ -n "$hits" ]; then
    echo "lint-product-citations: FAIL — forbidden citations in product markdown:" >&2
    printf '%s\n' "$hits" >&2
    echo "" >&2
    echo "  Product surfaces must not carry workspace provenance markers" >&2
    echo "  (ADR-NNNN, AUDIT-…, github/doi.org URLs). Move the citation to the" >&2
    echo "  suspec workspace docs and state only the rule in the product file." >&2
    exit 1
fi

echo "lint-product-citations: OK — $count product markdown file(s) clean (no ADR/AUDIT/source-URL citations)."
