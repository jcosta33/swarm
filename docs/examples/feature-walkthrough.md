# 🪞 Walkthrough: spec → feature → review → merge

> A complete feature workflow, from a Builder reading a spec to a Skeptic approving the branch. Demonstrates the conditioning pipeline, the persona's hard constraints, the empirical-proof discipline, and the handoff to review.

---

## 🎬 The scenario

A team has a new requirement: their `/api/login` endpoint should support OAuth2 PKCE per RFC 7636. An Architect has already written the spec and an ADR resolving the structural decision (server-driven PKCE).

The Lead Engineer (or human) launches a `feature` task. The Builder takes it.

---

## 📜 The grounding doc

`.agents/specs/oauth2-pkce.md`:

```markdown
# Specification: OAuth2 PKCE flow for /api/login

## Status
Active

## Author
The Architect

## Context
Adding PKCE (RFC 7636) support to /api/login per `.agents/research/oauth2-pkce.md`. ADR 0017
resolved the server-driven decision.

## Linked docs
- Upstream research: .agents/research/oauth2-pkce.md
- ADR: .agents/adrs/0017-pkce-server-driven.md
- Constitution: .agents/constitution.md (auth section)

## Goal
The /api/login endpoint supports OAuth2 PKCE per RFC 7636 with the S256 challenge method,
enabling browser-based clients to authenticate without storing a client_secret.

## Acceptance criteria
- [ ] AC1: GET /api/login redirects to the IdP with a valid S256 code_challenge derived from a
      cryptographically-secure verifier (≥ 32 bytes entropy).
- [ ] AC2: Verifier storage TTL is 5 minutes; expired entries are not retrievable.
- [ ] AC3: /api/callback with valid state+code returns 302 to return_to with a session cookie set.
- [ ] AC4: /api/callback with mismatched state returns 400 code=invalid_state.
- [ ] AC5: /api/callback with expired state returns 400 code=invalid_state.
- [ ] AC6: /api/login rate-limited at 30 req/min/real-IP; 31st request returns 429.

## Constraints
- Cryptographic randomness: `crypto.randomBytes(32).toString('base64url')` (constitution §2.1)
- Real-IP for rate limiting: `req.realIp ?? req.ip` (constitution §3.4)
- No client_secret in browser code (CI gate)

## Pattern survey
- src/auth/tokenStore.ts:18 — extending per ADR 0017
- src/api/middleware/rate-limit.ts:42 — reused
- src/auth/session.ts:12 — reused for post-callback session

## Open questions
(none — all CRITICAL resolved in ADR 0017)
```

---

## 📋 The conditioned task file

The launcher (CLI or human) scaffolds `.agents/tasks/feat-oauth2-pkce.md`. Excerpt:

```markdown
# Feature: OAuth2 PKCE flow

## Metadata
- Slug: feat-oauth2-pkce
- Branch: feature/oauth2-pkce
- Base: main
- Worktree: .worktrees/feat-oauth2-pkce
- Status: active
- Type: feature

> ⚠️ **FEATURE SESSION** — Build exactly what the spec specifies. Halt on ambiguity. No opportunistic refactoring.
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Builder** persona.

## Objective
Implement OAuth2 PKCE flow per `.agents/specs/oauth2-pkce.md`. Server-driven; S256 only.

## Linked docs
- Spec: .agents/specs/oauth2-pkce.md
- Research: .agents/research/oauth2-pkce.md
- ADR: .agents/adrs/0017-pkce-server-driven.md

## Required skills
- manage-task
- documentation-gatekeeper
- personas → The Builder
- write-feature
- empirical-proof

[... constraints, plan, etc.]
```

---

## 🛠️ The session

### Pre-flight (manage-task fires)

The Builder:

1. Reads the task file.
2. Loads the persona profile (`.agents/skills/personas/the-builder.md`).
3. Adopts the Builder mindset.
4. Reads `.agents/specs/oauth2-pkce.md` in full.
5. Reads `.agents/research/oauth2-pkce.md` and `.agents/adrs/0017-pkce-server-driven.md`.
6. Reads `.agents/constitution.md` (auth section).

