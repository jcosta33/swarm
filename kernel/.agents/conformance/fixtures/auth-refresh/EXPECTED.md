# auth-refresh — expected outcome (golden-corpus POSITIVE fixture)

This manifest pins the expected outcome of the `auth-refresh` positive (must-compile)
fixture, the inert oracle a conformant tool is checked against (§33). It is the authority
for this directory: the per-stage files reproduce the full `intent → promotion` pipeline
(§9), and this manifest records the verdict a correct run must produce at each gate.

**Expected verdict: PASS after reconcile.**

## What this fixture is

- **Domain:** auth-refresh (silent token refresh on 401).
- **Polarity:** positive — the obligation set must compile and reach a mergeable PASS.
- **Canonical defect cluster exercised (on the *authored* source, stage 1):**
  a vague-quality predicate (`SOL-P005`), a `SHOULD` with no `BECAUSE`/`EXCEPT` (`SOL-S006`),
  a missing-verification binding (`SOL-V001`), the no-unbounded-retry `INVARIANT` (`I-001`),
  and a blocking `QUESTION` (`Q-001`).

## Stage files

| Stage | Pass | File | Asserts |
| ----- | ---- | ---- | ------- |
| 1 | author | `spec.swarm.md` | authored source; parses; carries the seeded defects |
| 2 | lint | (this manifest) | the three BLOCKING diagnostics + the blocking-QUESTION note |
| 3 | improve | `spec.improved.swarm.md` | the three diagnostics clear; `Q-001` resolved and removed |
| 4 | lower | `auth-refresh.swarm.ir.json` | typed IR; `AC-001` split into `AC-001.1`/`AC-001.2`; `edges[]` the sole relationship source |
| 5 | decompose, implement | `task.md` | work packet frame; write surfaces ⊆ assigned `WRITES` |
| 6 | verify | `trace.md` | `TRACE T-001` + the 7-field provenance table |
| 7 | review | `review.md` | per-obligation `VERDICT`s; merge-gate outcome |
| 8 | promote | `finding.md` | the durable finding promoted with full provenance |

> The `task.md` here shows the **pipeline-relevant work-packet frame** (scope + the verification matrix the trace consumes), not a full task-file. The task-file-schema `required_sections` rule (§32.3) is exercised by the dedicated schema fixtures [`../conformant-task.md`](../conformant-task.md) (positive) and [`../violations.md`](../violations.md) (negatives).

## Expected lint diagnostics (stage 2, on the authored `spec.swarm.md`)

Three BLOCKING diagnostics fire, each in the unified `SOL-<LAYER><NNN>` namespace (§8). Each
is BLOCKING because it changes *what* gets built. Each names the closed `improve` op (§10) or
direct edit that repairs it.

| Code | Layer | Severity | Span | Defect | Repair |
| ---- | ----- | -------- | ---- | ------ | ------ |
| `SOL-V001` | V | BLOCKING | `AC-002` | obligation has no `VERIFY BY` binding (no verification path) | improve op `BIND` |
| `SOL-S006` | S | BLOCKING | `AC-002` | `SHOULD` with no accompanying `BECAUSE`/`EXCEPT` | Edit: add `BECAUSE`, or raise to `MUST` |
| `SOL-P005` | P | BLOCKING | `I-001` | vague-quality predicate with no same-line observable criterion | improve op `CONCRETIZE`/`QUANTIFY` |

Plus a blocking-QUESTION risk recorded as a note: `Q-001` is `[blocking]` and `AFFECTS AC-002`.
`AC-002` MUST NOT reach the `lower` pass while `Q-001` is open; a blocking `QUESTION` that does
reach `lower` is **`SOL-O003`** (blocking-question-reaches-lowering, §18). In this fixture
`Q-001` is resolved at the `improve` stage, so `SOL-O003` does **not** fire downstream — it is
the risk the open question would have raised had it survived to lowering.

## Expected after `improve` (stage 3)

All three BLOCKING diagnostics clear and no blocking `QUESTION` remains:

- `NORMALIZE` resolved `AC-002`'s `SHOULD` to `MUST` (owner judged the session-clear
  mandatory, so no `BECAUSE` is needed) — clears `SOL-S006`.
- `CONCRETIZE` fixed `I-001`'s threshold to the literal `1` and named the measured quantity —
  clears `SOL-P005`.
- `BIND` attached a `test` proof to `AC-002` and a `property` proof to `I-001` (an `INVARIANT`
  prefers `property`/`model`/`static`, §15) — clears `SOL-V001`.
- `Q-001` resolved out-of-band (decision: redirect to `/login`) and removed — clears the
  `SOL-O003` risk before lowering.

## Expected merge-gate outcome (stage 7) → final

`AC-001` and `I-001` are clean `PASS`. `AC-002` is `PASS (STALE …)`: its bound test PASSed, but
`web/src/http/client.ts` was edited after the recorded PASS, so its source no longer matches
(§16). A STALE required obligation is not mergeable.

```text
Gate (first evaluation): BLOCKED — AC-002 is STALE.
Reconcile (option 1, §16):  re-run the bound proof against the current surface.
Gate (re-evaluation):       AC-002 → PASS; every required obligation PASS.
Final outcome:              PASS.
```

**Final gate: BLOCKED → (reconcile) → PASS.** A STALE verdict is never silently re-blessed
(§16); the reconcile re-ran the proof and produced a fresh matching PASS.

## Stable identifiers and hashes (consistent across all stages)

- Obligations: `IF-001`, `AC-001` (IR-split `AC-001.1`/`AC-001.2`), `AC-002`, `I-001`; question `Q-001`; trace `T-001`.
- Content hashes carried unchanged stage to stage: `AC-001` source `sha256:9b2e…41`,
  `I-001` source `sha256:7d10…aa`, `IF-001` source `sha256:1f4a…c0`; the promoted finding
  pins `content_hash: sha256:9b2e…41` (the `AC-001` source span).
- Adopted-project paths use `.swarm/` throughout (e.g. `.swarm/sources/specs/auth-refresh.swarm.md`).

## How this is validated (no runtime)

This is **inert data** (Invariant 1, NO RUNTIME — §2). Swarm ships no parser, linter, lowerer,
or checker; nothing in this directory executes. The verdicts above are **known independent of
any tool** and are **validated by hand** until a checker (a deferred launcher concern, §32)
exists. When a tool does exist it MAY validate against these files; this manifest is the
expected-outcome contract it would be checked against, not a tool Swarm provides.
