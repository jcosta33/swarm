# 🪞 Walkthrough: bug report → fix → review → merge

> A complete bug-fix workflow showing the bug-hunt → fix split. The Bug Hunter produces a report; the Skeptic-as-fixer patches the root cause and adds a regression test.

---

## 🎬 The scenario

A user reports: *"After uploading a 12 MB CSV, the export download silently produces a corrupt file (rows missing). 4 MB CSV works fine."*

The Lead Engineer (or human) launches a `bug-report-writing` task. The Bug Hunter takes it.

---

## 🐛 Phase 1: bug-report-writing (The Bug Hunter)

The Bug Hunter writes `.agents/bugs/csv-export-truncation.md` (the full report appears in [The Bug Hunter's worked example](../personas/the-bug-hunter.md#%EF%B8%8F-example-how-the-bug-hunter-resolves-a-representative-issue)).

Key contents:

- **Reliable reproduction:** `NODE_ENV=production` + ≥ 8 MB CSV upload + GET /api/export.
- **Hypothesis 1 (disproven):** `BUFFER_SIZE = 4 * 1024 * 1024` too small. Patched to 16 MB; bug still fires.
- **Hypothesis 2 (confirmed):** `src/server/proxy.ts:88` resets `response.bytesWritten = 0` after `flush()`, breaking chunked-encoding offset.
- **Root cause:** stated as file:line + state + interaction with the streaming export.
- **Related defects:** `src/api/streaming/file-download.ts:55` shares the pattern.
- **Regression test plan:** `tests/server/proxy.streaming.test.ts` streaming ≥ 16 MB and asserting byte-count parity.

Self-review confirms: bug reproduced deterministically, hypotheses tested with evidence, root cause precise, related defect found, regression test plan included, no source changes (`git status` clean).

Status: `done`. The bug report is durable; the fix is the next task.

---

## 🟥 Phase 2: fix (The Skeptic-as-fixer)

A new task is spawned: `fix-csv-export-truncation`. The Skeptic-as-fixer takes it.

### Pre-flight

The Skeptic:

1. Reads the task file.
2. Loads the Skeptic persona (in fixer mode).
3. Reads `.agents/bugs/csv-export-truncation.md` in full.
4. Loads the relevant skills (`write-fix`, `adversarial-review`, `empirical-proof`).

### Re-reproduce

The Skeptic does *not* trust the bug report's reproduction at face value. They re-run it in their own worktree:

```bash
$ NODE_ENV=production pnpm dev &
$ curl -X POST -F file=@fixtures/synthetic-12mb.csv http://localhost:3000/api/upload
{"id": "upl_abc123"}
$ curl -X GET http://localhost:3000/api/export?id=upl_abc123 -o /tmp/exported.csv
$ wc -l fixtures/synthetic-12mb.csv /tmp/exported.csv
  240000 fixtures/synthetic-12mb.csv
   84021 /tmp/exported.csv
```

The bug fires (only 84,021 of 240,000 rows downloaded). Pasted into Self-review:

```markdown
## Reproduction

[paste of the above]

The bug fires deterministically. Confirmed.
```

### Patch the root cause

The Skeptic reads `src/server/proxy.ts:88` directly:

```ts
// before
if (response.bytesWritten >= STREAM_FLUSH_THRESHOLD) {
  response.flush();
  response.bytesWritten = 0;  // ← the bug
}
```

The patch:

```ts
// after
if (response.bytesWritten >= STREAM_FLUSH_THRESHOLD) {
  response.flush();
  // Do not reset bytesWritten; the streaming export's chunked-encoding state
  // depends on the cumulative offset. The local counter resets on next flush
  // via the framework's own bookkeeping. (Fix: csv-export-truncation, see
  // .agents/bugs/csv-export-truncation.md)
}
```

### Add the regression test

Per the bug report's regression test plan, the Skeptic adds `tests/server/proxy.streaming.test.ts`:

```ts
import { describe, it, expect } from 'vitest';
import { createTestServer, streamFromBuffer } from '@/test/fixtures';

describe('proxy streaming under load', () => {
  it('preserves byte-count parity when streaming >= 16 MB through the proxy', async () => {
    const server = await createTestServer({ env: 'production' });
    const sentBytes = 16 * 1024 * 1024 + 1024;  // 16 MB + 1 KB to cross the threshold
    const sentBuffer = Buffer.alloc(sentBytes, 'A');

    const response = await server.fetch('/api/test-stream', {
      method: 'POST',
      body: streamFromBuffer(sentBuffer),
    });

    const receivedBuffer = Buffer.from(await response.arrayBuffer());
    expect(receivedBuffer.length).toBe(sentBytes);
    expect(receivedBuffer.equals(sentBuffer)).toBe(true);
  });
});
```

### Verify the regression test fires before the fix

The Skeptic patches out their fix temporarily (puts back `response.bytesWritten = 0`) and runs the test:

```
$ pnpm test tests/server/proxy.streaming.test.ts
● proxy streaming under load > preserves byte-count parity when streaming >= 16 MB through the proxy
  expected 11534336 to be 16778240
Tests:       1 failed, 0 passed
```

Test fires. The Skeptic restores the fix and re-runs:

```
$ pnpm test tests/server/proxy.streaming.test.ts
Tests:       1 passed
Time:        0.4 s
```

Test passes. Both outputs pasted into Self-review.

### Self-review

```markdown
## Self-review

> **Hard gate.** ...

### Verification outputs

- `git status` →
  ```
  modified:   src/server/proxy.ts (1 line removed, 1 comment added)
  new file:   tests/server/proxy.streaming.test.ts
  ```

- Pre-patch reproduction (the bug actually fires):
  ```
  240000 fixtures/synthetic-12mb.csv
   84021 /tmp/exported.csv
  ```

- Post-patch reproduction:
  ```
  240000 fixtures/synthetic-12mb.csv
  240000 /tmp/exported-fixed.csv
  ```

- `pnpm validate` (last 2 lines):
  ```
  ✓ all checks passed
  Done in 7.2s
  ```

- `pnpm test` (last 2 lines):
  ```
  Tests:       413 passed, 413 total
  Time:        9.2 s
  ```

- `git diff --stat`:
  ```
   src/server/proxy.ts                    | 4 +++-
   tests/server/proxy.streaming.test.ts   | 22 ++++++++++++++++++++++
   2 files changed, 25 insertions(+), 1 deletion(-)
  ```

### Root-cause coverage

I patched the root cause at `src/server/proxy.ts:88` (the `response.bytesWritten = 0` reset). The
symptom (corrupt file) is downstream of this; the fix removes the cause, not the symptom.

The bug report listed `src/api/streaming/file-download.ts:55` as a related defect with the same
pattern. **My fix addresses the proxy; it does NOT address the related file.** The related defect
needs a separate fix or is included in scope per the bug report's recommendation.

I'm scoping this fix to the proxy as named in the task. Recommendation in `## Next steps`: spawn
a follow-up bug-report or expand-scope decision for the related defect.

### Regression test integrity

I patched out the fix and ran the test → it failed (output above). Restored the fix and ran → it
passed. The test exercises the bug; it's not a tautology.

### Side effects

`pnpm test` shows 413 tests passing (412 previously + 1 new regression test). No other tests broke;
no behavioural drift outside the patched code path.

### Related defects

Listed in the bug report (`.agents/bugs/csv-export-truncation.md`). I did *not* fix
`src/api/streaming/file-download.ts:55` in this task (out of scope). Promoted to follow-up; see
`## Next steps`.

### Final Polish

The fix is minimal: one line removed (and a comment added pointing to the bug report). I did not
restructure the proxy or "improve" the chunked-encoding logic while I was there. The patch is
exactly what the root cause requires.

## Next steps

- Spawn a follow-up `bug-report-writing` task for `src/api/streaming/file-download.ts:55` (same
  root cause; needs its own reproduction + fix).
- Hand off to The Skeptic for re-review (since my Skeptic-as-fixer mode authored the fix, a fresh
  Skeptic session reviews).
```

---

## 🟥 Phase 3: re-review

A fresh `review` task is spawned with the Skeptic-as-fixer's branch as the source. A different agent (or the same agent in a fresh session) adopts the Skeptic stance and reviews.

The reviewer:

- Re-runs the reproduction in their own worktree (still fires before the fix; passes after).
- Walks the patched code with the six adversarial questions.
- Confirms the regression test exercises the bug.
- Confirms `pnpm test` and `pnpm validate` pass.
- Confirms no scope creep (the diff is 1 line + comment + new test).
- Confirms the related-defect promotion in `## Next steps` is concrete.

**Verdict: APPROVE.**

The branch merges. The bug report's status updates to `Closed`; archived to `.agents/bugs/closed/`.

---

## 📜 What changed in the durable docs

- `.agents/bugs/csv-export-truncation.md` — `Status` updated to `Closed`. Moved to `.agents/bugs/closed/`. The fix's commit hash linked from the report.
- A new bug report at `.agents/bugs/file-download-streaming.md` (or similar) for the related defect.
- `src/server/proxy.ts` — patched (1 line + comment).
- `tests/server/proxy.streaming.test.ts` — new regression test.
- The Bug Hunter's task file and the Skeptic-as-fixer's task file — *deleted* with the worktrees.

---

## 🪞 Why the bug-hunt ↔ fix split matters

The Bug Hunter's session was *forensic*: reproduce, hypothesise, test, identify root cause. The Skeptic-as-fixer's session was *surgical*: patch the cause, prove the patch works, prove the bug stays fixed.

These are different mindsets. Combined into one task, the temptation is to short-circuit the diagnosis at the first plausible explanation (the buffer size in this case). Splitting forced the diagnosis to stand on its own — the Bug Hunter ran two hypotheses with evidence; the buffer-size explanation was disproven before the proxy explanation was confirmed.

The Skeptic-as-fixer then trusted the bug report's diagnosis (because it stood up to scrutiny) and patched at the root. The split protected the chain end-to-end.

See [ADR 0007](../adrs/0007-bug-report-as-meta-task.md) for the full rationale.

---

## See also

- [`tasks/bug-report-writing.md`](../tasks/bug-report-writing.md)
- [`tasks/fix.md`](../tasks/fix.md)
- [`personas/the-bug-hunter.md`](../personas/the-bug-hunter.md)
- [`personas/the-skeptic.md`](../personas/the-skeptic.md)
- [`skills/write-bug-report.md`](../skills/write-bug-report.md), [`skills/write-fix.md`](../skills/write-fix.md)
- [ADR 0007](../adrs/0007-bug-report-as-meta-task.md)