### Plan

The Builder fills in `## Plan`:

```markdown
## Plan

1. Survey existing tokenStore (ADR 0017 says extend with state-verifier methods).
2. Add `tokenStore.storeStateVerifier(state, verifier, ttlMs)` and `retrieveStateVerifier(state)`.
3. Add `src/auth/pkce.ts` with `generatePKCE()` (returns { codeVerifier, codeChallenge }) using `crypto.randomBytes(32)` and S256.
4. Update `/api/login` route to: (a) generate PKCE, (b) store state↔verifier (TTL 5 min), (c) redirect to IdP with code_challenge.
5. Update `/api/callback` route to: (a) retrieve verifier by state, (b) exchange code+verifier with IdP, (c) error on mismatch / expired (400 code=invalid_state).
6. Apply rate limiting middleware to `/api/login` (30 req/min/real-IP per spec AC6).
7. Tests: AC1-AC6 each become a test case in `tests/auth/pkce.test.ts` and `tests/api/login.test.ts`.
8. Run validation gates after each batch.
```

### Implementation

Batch 1: tokenStore extension. After 3 files modified:

```bash
$ pnpm validate-deps
✓ no architectural violations
Done in 2.1s
```

Batch 2: `src/auth/pkce.ts`. After 1 file modified:

```bash
$ pnpm validate
✓ all checks passed
Done in 6.4s
```

Batch 3: `/api/login` and `/api/callback` routes. After 2 files modified:

```bash
$ pnpm validate
✓ all checks passed
Done in 6.8s
```

Batch 4: rate limiting middleware integration. After 1 file modified:

```bash
$ pnpm validate
✓ all checks passed
Done in 6.9s
```

Batch 5: tests. After 6 test files modified:

```bash
$ pnpm test
Tests:       6 passed in tests/auth/pkce.test.ts (new)
Tests:       8 passed in tests/api/login.test.ts (new)
Tests:       412 passed total
Time:        9.1 s
```

### Self-review

The Builder fills in the hard gate:

```markdown
## Self-review

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
  ```
  On branch feature/oauth2-pkce
  Changes to be committed:
    modified:   src/auth/tokenStore.ts
    new file:   src/auth/pkce.ts
    modified:   src/api/login.ts
    modified:   src/api/callback.ts
    modified:   src/api/middleware/rate-limit.ts (1 line — adding to /api/login)
    new file:   tests/auth/pkce.test.ts
    new file:   tests/api/login.test.ts
    modified:   tests/api/callback.test.ts
  ```

- `pnpm validate` (last 2 lines):
  ```
  ✓ 312 files passed
  Done in 7.2s
  ```

- `pnpm test` (last 2 lines):
  ```
  Tests:       412 passed, 412 total
  Time:        9.1 s
  ```

- `pnpm validate-deps` (last 2 lines):
  ```
  ✓ no architectural violations
  Done in 2.4s
  ```

### Spec adherence

Every acceptance criterion maps to an implementation:
- AC1 → `src/auth/pkce.ts:12` `generatePKCE()` uses `crypto.randomBytes(32)`. Test: `tests/auth/pkce.test.ts:8` (verifier entropy).
- AC2 → `src/auth/tokenStore.ts:88` TTL is 5*60*1000 ms. Test: `tests/auth/pkce.test.ts:24` (expired retrieval returns null).
- AC3 → `src/api/callback.ts:42` happy path. Test: `tests/api/login.test.ts:18`.
- AC4 → `src/api/callback.ts:55` mismatch handling. Test: `tests/api/login.test.ts:32`.
- AC5 → `src/api/callback.ts:55` expiry handling (same code path; `retrieveStateVerifier` returns null). Test: `tests/api/login.test.ts:42`.
- AC6 → `src/api/login.ts:8` (rate-limit middleware applied). Test: `tests/api/login.test.ts:62`.

Nothing missing.

### Architecture

`pnpm validate-deps` clean. No new architectural violations. Followed the spec's pattern survey: extended `tokenStore` per ADR 0017; reused existing rate-limit middleware; reused session-cookie logic.

### Conventions

Followed project idioms: error handling via the `withErrorBoundary` pattern (constitution §3.4); imports from public surface; tests use the project's `createTestRequest` fixture.

### Tests

Added: 6 new tests in `tests/auth/pkce.test.ts`, 8 new tests in `tests/api/login.test.ts`. Each maps to a spec AC. Confirmed each fails when the assertion is flipped (sample: flipping `expect(refund.amount).toBe(1000)` causes the test to fail with a specific message).

### Completeness

No stubs, no TODOs, no half-implementations.

### Final Polish

The rate-limit middleware uses `req.realIp ?? req.ip` per constitution §3.4 (verified). The verifier storage uses 32 bytes per spec AC1 (verified). The S256 challenge derivation uses `crypto.subtle.digest('SHA-256', ...)` (verified). I did not add `plain` challenge support per the spec's exclusion.
```

