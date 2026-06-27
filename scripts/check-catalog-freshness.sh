#!/bin/sh
# check-catalog-freshness.sh — the synced-catalog freshness gate (ADR-0115, gate 0115-catalog-freshness).
#
# ADR-0115 ("Synced workspace catalogs must be links or freshness-gated — no orphaned copies"):
# the governed skills catalog (corpus-skills) is the single source for the universal, framework-free
# skills, but the workspace keeps a hand-synced copy at corpus-works/.agents/skills that the live
# .claude/skills symlinks into. A copy that can drift will drift (the Phase-3 sweep found it 2+ days
# stale — missing skills the catalog had added, still hosting one it had retired). This is the option-2
# freshness CHECK named in ADR-0115: it diffs the copy against its source and FAILS on any divergence,
# so a stale catalog copy is caught at CI / pre-commit time instead of by a human sweep.
#
# It is a RECORD/CHECK, not an executor (ADR-0077): it diffs trees and edits nothing.
#
# What it gates (the hard, fail-on-divergence check — the no-orphaned-copy guard):
#   For every skill dir present in BOTH corpus-works/.agents/skills AND corpus-skills/skills, the
#   workspace copy must be byte-identical to the governed source — SKILL.md and every reference file.
#   Any content mismatch, or a reference file present in one but not the other, fails the gate.
#
# What it reports but does NOT fail on (kept low-false-positive per ADR-0063 — a noisy gate gets muted):
#   - Kit-sourced workspace skills (implement-task, review-output, write-*, save-findings, split-work)
#     are compared against corpus-starter-kit/.agents/skills when present there. The workspace hosts the
#     enriched/canonical body of these and the kit ships a leaner export, so they legitimately differ;
#     divergence here is NOTED, not failed. (When the kit becomes the single source for these too, flip
#     STRICT_KIT=1 to promote kit divergence to a hard failure.)
#   - A workspace skill that exists in NEITHER source (a true orphan with no upstream) is NOTED so it
#     is visible, but it is not a freshness violation of a governed catalog.
#
# Usage (run from anywhere; paths resolve from this script's location):
#   sh corpus/scripts/check-catalog-freshness.sh        → exit 0 clean, 1 on catalog divergence.
# Override discovered paths with WORKS_SKILLS / CATALOG_SKILLS / KIT_SKILLS if your checkout differs.
# Set STRICT_KIT=1 to make kit-source divergence a hard failure too.
set -eu

# Resolve the family root from this script's location: corpus/scripts/ -> corpus/ -> dev/ (the family).
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
FAMILY_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)

WORKS_SKILLS=${WORKS_SKILLS:-"$FAMILY_ROOT/corpus-works/.agents/skills"}
CATALOG_SKILLS=${CATALOG_SKILLS:-"$FAMILY_ROOT/corpus-skills/skills"}
KIT_SKILLS=${KIT_SKILLS:-"$FAMILY_ROOT/corpus-starter-kit/.agents/skills"}
STRICT_KIT=${STRICT_KIT:-0}

if [ ! -d "$WORKS_SKILLS" ]; then
    echo "check-catalog-freshness: cannot find the workspace skills copy at: $WORKS_SKILLS" >&2
    echo "  Set WORKS_SKILLS to the corpus-works/.agents/skills directory." >&2
    exit 2
fi
if [ ! -d "$CATALOG_SKILLS" ]; then
    echo "check-catalog-freshness: cannot find the governed catalog at: $CATALOG_SKILLS" >&2
    echo "  Set CATALOG_SKILLS to the corpus-skills/skills directory." >&2
    exit 2
fi

echo "check-catalog-freshness: ADR-0115 freshness gate"
echo "  workspace copy : $WORKS_SKILLS"
echo "  catalog source : $CATALOG_SKILLS"
[ -d "$KIT_SKILLS" ] && echo "  kit source     : $KIT_SKILLS (informational)"
echo ""

