# Example: feature from ticket

Goal: turn one ticket into a reviewed feature.

## Ticket

```text
WEB-123

Add a "Download CSV" button to the report page.
It should export the currently filtered rows.
```

## Intake

`intake/web-123.md`

```markdown
---
type: intake
source: WEB-123
url: https://tracker.example/WEB-123
captured: 2026-06-20
---

Add a "Download CSV" button to the report page.
It should export the currently filtered rows.
```

## Spec

`specs/report-csv/spec.md`

```markdown
---
type: spec
id: SPEC-report-csv
title: Report CSV export
status: ready
owner: reporting-team
sources:
  - intake/web-123.md
---

# Report CSV export

## Intent

Users can export the rows currently visible in the report.

## Non-goals

- No scheduled exports.
- No export of hidden or unfiltered rows.

## Requirements

### AC-001 - Export visible rows

The report page must export the currently filtered rows as CSV.

Verify with: `npm run test:e2e -- report-csv-export`

## Open questions

- None.

## Affected areas

- `app/reports/`
- `test/e2e/`

## Dropped from sources

- None.
```

## Task

`tasks/report-csv.md`

```markdown
---
type: task
id: TASK-report-csv
source:
  - SPEC-report-csv
scope: [AC-001]
status: review-ready
---

## Scope

- AC-001 - export currently filtered rows as CSV.

## Do not change

- report filtering semantics

## Verify

- [x] `npm run test:e2e -- report-csv-export` (AC-001)

      1 passed

## Run summary

- Changed files: `app/reports/export.ts`, `app/reports/page.tsx`, `test/e2e/report-csv.spec.ts`
- Verify results:
  - `npm run test:e2e -- report-csv-export` (AC-001): PASS, output above
- Out-of-scope edits: none
- Blocked questions: none
```

## Review

`reviews/report-csv.md`

```markdown
---
type: review
id: REVIEW-report-csv
task: TASK-report-csv
status: pass
---

## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `npm run test:e2e -- report-csv-export` -> `1 passed` | no |

Spot-checked: AC-001 - reran the e2e test; output matched.

## Human attention

- None.

## Suggested decision

Merge.
```

## Close

Board:

- `TASK-report-csv`: closed, linked to `reviews/report-csv.md`

Finding:

- none. No durable lesson beyond the spec.

## Lesson

The important row is the review coverage row. It binds the ticket's acceptance criterion to evidence.
