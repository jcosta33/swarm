---
type: spec
id: SPEC-triage
title: Triage queue
status: ready
owner: support-platform
sources:
  - intake/sup-204.md
---

# Triage queue

## Intent

A minimal internal triage queue so support can post, sort, and close issues without a
spreadsheet.

## Non-goals

- No auth, no per-user views, no notifications — a single shared queue only.

## Requirements

### AC-001 — post an issue

When a client POSTs `/issues` with `{title, severity}`, the service must create the issue and
return `201` with its id.

Verify with: `pytest tests/test_triage.py::test_post_creates`

### AC-002 — open queue sorted by severity

When a client GETs `/issues`, the service must return the open issues ordered by severity, high
first.

Verify with: `pytest tests/test_triage.py::test_sorted_high_first`

### AC-003 — reject an unknown severity

If a POST `/issues` body carries a severity outside `[low, med, high]`, the service must respond
`400`.

Verify with: `pytest tests/test_triage.py::test_unknown_severity_400`

## Open questions

- none

## Affected areas

- `src/triage.py`

## Dropped from sources

- The "sorted by severity" tie-break order within a severity is unspecified — left FIFO.