# diff_skill_tree SRC_DIR DST_DIR — print one "  <relpath>" line per differing/orphan file under the
# two skill dirs (SKILL.md and any references). Emits nothing when the trees are byte-identical.
# Uses `diff -rq` and rewrites its output into source-relative file paths.
diff_skill_tree() {
    _src=$1
    _dst=$2
    diff -rq "$_src" "$_dst" 2>&1 | while IFS= read -r line; do
        case "$line" in
            "Files "*" differ")
                # "Files A and B differ" -> the path under A (one entry per differing file).
                f=${line#Files }
                f=${f% and *}
                rel=${f#"$_src"/}
                echo "  changed: $rel"
                ;;
            "Only in "*)
                # "Only in DIR: name" -> a file present on one side but not the other.
                rest=${line#Only in }
                d=${rest%%: *}
                n=${rest#*: }
                case "$d" in
                    "$_src"*) side="missing-in-copy" ; rel=${d#"$_src"} ;;
                    "$_dst"*) side="extra-in-copy"   ; rel=${d#"$_dst"} ;;
                    *)        side="diff"            ; rel=$d ;;
                esac
                rel=${rel#/}
                if [ -n "$rel" ]; then
                    echo "  $side: $rel/$n"
                else
                    echo "  $side: $n"
                fi
                ;;
        esac
    done
}

catalog_fail=0
kit_fail=0
checked_catalog=0
noted_kit=0
noted_orphan=0

# Walk every skill dir in the workspace copy. Classify by which source(s) host it, then check.
for skill_path in "$WORKS_SKILLS"/*/; do
    [ -d "$skill_path" ] || continue
    skill_path=${skill_path%/}   # drop trailing slash so it matches `diff`'s reported paths
    skill=$(basename "$skill_path")

    in_catalog=0; [ -d "$CATALOG_SKILLS/$skill" ] && in_catalog=1
    in_kit=0;     [ -d "$KIT_SKILLS/$skill" ]     && in_kit=1

    if [ "$in_catalog" -eq 1 ]; then
        # GOVERNED CATALOG: hard gate — must be byte-identical to the source.
        checked_catalog=$((checked_catalog + 1))
        diffs=$(diff_skill_tree "$CATALOG_SKILLS/$skill" "$skill_path" || true)
        if [ -n "$diffs" ]; then
            catalog_fail=1
            echo "FAIL [catalog] $skill — workspace copy diverged from corpus-skills:" >&2
            printf '%s\n' "$diffs" >&2
        fi
    elif [ "$in_kit" -eq 1 ]; then
        # KIT-SOURCED: compare against the kit, but report-only unless STRICT_KIT=1.
        diffs=$(diff_skill_tree "$KIT_SKILLS/$skill" "$skill_path" || true)
        if [ -n "$diffs" ]; then
            if [ "$STRICT_KIT" = "1" ]; then
                kit_fail=1
                echo "FAIL [kit] $skill — workspace copy diverged from corpus-starter-kit:" >&2
                printf '%s\n' "$diffs" >&2
            else
                noted_kit=$((noted_kit + 1))
                echo "note [kit] $skill — differs from corpus-starter-kit (workspace is the enriched copy):"
                printf '%s\n' "$diffs"
            fi
        fi
    else
        # No source in either governed tree.
        noted_orphan=$((noted_orphan + 1))
        echo "note [orphan] $skill — present in the workspace but in neither corpus-skills nor corpus-starter-kit."
    fi
done

echo ""
if [ "$catalog_fail" -ne 0 ] || [ "$kit_fail" -ne 0 ]; then
    echo "check-catalog-freshness: FAIL — a synced catalog copy has drifted from its source (ADR-0115)." >&2
    echo "  Resync the diverging skill(s) from the source listed above so the workspace copy matches," >&2
    echo "  or relink the catalog to its single source (ADR-0115 option 1)." >&2
    exit 1
fi

echo "check-catalog-freshness: OK — $checked_catalog catalog skill(s) in sync with corpus-skills (no drift)."
[ "$noted_kit" -gt 0 ]    && echo "  ($noted_kit kit-sourced skill(s) differ from corpus-starter-kit — noted, not gated.)"
[ "$noted_orphan" -gt 0 ] && echo "  ($noted_orphan workspace skill(s) have no upstream source — noted.)"
exit 0