### Promotion

`## Findings` is empty (no incidental discoveries). The pre-close gate in `manage-task` checks: no unpromoted findings, no `[pending]` assumptions, no unresolved blockers, Self-review fully answered. ✅

The Builder marks `status: ready-for-review` and updates `## Next steps`:

```markdown
## Next steps

- Hand off to The Skeptic for review.
- Branch: `feature/oauth2-pkce`. Ready for review task.
```

---

## 🟥 The handoff: Skeptic review

A `review` task is spawned with the Builder's branch as the source. The Skeptic adopts the persona, runs validation in their own worktree, walks the diff with the six adversarial questions, and renders a verdict.

The Skeptic finds:

- ✅ All 6 ACs verified against implementation lines (per the Builder's Self-review)
- ✅ `pnpm validate` and `pnpm test` pass when *the Skeptic* runs them
- ✅ No cross-module callers of changed code surface (the changes are additive)
- ✅ Six adversarial questions all answered
- ✅ One MINOR finding: the `## Open questions` in the spec mentioned audit-log emission as deferred; the Skeptic confirms no audit logs were added (consistent with deferral)

**Verdict: APPROVE.**

The Lead Engineer (or human) merges `feature/oauth2-pkce` into `main`.

---

## 📜 What changed in the durable docs

After the merge:

- `.agents/specs/oauth2-pkce.md` — `Status` updated to `Shipped`, moved to `.agents/specs/shipped/oauth2-pkce.md`.
- `.agents/research/oauth2-pkce.md` — unchanged (research is terminal).
- `.agents/adrs/0017-pkce-server-driven.md` — unchanged (ADRs are immutable).
- `.agents/audits/` — no changes (no incidental findings to promote).
- The Builder's task file (`.agents/tasks/feat-oauth2-pkce.md`) — *deleted* with the worktree.

The framework's promise: every load-bearing artefact is preserved (the spec, the ADR, the research). The execution scaffolding (the task file) is ephemeral and disposable.

---

## 🪞 Why this works

The Builder didn't have to think about:

- Which persona to adopt (the task file said)
- Which skills to load (the task file listed)
- What success looks like (the spec's acceptance criteria + Self-review hard gate)
- What discipline to follow (the persona's hard constraints + the empirical-proof skill)
- Where the doc went (the source doc's path was in the task file)

The Builder thought about: the implementation. Everything else was pre-conditioned.

This is the framework's value. The cognitive load is on the *one decision that matters* (how to implement), not on the metawork (how to organise the work).

---

## See also

- [`tasks/feature.md`](../tasks/feature.md) — the feature task template
- [`personas/the-builder.md`](../personas/the-builder.md)
- [`personas/the-skeptic.md`](../personas/the-skeptic.md) — the reviewer
- [`skills/write-feature.md`](../skills/write-feature.md)
- [`skills/empirical-proof.md`](../skills/empirical-proof.md)
- [`refactor-walkthrough.md`](refactor-walkthrough.md) — sister walkthrough
