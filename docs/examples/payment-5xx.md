# Walkthrough: `payment-5xx`, end to end

> One obligation set carried through all nine Swarm passes in order — author, lint, improve, lower, decompose, implement, verify, review, promote — watching a payment-processor 5xx handler go from a draft spec with a self-contradiction, a vague-quality clause, and an open blocking question to a merged, promoted finding. This is the third pipeline-complete positive walkthrough; identifiers, content hashes, and verdicts are stable from the first stage to the last, so the whole page reads as a single run.

## What you are looking at

`payment-5xx` is a small, complete feature: when the payment processor returns a 5xx, the service retries an *idempotent* charge a bounded number of times, then surfaces a structured error to the caller — and never double-charges. It is small enough to read in one sitting and rich enough to exercise the parts of the pipeline that auth-refresh does not: a `MUST`-vs-`MUST NOT` semantic contradiction on a single trigger, a high-risk vague-quality phrase ("handle failures gracefully") with no observable criterion, and a `[blocking]` question hanging over the retry obligation that would halt lowering if it survived.

Nothing here is run by a tool. Swarm ships **no runtime** — every artifact below is inert markdown, the oracle a human or agent reads and writes by hand while following the stdlib pass guides. The IR and trace provenance are *contracts a future tool would emit against*, produced here by hand so the chain is legible. Read this page top to bottom; each stage feeds the next.

The default pass order, which this page follows exactly:

```text
author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote
```

---

## Stage 1 — `author`: the human writes the spec

