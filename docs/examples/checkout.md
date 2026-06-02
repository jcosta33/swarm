# Walkthrough: `checkout`, end to end

> One obligation set carried through all nine Swarm passes in order — author, lint, improve, lower, decompose, implement, verify, review, promote — watching a cart-submission spec go from a draft with one bundled obligation and a parallel write-surface conflict to a merged, promoted finding. This is the checkout positive walkthrough: identifiers, content hashes, and verdicts are stable from the first stage to the last, so the whole page reads as a single run.

## What you are looking at

`checkout` is a small, complete feature: when a shopper submits a cart, the service validates it, charges the card, writes the order and inventory records, and emails a receipt — charging at most once. It is small enough to read in one sitting and rich enough to exercise the two defect classes this domain exists to bracket: an obligation that **bundles** three separable responsibilities into one sentence, and two obligations that **share a write surface** while being planned to run in parallel. The first is a prose/singularity defect caught at `lint`; the second is an orchestration defect caught at `decompose`. Both are the kind of error that is invisible to a schema check and lethal at runtime — a double-charge, a lost order row — which is exactly why they are pinned here.

Nothing on this page is run by a tool. Swarm ships **no runtime** — every artifact below is inert markdown, the oracle a human or agent reads and writes by hand while following the stdlib pass guides. The IR and the work packet are *contracts a future tool would emit against*, produced here by hand so the chain is legible. Read this page top to bottom; each stage feeds the next.

The default pass order, which this page follows exactly:

```text
author -> lint -> improve -> lower -> decompose -> implement -> verify -> review -> promote
```

---

## Stage 1 — `author`: the human writes the spec

