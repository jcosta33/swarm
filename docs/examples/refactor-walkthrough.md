# 🪞 Walkthrough: audit → refactor → review → merge

> A complete refactor workflow showing the per-checkpoint validation discipline, the shim-contract pattern, and a course correction when validation surfaces a missed nuance.

---

## 🎬 The scenario

The team's auth module has accumulated structural debt. The Auditor has produced an audit identifying 4 prioritised issues. The Lead Engineer launches a `refactor` task; the Janitor takes it.

---

## 📊 The grounding doc

`.agents/audits/auth-tokenstore-2026.md`:

```markdown
# Audit: src/auth/tokenStore.ts

## Status
Active

## Goal
Make the tokenStore module's invariants explicit and surface anything blocking the planned PKCE work.

## Findings

### Issue 1 — `oldGet`, `oldSet`, `oldDelete` deprecated; 14 callers remain [BLOCKER for Q3]
- **File:line:** `src/auth/tokenStore.ts:42`-78 (the deprecated methods)
- **Observation:** Callers are scattered across `src/auth/`, `src/api/`, `src/jobs/`. Each has been migrated to `get`/`set`/`delete` in spec, but the deprecated methods still have callers.
- **Verified by:** `git grep -n 'tokenStore\\.\\(old\\(Get\\|Set\\|Delete\\)\\)' src/` shows 14 sites
- **Needed:** Migrate all 14 callers to the modern API; delete the deprecated methods. Add a temporary shim if migration takes multiple sessions.
- **Severity:** BLOCKER

### Issue 2 — `tokenStore.legacyAdapter` has zero callers [MINOR cleanup]
- **File:line:** `src/auth/tokenStore.ts:120`-145
- **Verified by:** `git grep -n 'legacyAdapter' src/` returns no callers outside the file itself; no dynamic dispatch found
- **Needed:** Delete
- **Severity:** MINOR

### Issue 3 — TTL constant `DEFAULT_TTL = 1000 * 60 * 60` is duplicated in 3 files [MINOR]
- **File:line:** `src/auth/tokenStore.ts:8`, `src/auth/sessionStore.ts:6`, `src/auth/refreshStore.ts:5`
- **Needed:** Promote to a single shared constant in `src/auth/constants.ts`
- **Severity:** MINOR

### Issue 4 — `paymentService.create()` returns null on idempotent collision; 3 callers depend on it [MAJOR — out of scope]
- **File:line:** `src/payments/service.ts:88`
- **Verified by:** [...]
- **Needed:** Document the contract; migrate callers (separate refactor)
- **Severity:** MAJOR
- **Note:** Out of scope for this refactor; spawn a separate task driven by `.agents/audits/payments-api.md`

## Suggested approaches

For this refactor, address Issues 1, 2, 3. Issue 4 is out of scope.

Sequence:
1. Issue 1 — migrate the 14 callers; delete deprecated methods. Add `oldGet`/`oldSet`/`oldDelete` as a shim if the migration spans sessions.
2. Issue 2 — delete `legacyAdapter`.
3. Issue 3 — promote DEFAULT_TTL to `src/auth/constants.ts`; update the 3 sites.
```

---

## 🛠️ The session

The Janitor:

1. Reads the audit in full.
2. Reads the persona profile.
3. Adopts the Janitor mindset.
4. Fills in `<before_state>` and `<after_state>` in the task file:

```markdown
## Before / after state

<before_state>
- src/auth/tokenStore.ts: 4 modern methods (get/set/delete/has) + 3 deprecated methods (oldGet/oldSet/oldDelete) + legacyAdapter (0 callers)
- 14 callers of deprecated methods scattered across src/
- DEFAULT_TTL constant duplicated in 3 files
</before_state>

<after_state>
- src/auth/tokenStore.ts: 4 modern methods + (interim shim of deprecated methods, removable when callers count = 0)
- All 14 deprecated-method callers migrated to modern API
- legacyAdapter deleted
- DEFAULT_TTL promoted to src/auth/constants.ts; 3 sites updated to import
</after_state>
```

5. Plans 4 batches of work:
   - Batch 1: 4 callers in `src/auth/` (close to the source)
   - Batch 2: 5 callers in `src/api/`
   - Batch 3: 5 callers in `src/jobs/`
   - Batch 4: cleanup (delete deprecated + legacyAdapter, promote DEFAULT_TTL)

### Batch 1

The Janitor migrates 4 callers in `src/auth/`. Runs `pnpm validate-deps`:

```
✓ no architectural violations
Done in 2.1s
```

Marks the checkpoint:

```markdown
## Validation gates

### After batch 1 (4 files modified)
- `pnpm validate-deps`:
  ```
  ✓ no architectural violations
  Done in 2.1s
  ```
```

### Batch 2 — course correction

The Janitor migrates 5 callers in `src/api/`. Runs `pnpm validate-deps`:

```
✗ 2 architectural violations
  src/api/login.ts:14 imports from src/auth/tokenStore.ts (forbidden — must go through src/auth/index.ts)
  src/api/callback.ts:12 imports from src/auth/tokenStore.ts (same)
Done in 2.3s
```

Two new violations. The Janitor does *not* push through. They investigate:

- The deprecated methods were exposed via `src/auth/index.ts` (the public surface).
- The modern methods are only exposed via internal imports.
- The migration mechanically replaced `oldGet` → `get`, but the import paths needed updating too.

The Janitor's response:

```markdown
## Decisions

- **Course correction at batch 2 checkpoint.** Validation surfaced 2 new architectural violations.
  The deprecated methods were exposed via `src/auth/index.ts` (public surface); the modern methods
  are only via internal imports. The mechanical migration `oldGet → get` didn't update the import
  paths.

- **Action:** For each migrated caller, also update the import to come from `src/auth/index.ts`.
  Re-run validation after each fix.

- **Audit promotion:** Adding a finding to `.agents/audits/auth-tokenstore-2026.md`:
  *"The audit recommended migration of callers to the modern API but didn't note that the modern
  API isn't exposed via the public surface. Either expose them via index.ts (recommended) or
  document the policy that auth internals are accessed via the modern internal path."*
```

The Janitor:

1. Updates the 2 violating callers' imports.
2. Re-runs validation:
   ```
   ✓ no architectural violations
   Done in 2.0s
   ```
3. Continues batch 2 with the corrected pattern.
4. Promotes the audit finding (`src/auth/index.ts` exports the modern API; updates the audit accordingly).

This is the discipline working as designed: checkpoint validation caught the issue at batch 2 (5 files, manageable); without the checkpoint, it would have surfaced at the end with 14 files all needing rework.

### Batches 3 and 4

The Janitor continues with the corrected pattern. After each batch, validation passes. After batch 4 (cleanup):

```
$ pnpm validate-deps
✓ no architectural violations
Done in 2.1s

$ pnpm typecheck
✓ no type errors
Done in 4.2s

$ pnpm test
Tests:       412 passed, 412 total
Time:        9.1 s
```

### Self-review

```markdown
## Self-review

> **Hard gate.** ...

### Verification outputs

- `git status` →
  [16 files modified, 0 orphans]

- Per-checkpoint `pnpm validate-deps` outputs:
  - After batch 1: ✓ no violations
  - After batch 2 (initial run): ✗ 2 violations
  - After batch 2 (post-correction): ✓ no violations
  - After batch 3: ✓ no violations
  - After batch 4: ✓ no violations

- Final `pnpm validate-deps`: ✓ no violations
- Final `pnpm typecheck`: ✓ no type errors
- Final `pnpm test`: 412 passed, 412 total

### Behavior preservation

Test suite passes with the same count (412) as before the refactor. No tests modified beyond the
mechanical adaptations (test imports updated to reflect the new module structure). Behaviour
preserved end-to-end.

### Architectural cleanliness

Zero new architectural violations. The course correction at batch 2 prevented accumulation. The
audit's framing issue (public-vs-internal API) is promoted upstream.

### Shim hygiene

One temporary shim added: `tokenStore.oldGet/oldSet/oldDelete` forwarding to modern methods.
Removable when `git grep -c 'oldGet\\|oldSet\\|oldDelete' src/` returns 0. After batch 4 (cleanup),
the count is 0; the shim was deleted at the end of batch 4.

### Deletion safety

Three deletions:
- `tokenStore.legacyAdapter`: `git grep -n 'legacyAdapter' src/` returns 0 callers (verified before deletion).
- `tokenStore.oldGet/oldSet/oldDelete`: `git grep -n 'tokenStore\\.\\(old\\(Get\\|Set\\|Delete\\)\\)' src/` returns 0 (verified before deletion).
- DEFAULT_TTL duplicates: replaced by imports from `src/auth/constants.ts`.

### Scope

Addressed Issues 1, 2, 3 (per audit). Issue 4 explicitly out of scope; promotion to follow-up
already in audit. No "while I'm here" creep.
```

---

## 🟥 The handoff: Skeptic review

A `review` task is spawned. The Skeptic:

- Runs `pnpm validate-deps`, `pnpm typecheck`, `pnpm test` themselves: all pass.
- Reads `git diff --stat` of the branch: 16 files modified, ~250 lines.
- Walks the diff with the six adversarial questions.
- Confirms behaviour preservation (test count unchanged, no production-code logic changes).
- Confirms shim hygiene (the temporary shim was added and removed within the same task).
- Confirms deletion safety (each deletion has grep-evidence in Self-review).
- Confirms the audit promotion (the audit now mentions the public-vs-internal finding).

**Verdict: APPROVE.**

The Lead Engineer (or human) merges `refactor/auth-tokenstore` into `main`.

---

## 📜 What changed in the durable docs

- `.agents/audits/auth-tokenstore-2026.md` — Issues 1, 2, 3 marked resolved. Issue 4 still active. New finding promoted from the Janitor's mid-task discovery. Audit now reflects the public-vs-internal API distinction.
- `src/auth/index.ts` — modern API now public.
- `src/auth/tokenStore.ts` — deprecated methods removed; legacyAdapter removed.
- `src/auth/constants.ts` — new file with DEFAULT_TTL.
- `src/auth/sessionStore.ts`, `src/auth/refreshStore.ts` — DEFAULT_TTL imports.
- The Janitor's task file — *deleted* with the worktree.

---

## 🪞 Why this walkthrough matters

The framework's discipline shines at the *checkpoint*. Without the every-10-files validation rule, the Janitor would have:

- Migrated all 14 callers
- Run validation at the end
- Discovered 14 violations
- Had to undo / re-do significant work

With the discipline, the Janitor caught the issue at batch 2 (5 files), course-corrected, and continued with the corrected pattern. The cost of catching late vs catching early differs by an order of magnitude.

This is what *empirical proof + per-checkpoint validation* buys: catching the failure at the smallest possible blast radius.

---

## See also

- [`tasks/refactor.md`](../tasks/refactor.md)
- [`personas/the-janitor.md`](../personas/the-janitor.md)
- [`skills/write-refactor.md`](../skills/write-refactor.md)
- [`skills/empirical-proof.md`](../skills/empirical-proof.md)
- [`feature-walkthrough.md`](feature-walkthrough.md) — sister walkthrough