`author` is the only stage where a human writes a `.swarm.` artifact directly. The output is a `spec.swarm.md`: frontmatter plus prose sections (`## Intent`, `## Interfaces`, `## Obligations`, `## Invariants`, `## Questions`) interleaved with typed SOL blocks. The author is not expected to write clean obligations on the first pass — that is what `lint` and `improve` are for. The frontmatter carries the three separate version fields: `swarm_language` (which grammar and lint codes apply), `aps_version` (the prose standard), and `spec_version` (the SemVer of this spec's content). They are never merged.

Note the deliberate flaws planted here: `AC-020` says the service `MUST retry the charge` and on the same trigger `MUST NOT retry the charge` — a self-contradiction; `AC-021` says the service `MUST handle failures gracefully`, a high-risk quality word with no observable criterion; and `Q-001` is a `[blocking]` question hanging over `AC-020`, asking whether a 503 should be retried at all.

```sol
---
type: spec
swarm_language: SOL/0.1
aps_version: 0.1
spec_version: 0.1.0
id: payment-5xx
status: draft
---

# Spec: Payment-processor 5xx handling

## Intent
When the payment processor returns a 5xx, the service retries an idempotent
charge a bounded number of times and then surfaces a structured error to the
caller, without ever charging the card twice.

## Interfaces

INTERFACE IF-001:
`chargeCard` RETURNS `Charge | ProcessorError`
ERRORS:
  - processor-5xx
  - idempotency-conflict
OWNED BY payments-service
VERIFY BY contract:cmdContract:charge-card-contract

## Obligations

REQ AC-020:
WHEN the processor returns a 5xx
THE service MUST retry the charge
AND THE service MUST NOT retry the charge
VERIFY BY test:cmdTest:payments/tests/charge-5xx.spec.ts#retries-idempotent-charge
DEPENDS ON IF-001
WRITES payments/src/charge/handler.ts
RISK high

REQ AC-021:
WHEN a payment fails
THE service MUST handle failures gracefully

## Invariants

INVARIANT I-001:
the same charge MUST be submitted to the processor at most once per idempotency key

## Questions

QUESTION Q-001 [blocking]:
Should a 503 from the processor be retried, or surfaced to the caller immediately?
AFFECTS AC-020
```

---

## Stage 2 — `lint`: diagnose, don't touch

`lint` reads the spec and emits SARIF-shaped diagnostic records in the unified `SOL-<LAYER><NNN>` namespace, without changing a single character. Each record names the closed `improve` op (or direct edit) that repairs it, so the next stage is mechanical rather than open-ended. Three diagnostics fire on the authored source, all BLOCKING because each one changes *what* gets built rather than merely how the text reads. The `severity` here is the authoring-layer value (`BLOCKING`/`ADVISORY`); when this lowers into the IR's `diagnostics[]` array it becomes the `level` value (`error`/`warning`/`note`).

```text
SOL-M002  BLOCKING  layer=M  AC-020:L2-L3
  message: AC-020 carries opposed modalities on one contradiction key —
           MUST retry the charge AND MUST NOT retry the charge, same actor + trigger.
  suggest: improve op DECONFLICT — resolve per source authority or raise to amendment.

SOL-P005  BLOCKING  layer=P  AC-021:L2 ("THE service MUST handle failures gracefully")
  message: vague-quality high-risk word ("gracefully") in a binding clause with
           no same-line observable criterion.
  suggest: improve op CONCRETIZE or QUANTIFY — name the observable behavior and threshold.

SOL-V001  BLOCKING  layer=V  AC-021:L1-L2
  message: obligation AC-021 has no VERIFY BY binding; no verification path.
  suggest: improve op BIND — add VERIFY BY <type>:<adapter>:<artifact>.
```

Beyond the three blocking diagnostics, `lint` records a note about the blocking question: `Q-001` is `[blocking]` and `AFFECTS AC-020`, so `AC-020` MUST NOT reach the `lower` pass until the question is resolved. A blocking `QUESTION` that *does* reach `lower` is itself a hard error (`SOL-O003`, blocking-question-reaches-lowering). The question is a gate, not a suggestion. `SOL-M002` fires on **exact contradiction-key match only** — the two clauses share the normalized actor, trigger, and surface set and carry opposed modalities; this is the deterministic case, not paraphrase or entailment.

---

## Stage 3 — `improve`: apply the closed ops, preserve intent

`improve` applies the named ops — here `DECONFLICT`, `CONCRETIZE`, and `BIND` — each strictly semantics-preserving. An op may resolve a contradiction, make a clause observable, or attach a proof; it may never change what the author meant. Anything that *would* change intent routes to amendment or review, never to `improve`. Separately, the spec owner resolves `Q-001` out of band (decision: a 503 is retried under the same bounded-retry policy as any other 5xx, not surfaced immediately); that resolution is recorded and `Q-001` is removed, which unblocks `AC-020`. Only the changed blocks are shown.

```sol
REQ AC-020:
WHEN the processor returns a 5xx
THE service MUST retry the charge up to 2 times under the obligation's idempotency key
VERIFY BY test:cmdTest:payments/tests/charge-5xx.spec.ts#retries-idempotent-charge
DEPENDS ON IF-001
WRITES payments/src/charge/handler.ts
RISK high

REQ AC-021:
WHEN a payment fails after the bounded retries are exhausted
THE service MUST return HTTP 503 with a structured error body and MUST NOT charge the card again
VERIFY BY test:cmdTest:payments/tests/charge-fail.spec.ts#surfaces-503-no-recharge
DEPENDS ON IF-001
WRITES payments/src/charge/handler.ts
RISK medium

INVARIANT I-001:
the same charge MUST be submitted to the processor at most once per idempotency key
VERIFY BY property:cmdTest:payments/tests/charge.properties.ts#at_most_once_per_key
```

Each diagnostic maps to exactly one repair. `DECONFLICT` resolved `AC-020`'s `MUST retry` / `MUST NOT retry` collision per source authority: the spec owner judged the intent to be a *bounded* retry, so the negative clause is superseded and the obligation becomes a single coherent `MUST retry … up to 2 times`, clearing `SOL-M002` — and because this is a resolution per source authority rather than an intent change, it stays inside `improve` and does not escalate to amendment. `CONCRETIZE` replaced "handle failures gracefully" with observable behavior (return HTTP 503 with a structured error body, and do not re-charge), clearing `SOL-P005`. `BIND` attached a `test` proof to `AC-021` and a `property` proof to `I-001` (an `INVARIANT` prefers `property`, `model`, or `static` over a plain unit test), clearing `SOL-V001`. All three diagnostics now resolve, and with `Q-001` closed, the spec is ready to lower.

---

## Stage 4 — `lower`: emit the typed IR

`lower` projects the normalized spec into the typed intermediate representation, `payment-5xx.swarm.ir.json`. Three things happen mechanically: uppercase SOL surface keywords become `snake_case` IR fields (`VERIFY BY` becomes `verify_by`, `DEPENDS ON` becomes a `depends_on` edge); every relationship moves into `edges[]`, the single source of relationship truth, never duplicated as a node scalar; and node ids become namespaced. Crucially, `lower` halts on any unresolved blocking diagnostic or open blocking `QUESTION` (`SOL-O003`); the IR below exists *only because* `improve` deconflicted `AC-020` and closed `Q-001` first. A slice is shown.

```json
{
  "meta": {
    "id": "payment-5xx",
    "title": "Payment-processor 5xx handling",
    "language": "SOL/0.1",
    "version": "0.1.0",
    "status": "draft"
  },
  "nodes": [
    {
      "id": "INTERFACE.payment-5xx.IF-001",
      "kind": "INTERFACE",
      "clauses": { "returns": "Charge | ProcessorError" },
      "owner": "payments-service",
      "verify_by": [
        { "type": "contract", "adapter": "cmdContract",
          "ref": "charge-card-contract", "selector": null, "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "payment-5xx.swarm.md", "line_start": 13, "line_end": 20,
                  "content_hash": "sha256:2c8d…b1" }
    },
    {
      "id": "REQ.payment-5xx.AC-020",
      "kind": "REQ",
      "modality": "MUST",
      "clauses": { "trigger": { "kw": "WHEN", "expr": "the processor returns a 5xx" },
                   "subject": "service",
                   "predicate": "retry the charge up to 2 times under the obligation's idempotency key" },
      "risk": "high",
      "writes": ["payments/src/charge/handler.ts"],
      "verify_by": [
        { "type": "test", "adapter": "cmdTest",
          "ref": "payments/tests/charge-5xx.spec.ts",
          "selector": "retries-idempotent-charge", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "payment-5xx.swarm.md", "line_start": 24, "line_end": 30,
                  "content_hash": "sha256:4f1a…9d" }
    },
    {
      "id": "REQ.payment-5xx.AC-021",
      "kind": "REQ",
      "modality": "MUST",
      "clauses": { "trigger": { "kw": "WHEN", "expr": "a payment fails after the bounded retries are exhausted" },
                   "subject": "service",
                   "predicate": "return HTTP 503 with a structured error body and not charge the card again" },
      "risk": "medium",
      "writes": ["payments/src/charge/handler.ts"],
      "verify_by": [
        { "type": "test", "adapter": "cmdTest",
          "ref": "payments/tests/charge-fail.spec.ts",
          "selector": "surfaces-503-no-recharge", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "payment-5xx.swarm.md", "line_start": 32, "line_end": 36,
                  "content_hash": "sha256:6b22…3e" }
    },
    {
      "id": "INVARIANT.payment-5xx.I-001",
      "kind": "INVARIANT",
      "modality": "MUST",
      "clauses": { "subject": "the same charge",
                   "predicate": "be submitted to the processor at most once per idempotency key" },
      "verify_by": [
        { "type": "property", "adapter": "cmdTest",
          "ref": "payments/tests/charge.properties.ts",
          "selector": "at_most_once_per_key", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "payment-5xx.swarm.md", "line_start": 40, "line_end": 43,
                  "content_hash": "sha256:8e07…c5" }
    }
  ],
  "edges": [
    { "from": "REQ.payment-5xx.AC-020", "to": "INTERFACE.payment-5xx.IF-001",
      "type": "depends_on", "hard": true },
    { "from": "REQ.payment-5xx.AC-021", "to": "INTERFACE.payment-5xx.IF-001",
      "type": "depends_on", "hard": true },
    { "from": "REQ.payment-5xx.AC-020", "to": "INVARIANT.payment-5xx.I-001",
      "type": "affects", "hard": false },
    { "from": "REQ.payment-5xx.AC-021", "to": "INVARIANT.payment-5xx.I-001",
      "type": "affects", "hard": false }
  ],
  "diagnostics": [],
  "provenance": { "hash": "sha256:d90f…7a", "compiler_version": null,
                  "compiled_at": "2026-05-31T00:00:00Z" }
}
```

Every node enters `lower` at `status: UNVERIFIED` — the default before any verdict exists. `I-001` lowers with `modality: MUST` (it is an at-most-once positive bound, not a `MUST NOT` prohibition). `compiler_version` is `null` because no tool is shipped; the IR is the contract a future tool would emit against, produced here by hand.

---

## Stage 5 — `decompose` and `implement`: project a work packet, then build it

`decompose` projects the IR into a `task.md` work packet, and `implement` executes it. The packet's write surfaces MUST be a subset of the assigned obligations' `WRITES` — the two-tier lowering rule. A packet that writes a path outside its declared `write_surfaces` is the hard error `SOL-O005` (owned-path-outside-write-surface). Both obligations write the same surface (`payments/src/charge/handler.ts`), so they cannot run in parallel against it; the decomposer assigns them to one serialized packet rather than splitting them across parallel tasks, satisfying the safe-parallelism predicate (no two parallel packets share a write surface — the defect `SOL-O001` guards). The packet inherits the proof bindings from the obligations it covers and pins its source spec under the adopted-project `.swarm/` tree. Only the load-bearing frame is shown; the verification matrix is filled in by `implement`/`verify` as work lands.

```text
---
type: task
id: payment-5xx-handler
status: active
task_kind: feature
source: .swarm/sources/specs/payment-5xx.swarm.md
assigned_obligations: [AC-020, AC-021]
invariants: [I-001]
interfaces: [IF-001]
write_surfaces: [payments/src/charge/handler.ts]
verification_bindings:
  - AC-020: test:cmdTest:payments/tests/charge-5xx.spec.ts#retries-idempotent-charge
  - AC-021: test:cmdTest:payments/tests/charge-fail.spec.ts#surfaces-503-no-recharge
  - I-001:  property:cmdTest:payments/tests/charge.properties.ts#at_most_once_per_key
parallel_group: charge-handler-edits
blocked_by: []
---

# Task: Implement payment-5xx charge handling

## Scope

### In
- Implement AC-020, AC-021, and preserve I-001 within payments/src/charge/handler.ts.

### Out
- Do not implement unassigned obligations.
- Do not change behavior outside payments/src/charge/handler.ts.

## Verification matrix
| Obligation | Required proof                | Actual proof                        | Status |
| ---------- | ----------------------------- | ----------------------------------- | ------ |
| AC-020     | test:#retries-idempotent-charge | charge-5xx.spec.ts passed          | pass   |
| AC-021     | test:#surfaces-503-no-recharge  | charge-fail.spec.ts passed         | pass   |
| I-001      | property:#at_most_once_per_key  | charge.properties.ts passed        | pass   |
```

---

## Stage 6 — `verify`: record the trace and its provenance

`verify` runs the bound proofs and records a `TRACE` block plus the provenance that the drift join depends on. The `TRACE` declares what it `IMPLEMENTS`, what it `PRESERVES`, what surfaces it `CHANGED`, and one `PROOF` line per binding with its result. The provenance table carries the canonical seven fields: `source_hash` (echoing the IR node's `content_hash`), `per_surface_hash[]` (each `{surface, hash, exercised}`), `adapter`, `verdict`, `tier` (the proof *type*, never a RISK value), `origin_obligations[]`, and `origin_traces[]`. These hashes are what later detects staleness — they are the load-bearing part of the artifact.

```text
---
type: trace
id: payment-5xx-handler-trace
source_task: .swarm/generated/tasks/payment-5xx-handler.md
source_spec: .swarm/sources/specs/payment-5xx.swarm.md
---

# Trace: payment-5xx handler

TRACE T-001:
IMPLEMENTS AC-020, AC-021
PRESERVES I-001
CHANGED payments/src/charge/handler.ts
PROOF test:cmdTest:payments/tests/charge-5xx.spec.ts#retries-idempotent-charge passed
PROOF test:cmdTest:payments/tests/charge-fail.spec.ts#surfaces-503-no-recharge passed
PROOF property:cmdTest:payments/tests/charge.properties.ts#at_most_once_per_key passed

## Provenance
| binding | source_hash      | per_surface_hash[]                        | adapter | verdict | tier     | origin_obligations | origin_traces |
| ------- | ---------------- | ----------------------------------------- | ------- | ------- | -------- | ------------------ | ------------- |
| AC-020  | sha256:4f1a…9d   | {handler.ts, sha256:7731…a8, exercised}   | cmdTest | PASS    | test     | [AC-020]           | [T-001]       |
| AC-021  | sha256:6b22…3e   | {handler.ts, sha256:7731…a8, exercised}   | cmdTest | PASS    | test     | [AC-021]           | [T-001]       |
| I-001   | sha256:8e07…c5   | {properties.ts, sha256:bc42…0f, exercised}| cmdTest | PASS    | property | [I-001]            | [T-001]       |
```

---

## Stage 7 — `review`: per-obligation verdicts and the merge gate

`review` (run under the `skeptic` profile) consumes the trace and emits one `VERDICT` line per obligation. Each verdict carries a core value — `PASS`, `FAIL`, `BLOCKED`, or `UNVERIFIED` — optionally decorated with a lifecycle value. The reviewer judges the trace claims against the source spec, the diff, and the proof evidence — not against the trace's self-report. `AC-020` and `AC-021` come back as clean `PASS`. `I-001` is the interesting one: the property test PASSed, but `payments/src/charge/handler.ts` was edited *after* that PASS was recorded (a follow-up that adjusted the retry backoff), so the recorded source no longer matches the current write-surface hash. The verdict is decorated `STALE`, with the prior verdict and the changed surface named in the decorator. A STALE required obligation is not a failure — but it is not mergeable either, until it is reconciled.

```text
---
type: review
id: payment-5xx-handler-review
source_trace: .swarm/generated/traces/payment-5xx-handler-trace.md
source_spec: .swarm/sources/specs/payment-5xx.swarm.md
---

# Review: payment-5xx handler

## Per-obligation verdicts

VERDICT AC-020: PASS
REASON Charge-5xx test drives a processor 5xx and asserts the charge is retried under one idempotency key, bounded at 2.
EVIDENCE charge-5xx.spec.ts output in review log

VERDICT AC-021: PASS
REASON Charge-fail test exhausts the retries, asserts a 503 with a structured body, and asserts no second charge is submitted.
EVIDENCE charge-fail.spec.ts output in review log

VERDICT I-001: PASS (STALE by review: prior-verdict T-001; changed-surface payments/src/charge/handler.ts)
REASON Prior PASS evidence no longer matches current write-surface hash after the backoff edit; requires 3-way reconcile.
EVIDENCE prior verdict + changed-surface diff in review log

## Final verdict
Gate: every required obligation is PASS or WAIVED; none STALE/CONTRADICTED/FAIL/BLOCKED/UNVERIFIED.
Result: BLOCKED — I-001 is STALE. Re-run the bound proof against the current surface
(reconcile option 1), then re-evaluate. After re-run I-001 → PASS, the gate opens.
```

### The reconcile

The merge gate refuses to open while any required obligation is `STALE`. STALE is never silently re-blessed; it is reconciled one of three ways — re-run the proof against the current surface, amend the spec, or fix the code. Here the change to `handler.ts` was a legitimate backoff tweak that the existing property still covers, so reconcile option 1 applies: re-run the bound proof against the current surface. The re-run passes, `I-001`'s verdict becomes a clean `PASS`, the STALE decorator drops, and the gate opens — every required obligation is now `PASS`, none `STALE`/`CONTRADICTED`/`FAIL`/`BLOCKED`/`UNVERIFIED`.

---

## Stage 8 — `promote`: capture a durable finding

With the gate open and the work merged, `promote` captures a durable discovery from the task as a `finding.md` carrying full provenance: which obligations and traces it came from, the pass and profile that produced it, the reviewer or tool, a `content_hash`, a confidence level, and applies-when / does-not-apply-when bounds. The discovery here is a real one surfaced during review — the processor can time out *after* committing the charge but *before* returning, so a naive retry on that 5xx would double-charge unless every retry reuses the same idempotency key; `I-001` holds only because the retry path is keyed, not merely bounded.

```text
---
type: finding
id: idempotency-key-required-on-5xx-retry
status: promoted
related_obligations: [AC-020, I-001]
confidence: high
---

# Finding: A 5xx after a committed charge double-charges unless the retry is idempotency-keyed

## Claim
The processor can commit a charge and then return a 5xx (timeout after commit). A bounded retry
that does not reuse the original idempotency key submits a second charge and violates I-001,
even though the retry count is within bounds. Bounded-retry alone is insufficient; the key is load-bearing.

## Provenance
- origin_obligations: [REQ.payment-5xx.AC-020, INVARIANT.payment-5xx.I-001]
- origin_traces: [payment-5xx-handler-trace#T-001]
- pass: verify; profile: skeptic
- reviewer_or_tool: review.md (human review)
- content_hash: sha256:4f1a…9d
- confidence: high

## Applies when
- The processor may commit a charge before the connection fails with a 5xx.

## Does not apply when
- Every retry is submitted under the original request's idempotency key and the processor honors it.
```

The finding is then indexed in memory by a single `MAP` line carrying a "Load when" condition. No procedure is inlined in the index — the link points at the finding, and the index stays a thin router into memory.

```text
# memory/INDEX.md  (excerpt)
- [Idempotency key required on 5xx retry](../findings/idempotency-key-required-on-5xx-retry.md)
  — Load when: implementing or reviewing retry paths against a payment or charge processor.
```

That closes the loop: a draft spec with a self-contradiction, a vague-quality clause, and an open blocking question became a deconflicted and concretized spec, a typed IR, a scoped work packet, an implemented and traced change, a reviewed and reconciled merge, and a promoted finding that future work on this surface will load on demand.

---

## Related

- Pass references, in pipeline order: [`author`](../passes/author.md), [`lint`](../passes/lint.md), [`improve`](../passes/improve.md), [`lower`](../passes/lower.md), [`decompose`](../passes/decompose.md), [`implement`](../passes/implement.md), [`verify`](../passes/verify.md), [`review`](../passes/review.md), [`promote`](../passes/promote.md)
- [Golden corpus](../reference/golden-corpus.md) — `payment-5xx` is the positive (`must-compile`) fixture this walkthrough draws from; its canonical defect class is the `MUST`-vs-`MUST NOT` contradiction (`SOL-M002`), the vague high-risk word (`SOL-P005`), and the blocking-question-at-lowering risk (`SOL-O003`)
- [Walkthrough: `auth-refresh`](./auth-refresh.md) — the first pipeline-complete positive walkthrough, in the same end-to-end style
- Artifact references for each stage's output: [`spec`](../artifacts/spec.md), [`task`](../artifacts/task.md), [`trace`](../artifacts/trace.md), [`review`](../artifacts/review.md), [`finding`](../artifacts/finding.md), [`memory`](../artifacts/memory.md)
- [Proof types and the `VERIFY BY` binding](../reference/proof-types.md) — the nine proof types the bindings above draw from (`contract` for the `INTERFACE`, `test` for the obligations, `property` for the invariant)