`author` is the only stage where a human writes a `.swarm.` artifact directly. The output is a `spec.swarm.md`: frontmatter plus prose sections (`## Intent`, `## Interfaces`, `## Obligations`, `## Invariants`) interleaved with typed SOL blocks. The author is not expected to write clean obligations on the first pass — that is what `lint` and `improve`/`decompose` are for. The frontmatter carries the three separate version fields: `swarm_language` (which grammar and lint codes apply), `aps_version` (the prose standard), and `spec_version` (the SemVer of this spec's content). They are never merged.

Note the two deliberate flaws planted here. `AC-010` bundles three separable obligations into a single sentence — *validate the cart* **and** *charge the card* **and** *email the receipt* — three responsibilities that fail, verify, and parallelize independently. And `AC-011` and `AC-012` both declare `WRITES db/orders` while sitting in the same `parallel_group`: two writers contending on one surface with no ordering between them.

```sol
---
type: spec
swarm_language: SOL/0.1
aps_version: 0.1
spec_version: 0.1.0
id: checkout
status: draft
---

# Spec: Charge and confirm cart submission

## Intent
When a shopper submits a cart the service validates it, charges the card once,
records the order and inventory, and emails a receipt — never charging twice.

## Interfaces

INTERFACE IF-001:
`submitCheckout` RETURNS `OrderConfirmed | CheckoutRejected`
ERRORS:
  - card-declined
  - cart-stale
OWNED BY checkout-service
VERIFY BY contract:cmdValidate:openapi/checkout.yaml

## Obligations

REQ AC-010:
WHEN the cart is submitted
THE checkout service MUST validate the cart AND charge the card AND email the receipt
VERIFY BY test:cmdTest:web/tests/checkout-submit.spec.ts#submits-cart
DEPENDS ON IF-001
WRITES web/src/checkout/submit.ts

REQ AC-011:
WHEN the charge succeeds
THE checkout service MUST write the order record
VERIFY BY test:cmdTest:web/tests/checkout-order.spec.ts#writes-order
WRITES db/orders
PARALLEL GROUP record-writes

REQ AC-012:
WHEN the charge succeeds
THE checkout service MUST write the inventory ledger
VERIFY BY test:cmdTest:web/tests/checkout-inventory.spec.ts#writes-ledger
WRITES db/orders
PARALLEL GROUP record-writes

## Invariants

INVARIANT I-001:
the card MUST NOT be charged more than once for a single cart submission
```

---

## Stage 2 — `lint`: diagnose, don't touch

`lint` reads the spec and emits SARIF-shaped diagnostic records in the unified `SOL-<LAYER><NNN>` namespace, without changing a single character. Each record names the closed repair op so the next stage is mechanical rather than open-ended. Two diagnostics fire on the authored source, both BLOCKING because each one changes *what* gets built rather than merely how the text reads. The `severity` here is the authoring-layer value (`BLOCKING`/`ADVISORY`); when this lowers into the IR's `diagnostics[]` array it becomes the `level` value (`error`/`warning`/`note`).

```text
SOL-P004  BLOCKING  layer=P  AC-010:L2 ("MUST validate the cart AND charge the card AND email the receipt")
  message: one clause bundles three separable obligations (validate / charge / email).
  suggest: improve op ATOMIZE — split into one obligation per block.

SOL-O001  BLOCKING  layer=O  AC-011 ∥ AC-012 on surface db/orders
  message: two work packets planned parallel (group record-writes) share write surface db/orders;
           violates the safe-parallelism predicate (write surfaces planned parallel must be pairwise disjoint).
  suggest: SCOPE — split the write surfaces, or add a serializing DEPENDS ON.
```

`SOL-P004` is a P-layer (prose/singularity) defect: it fires at the `NORMALIZE`/`improve` stage and is repaired by `ATOMIZE`. `SOL-O001` is an O-layer (orchestration) defect: strictly it is *decidable* the moment the spec declares overlapping write surfaces in one parallel group, and it is the gate `lower`/`decompose` enforce before any plan emits. Lint records it early so the author sees both repairs at once; the orchestration gate at Stage 5 is where it would otherwise halt plan emission. No other layer fires — `IF-001` carries a `contract` proof, `I-001` is measurable as written, and every obligation has a `VERIFY BY` path.

---

## Stage 3 — `improve`: apply the closed ops, preserve intent

`improve` applies the named ops — here `ATOMIZE` for the bundle and `SCOPE` for the write-surface conflict — each strictly semantics-preserving. An op may make an obligation singular, well-scoped, or safely parallelizable; it may never change what the author meant. Anything that *would* change intent routes to amendment or review, never to `improve`.

`ATOMIZE` splits `AC-010` into three single-obligation REQs: `AC-010` keeps *validate the cart*, and two fresh ids carry the rest — `AC-013` *charge the card* and `AC-014` *email the receipt*. Each atom keeps the shared trigger and gets its own modality, write surface, and proof binding; the order-of-operations dependency (charge before record, validate before charge) becomes explicit `DEPENDS ON` edges rather than an implied reading order. `SCOPE` resolves `SOL-O001` by giving `AC-012` a disjoint write surface (`db/inventory` instead of `db/orders`) **and** a serializing `DEPENDS ON AC-011`, so the two record-writers are now both write-disjoint and ordered. Only the changed and added blocks are shown.

```sol
REQ AC-010:
WHEN the cart is submitted
THE checkout service MUST validate the cart
VERIFY BY test:cmdTest:web/tests/checkout-submit.spec.ts#validates-cart
DEPENDS ON IF-001
WRITES web/src/checkout/submit.ts
RISK medium

REQ AC-013:
WHEN the cart is validated
THE checkout service MUST charge the card
VERIFY BY test:cmdTest:web/tests/checkout-charge.spec.ts#charges-once
DEPENDS ON AC-010
WRITES web/src/checkout/charge.ts
RISK high

REQ AC-014:
WHEN the order record is written
THE checkout service MUST email the receipt
VERIFY BY test:cmdTest:web/tests/checkout-receipt.spec.ts#emails-receipt
DEPENDS ON AC-011
WRITES web/src/checkout/receipt.ts
RISK low

REQ AC-011:
WHEN the charge succeeds
THE checkout service MUST write the order record
VERIFY BY test:cmdTest:web/tests/checkout-order.spec.ts#writes-order
DEPENDS ON AC-013
WRITES db/orders

REQ AC-012:
WHEN the charge succeeds
THE checkout service MUST write the inventory ledger
VERIFY BY test:cmdTest:web/tests/checkout-inventory.spec.ts#writes-ledger
DEPENDS ON AC-011
WRITES db/inventory

INVARIANT I-001:
the card MUST NOT be charged more than once for a single cart submission
VERIFY BY property:cmdTest:web/tests/checkout.properties.ts#charge_at_most_once
```

Each diagnostic maps to a closed repair. `ATOMIZE` turned the one bundled `AC-010` into three single-obligation REQs (`AC-010`, `AC-013`, `AC-014`), clearing `SOL-P004` — no obligation, modality, or binding was dropped, only separated. `SCOPE` gave `AC-012` the disjoint surface `db/inventory` and added `DEPENDS ON AC-011`, so the `record-writes` set is now pairwise write-disjoint *and* serialized, clearing `SOL-O001`. The `BIND` on `I-001` attached a `property` proof (an `INVARIANT` prefers `property`, `model`, or `static` over a plain unit test). With both blocking diagnostics resolved and no open question, the spec is ready to lower.

---

## Stage 4 — `lower`: emit the typed IR

`lower` projects the normalized spec into the typed intermediate representation, `checkout.swarm.ir.json`. Three things happen mechanically: uppercase SOL surface keywords become `snake_case` IR fields (`VERIFY BY` becomes `verify_by`, `DEPENDS ON` becomes a `depends_on` edge); every relationship moves into `edges[]`, the single source of relationship truth, never duplicated as a node scalar; and node ids become namespaced. Note that the atomized `AC-010`/`AC-013`/`AC-014` are now three independent nodes with their own predicates and proof bindings — the bundle is gone from the IR entirely. A slice is shown.

```json
{
  "meta": {
    "id": "checkout",
    "title": "Charge and confirm cart submission",
    "language": "SOL/0.1",
    "version": "0.1.0",
    "status": "draft"
  },
  "nodes": [
    {
      "id": "INTERFACE.checkout.IF-001",
      "kind": "INTERFACE",
      "clauses": { "returns": "OrderConfirmed | CheckoutRejected" },
      "owner": "checkout-service",
      "verify_by": [
        { "type": "contract", "adapter": "cmdValidate",
          "ref": "openapi/checkout.yaml", "selector": null, "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "checkout.swarm.md", "line_start": 18, "line_end": 25,
                  "content_hash": "sha256:4c2d…7a" }
    },
    {
      "id": "REQ.checkout.AC-010",
      "kind": "REQ",
      "modality": "MUST",
      "clauses": { "trigger": { "kw": "WHEN", "expr": "the cart is submitted" },
                   "subject": "checkout service",
                   "predicate": "validate the cart" },
      "risk": "medium",
      "writes": ["web/src/checkout/submit.ts"],
      "verify_by": [
        { "type": "test", "adapter": "cmdTest",
          "ref": "web/tests/checkout-submit.spec.ts",
          "selector": "validates-cart", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "checkout.swarm.md", "line_start": 29, "line_end": 35,
                  "content_hash": "sha256:a91f…0b" }
    },
    {
      "id": "REQ.checkout.AC-013",
      "kind": "REQ",
      "modality": "MUST",
      "clauses": { "trigger": { "kw": "WHEN", "expr": "the cart is validated" },
                   "subject": "checkout service",
                   "predicate": "charge the card" },
      "risk": "high",
      "writes": ["web/src/checkout/charge.ts"],
      "verify_by": [
        { "type": "test", "adapter": "cmdTest",
          "ref": "web/tests/checkout-charge.spec.ts",
          "selector": "charges-once", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "checkout.swarm.md", "line_start": 37, "line_end": 43,
                  "content_hash": "sha256:b734…e9" }
    },
    {
      "id": "REQ.checkout.AC-011",
      "kind": "REQ",
      "modality": "MUST",
      "clauses": { "trigger": { "kw": "WHEN", "expr": "the charge succeeds" },
                   "subject": "checkout service",
                   "predicate": "write the order record" },
      "writes": ["db/orders"],
      "verify_by": [
        { "type": "test", "adapter": "cmdTest",
          "ref": "web/tests/checkout-order.spec.ts",
          "selector": "writes-order", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "checkout.swarm.md", "line_start": 53, "line_end": 58,
                  "content_hash": "sha256:c5a0…12" }
    },
    {
      "id": "REQ.checkout.AC-012",
      "kind": "REQ",
      "modality": "MUST",
      "clauses": { "trigger": { "kw": "WHEN", "expr": "the charge succeeds" },
                   "subject": "checkout service",
                   "predicate": "write the inventory ledger" },
      "writes": ["db/inventory"],
      "verify_by": [
        { "type": "test", "adapter": "cmdTest",
          "ref": "web/tests/checkout-inventory.spec.ts",
          "selector": "writes-ledger", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "checkout.swarm.md", "line_start": 60, "line_end": 65,
                  "content_hash": "sha256:d8e1…3f" }
    },
    {
      "id": "REQ.checkout.AC-014",
      "kind": "REQ",
      "modality": "MUST",
      "clauses": { "trigger": { "kw": "WHEN", "expr": "the order record is written" },
                   "subject": "checkout service",
                   "predicate": "email the receipt" },
      "risk": "low",
      "writes": ["web/src/checkout/receipt.ts"],
      "verify_by": [
        { "type": "test", "adapter": "cmdTest",
          "ref": "web/tests/checkout-receipt.spec.ts",
          "selector": "emails-receipt", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "checkout.swarm.md", "line_start": 45, "line_end": 51,
                  "content_hash": "sha256:e0b6…84" }
    },
    {
      "id": "INVARIANT.checkout.I-001",
      "kind": "INVARIANT",
      "modality": "MUST NOT",
      "clauses": { "subject": "the card for a single cart submission",
                   "predicate": "be charged more than once" },
      "verify_by": [
        { "type": "property", "adapter": "cmdTest",
          "ref": "web/tests/checkout.properties.ts",
          "selector": "charge_at_most_once", "gate": "required" }
      ],
      "status": "UNVERIFIED",
      "source": { "file": "checkout.swarm.md", "line_start": 67, "line_end": 70,
                  "content_hash": "sha256:f1c3…9d" }
    }
  ],
  "edges": [
    { "from": "REQ.checkout.AC-010", "to": "INTERFACE.checkout.IF-001",
      "type": "depends_on", "hard": true },
    { "from": "REQ.checkout.AC-013", "to": "REQ.checkout.AC-010",
      "type": "depends_on", "hard": true },
    { "from": "REQ.checkout.AC-011", "to": "REQ.checkout.AC-013",
      "type": "depends_on", "hard": true },
    { "from": "REQ.checkout.AC-012", "to": "REQ.checkout.AC-011",
      "type": "depends_on", "hard": true },
    { "from": "REQ.checkout.AC-014", "to": "REQ.checkout.AC-011",
      "type": "depends_on", "hard": true },
    { "from": "REQ.checkout.AC-013", "to": "INVARIANT.checkout.I-001",
      "type": "affects", "hard": false }
  ],
  "diagnostics": [],
  "provenance": { "hash": "sha256:7e44…b1", "compiler_version": null,
                  "compiled_at": "2026-06-02T00:00:00Z" }
}
```

Every node enters `lower` at `status: UNVERIFIED` — the default before any verdict exists. The `depends_on` chain `AC-010 → AC-013 → AC-011 → {AC-012, AC-014}` is the linear order-of-operations the bundle used to hide; the single `affects` edge records that the charge obligation `AC-013` touches the at-most-once `INVARIANT` `I-001`. `compiler_version` is `null` because no tool is shipped; the IR is the contract a future tool would emit against, produced here by hand.

---

## Stage 5 — `decompose` and `implement`: project a write-disjoint plan, then build it

`decompose` projects the IR into `task.md` work packets, computing the partition on which all safe parallelism rests. This is the stage that would have *halted* on the authored spec: the safe-parallelism predicate requires that any two packets scheduled in parallel have **pairwise-disjoint** write surfaces, and the original `AC-011`/`AC-012` shared `db/orders` — the `SOL-O001` the `SCOPE` op already cleared at Stage 3. With `AC-012` moved to `db/inventory` and serialized behind `AC-011`, the partition is now legal: `AC-011` (writes `db/orders`) and `AC-012` (writes `db/inventory`) are write-disjoint, and the `DEPENDS ON AC-011` edge orders them anyway. Each packet's owned paths MUST be a subset of its assigned obligations' `WRITES` — a packet writing a path outside its declared `write_surfaces` is the hard error `SOL-O005` (owned-path-outside-write-surface). Only the load-bearing frame is shown; the verification matrix is filled in by `implement`/`verify` as work lands.

```text
---
type: task
id: checkout-record-writes
status: active
task_kind: feature
source: .swarm/sources/specs/checkout.swarm.md
assigned_obligations: [AC-011, AC-012]
invariants: [I-001]
interfaces: [IF-001]
write_surfaces: [db/orders, db/inventory]
verification_bindings:
  - AC-011: test:cmdTest:web/tests/checkout-order.spec.ts#writes-order
  - AC-012: test:cmdTest:web/tests/checkout-inventory.spec.ts#writes-ledger
parallel_group: record-writes
blocked_by: [checkout-charge]
---

# Task: Implement checkout record writes

## Scope

### In
- Implement AC-011 (order record) and AC-012 (inventory ledger), preserving I-001.

### Out
- Do not implement unassigned obligations (validate, charge, email are other packets).
- Do not write any path outside db/orders and db/inventory.

## Verification matrix
| Obligation | Required proof          | Actual proof                          | Status |
| ---------- | ----------------------- | ------------------------------------- | ------ |
| AC-011     | test:#writes-order      | checkout-order.spec.ts passed         | pass   |
| AC-012     | test:#writes-ledger     | checkout-inventory.spec.ts passed     | pass   |
| I-001      | property:#charge_at_most_once | checkout.properties.ts passed   | pass   |
```

The `record-writes` packet is the one this domain is about: it carries the two obligations that used to collide, now safely write-disjoint (`db/orders` vs `db/inventory`) and serialized behind the charge packet (`blocked_by: [checkout-charge]`, the lowered form of `DEPENDS ON AC-013` on the chain). `implement` executes the packet against exactly those two surfaces; the `I-001` invariant rides along as a preserved obligation because the charge path it constrains feeds these writes.

---

## Stage 6 — `verify`: record the trace and its provenance

`verify` runs the bound proofs and records a `TRACE` block plus the provenance that the drift join depends on. The `TRACE` declares what it `IMPLEMENTS`, what it `PRESERVES`, what surfaces it `CHANGED`, and one `PROOF` line per binding with its result. The provenance table carries the canonical seven fields: `source_hash` (echoing the IR node's `content_hash`), `per_surface_hash[]` (each `{surface, hash, exercised}`), `adapter`, `verdict`, `tier` (the proof *type*, never a RISK value), `origin_obligations[]`, and `origin_traces[]`. These hashes are what later detects staleness — they are the load-bearing part of the artifact.

```text
---
type: trace
id: checkout-record-writes-trace
source_task: .swarm/generated/tasks/checkout-record-writes.md
source_spec: .swarm/sources/specs/checkout.swarm.md
---

# Trace: checkout record writes

TRACE T-001:
IMPLEMENTS AC-011, AC-012
PRESERVES I-001
CHANGED db/orders, db/inventory
PROOF test:cmdTest:web/tests/checkout-order.spec.ts#writes-order passed
PROOF test:cmdTest:web/tests/checkout-inventory.spec.ts#writes-ledger passed
PROOF property:cmdTest:web/tests/checkout.properties.ts#charge_at_most_once passed

## Provenance
| binding | source_hash      | per_surface_hash[]                          | adapter | verdict | tier     | origin_obligations | origin_traces |
| ------- | ---------------- | ------------------------------------------- | ------- | ------- | -------- | ------------------ | ------------- |
| AC-011  | sha256:c5a0…12   | {db/orders, sha256:6620…a7, exercised}      | cmdTest | PASS    | test     | [AC-011]           | [T-001]       |
| AC-012  | sha256:d8e1…3f   | {db/inventory, sha256:7731…c8, exercised}   | cmdTest | PASS    | test     | [AC-012]           | [T-001]       |
| I-001   | sha256:f1c3…9d   | {charge.ts, sha256:88a2…d9, exercised}      | cmdTest | PASS    | property | [I-001]            | [T-001]       |
```

The two write obligations each cite their own write surface — `db/orders` and `db/inventory`, now provably disjoint — and the `I-001` property exercises the charge path (`charge.ts`) where the at-most-once invariant lives. All three proofs are recorded `passed`; nothing executed here, the results are pinned data.

---

## Stage 7 — `review`: per-obligation verdicts and the merge gate

`review` (run under the `skeptic` profile) consumes the trace and emits one `VERDICT` line per obligation. Each verdict carries a core value — `PASS`, `FAIL`, `BLOCKED`, or `UNVERIFIED` — optionally decorated with a lifecycle value. The skeptical review judges the trace claims against the source spec, the diff, and the proof evidence — not against the trace's self-report. Here the interesting check is orchestration: review confirms that the `db/orders` and `db/inventory` surfaces are genuinely disjoint and that no diff hunk wrote outside the packet's declared `write_surfaces`. All three obligations come back clean `PASS`.

```text
---
type: review
id: checkout-record-writes-review
source_trace: .swarm/generated/traces/checkout-record-writes-trace.md
source_spec: .swarm/sources/specs/checkout.swarm.md
---

# Review: checkout record writes

## Per-obligation verdicts

VERDICT AC-011: PASS
REASON writes-order test asserts the order row is written exactly once after a successful charge; surface db/orders only.
EVIDENCE checkout-order.spec.ts output in review log

VERDICT AC-012: PASS
REASON writes-ledger test asserts the inventory ledger entry; surface db/inventory, disjoint from AC-011.
EVIDENCE checkout-inventory.spec.ts output in review log

VERDICT I-001: PASS
REASON Property test fails on any path producing charge_count > 1; current run is green.
EVIDENCE checkout.properties.ts output in review log

## Final verdict
Gate: every required obligation is PASS or WAIVED; none STALE/CONTRADICTED/FAIL/BLOCKED/UNVERIFIED.
Checked: AC-011 writes only db/orders, AC-012 writes only db/inventory — pairwise disjoint, no
unauthorized hunk outside the declared write_surfaces; the record-writes packet is safe-parallel.
Result: PASS — every required obligation is PASS, the write-surface partition holds, the gate opens.
```

Unlike the auth-refresh walkthrough, there is no staleness reconcile here — the surfaces this packet touched were not re-edited after the proofs ran, so every recorded source hash still matches its live surface. The gate opens on the first evaluation: every required obligation is `PASS`, none `STALE`/`CONTRADICTED`/`FAIL`/`BLOCKED`/`UNVERIFIED`, and the safe-parallelism predicate the `SCOPE` op restored at Stage 3 still holds at the gate.

---

## Stage 8 — `promote`: capture a durable finding

With the gate open and the work merged, `promote` captures a durable discovery from the task as a `finding.md` carrying full provenance: which obligations and traces it came from, the pass and profile that produced it, the reviewer or tool, a `content_hash`, a confidence level, and applies-when / does-not-apply-when bounds. The discovery here is a real one surfaced during review — the `SCOPE` fix made `AC-011` and `AC-012` write-disjoint, but they both still depend on the same successful charge (`AC-013`), so a retried or duplicated charge event upstream can fan out into a second pair of record writes, threatening `I-001` *in aggregate* even though each write obligation is individually idempotent on its own surface.

```text
---
type: finding
id: double-write-on-retried-charge
status: promoted
related_obligations: [AC-013, I-001]
confidence: high
---

# Finding: A retried charge can fan out into a second pair of record writes

## Claim
AC-011 and AC-012 are write-disjoint, but both fire on "the charge succeeds" (AC-013).
If the charge is retried and a duplicate success event is delivered, the order and
inventory writes run a second time; without a charge-idempotency key this violates
I-001 in aggregate even though each record write is idempotent on its own surface.

## Provenance
- origin_obligations: [REQ.checkout.AC-013, INVARIANT.checkout.I-001]
- origin_traces: [checkout-record-writes-trace#T-001]
- pass: verify; profile: skeptic
- reviewer_or_tool: review.md (human review)
- content_hash: sha256:b734…e9
- confidence: high

## Applies when
- The charge step can emit more than one success event for one cart submission.

## Does not apply when
- The charge carries an idempotency key that dedupes duplicate success events.
```

The finding is then indexed in memory by a single `MAP` line carrying a "Load when" condition. No procedure is inlined in the index — the link points at the finding, and the index stays a thin router into memory.

```text
# memory/INDEX.md  (excerpt)
- [Double write on retried charge](../findings/double-write-on-retried-charge.md)
  — Load when: implementing or reviewing charge-then-write checkout paths.
```

That closes the loop: a draft spec with one bundled obligation and a parallel write-surface conflict became a normalized, atomized spec, a typed IR with an explicit dependency chain, a write-disjoint and serialized work packet, an implemented and traced change, a reviewed merge that confirmed the partition holds, and a promoted finding that future work on this surface will load on demand.

---

## Related

- Pass references, in pipeline order: [`author`](../passes/author.md), [`lint`](../passes/lint.md), [`improve`](../passes/improve.md), [`lower`](../passes/lower.md), [`decompose`](../passes/decompose.md), [`implement`](../passes/implement.md), [`verify`](../passes/verify.md), [`review`](../passes/review.md), [`promote`](../passes/promote.md)
- [Golden corpus](../reference/golden-corpus.md) — `checkout` is the positive (`must-compile`) fixture this walkthrough draws from; the negative variant trips `SOL-P004` (bundled obligation) and `SOL-O001` (parallel write-surface conflict)
- Artifact references for each stage's output: [`spec`](../artifacts/spec.md), [`task`](../artifacts/task.md), [`trace`](../artifacts/trace.md), [`review`](../artifacts/review.md), [`finding`](../artifacts/finding.md), [`memory`](../artifacts/memory.md)
