# 🪞 Walkthrough: research → spec → feature

> A complete chain showing the distillation discipline in action: a Researcher's evidentiary investigation becomes an Architect's prescriptive spec, which becomes a Builder's implementation. Each transition is accountable.

---

## 🎬 The scenario

A team needs to add a message broker to their event-driven architecture. The current "broker" is in-process pub/sub; with a new microservice landing in Q3, they need real cross-process delivery.

A human launches `research-writing` with the question: *"Which message-broker library should we adopt? Optimise for operational simplicity at our scale (10K msg/sec sustained, p99 < 50 ms)."*

---

## 📚 Phase 1: research-writing (The Researcher)

The Researcher's full task is documented in [The Researcher's worked example](../personas/the-researcher.md#%EF%B8%8F-example-how-the-researcher-resolves-a-representative-issue). Briefly:

- Sources consulted: NATS docs, Redpanda docs, RabbitMQ docs, Kafka protocol guide, an open-source benchmark study.
- Findings: throughput, operational complexity, ecosystem fit, cost — each with source citations.
- Comparison table.
- Recommendation: **Adopt NATS JetStream.**
- Two `[MINOR]` open questions; one `[unconfirmed]` claim about Synadia's customer references.

The research file lands at `.agents/research/message-broker-2026.md`. The Researcher's task closes; the file is durable.

---

## 📜 Phase 2: spec-writing (The Architect)

Now the framework's flow graph fires: `research.md → spec-writing → The Architect`. A new task is spawned.

### Pre-flight

The Architect:

1. Reads the task file.
2. Adopts the Architect persona.
3. Reads `.agents/research/message-broker-2026.md` in full.
4. Reads the constitution, the auth-related ADRs, the AGENTS.md.

### Pattern survey

The Architect surveys existing patterns:

```bash
$ git grep -n 'EventEmitter\\|pub.sub\\|broker' src/
src/events/in-process.ts:8: export class InProcessBroker extends EventEmitter { ... }
src/events/index.ts:5: export { InProcessBroker as Broker } from './in-process';
src/jobs/queue.ts:12: import { Broker } from '@/events';
src/notifications/dispatcher.ts:8: import { Broker } from '@/events';
... (12 sites total)
```

The Architect notes: 12 callers depend on `Broker`. The new spec must define a transition strategy.

### Drafting the spec

The Architect drafts `.agents/specs/message-broker-nats.md`:

```markdown
# Specification: Adopt NATS JetStream as the event broker

## Status
Active

## Author
The Architect

## Context
We need cross-process event delivery for the Q3 microservice work. Per
`.agents/research/message-broker-2026.md`, NATS JetStream is the recommended choice.

## Linked docs
- Upstream research: .agents/research/message-broker-2026.md
- ADR (drafted alongside): .agents/adrs/0024-event-broker-nats.md
- Constitution: .agents/constitution.md (no broker section yet; this spec triggers an addition)

## Goal
The codebase routes events through NATS JetStream rather than the in-process EventEmitter,
maintaining the existing `Broker` public surface so consumer code is unchanged.

## Acceptance criteria
- [ ] AC1: A `NatsBroker` class implements the `Broker` interface defined in `src/events/types.ts`.
- [ ] AC2: `src/events/index.ts` exports `Broker` aliased to `NatsBroker` (replacing `InProcessBroker`).
- [ ] AC3: All 12 existing callers continue to compile and pass their tests with no source changes
      to consumer code.
- [ ] AC4: A `NatsBroker.connect(url, options)` factory establishes a connection with retry / backoff.
- [ ] AC5: `NatsBroker.publish(topic, payload)` delivers within p99 ≤ 50 ms at 10K msg/sec sustained
      (verifiable via the benchmark in `.agents/benchmarks/event-broker-baseline.md`, to be authored).
- [ ] AC6: `NatsBroker.subscribe(topic, handler)` supports the at-least-once semantics; idempotency
      is the consumer's responsibility (per ADR 0024).
- [ ] AC7: A NATS JetStream cluster definition exists at `infrastructure/nats/cluster.yaml`
      (3-node; jet-stream enabled).

## Design decisions

### Decision: Preserve the `Broker` interface
**Chosen:** Keep `src/events/types.ts:Broker` as-is; `NatsBroker` implements it.

**Considered and rejected:**
- _Introduce a new `EventBus` interface_ — rejected because it would require migrating all 12
  consumers, doubling the scope of this work.

### Decision: at-least-once delivery (idempotent consumer required)
**Chosen:** Use JetStream's at-least-once delivery; consumers must handle duplicate delivery.

**Considered and rejected:**
- _Exactly-once_ — NATS supports it but at significant performance cost (per research file §4).
  Our consumer code can be made idempotent more cheaply.

### Decision: 3-node cluster
**Chosen:** 3-node NATS cluster (1 leader + 2 followers; quorum 2).

**Considered and rejected:**
- _Single-node_ — rejected because it doesn't survive a single instance failure; goal is HA.
- _5-node_ — rejected because our current scale doesn't warrant it; can scale up later.

## Constraints

- Cluster credentials via env vars (constitution §4.1)
- Connection timeout: 5 s (default); retry with exponential backoff up to 30 s
- All new files in `src/events/nats/` (per layering)
- Use NATS' official client library (`nats@^3.0.0`)

## Pattern survey

- src/events/in-process.ts:8 — existing `Broker` interface to preserve
- src/events/index.ts:5 — public surface, will alias change
- src/lib/connection-retry.ts:14 — reuse for NATS connection backoff
- src/observability/logger.ts:8 — reuse for connection-state logging

## Open questions

- [ ] **[MINOR]** Should we add a deprecation period for the in-process broker (some tests use it
      directly)? Default: keep `InProcessBroker` available for tests; the production surface
      switches.
- [ ] **[MINOR]** Should we capture per-topic metrics? Defer to a follow-up observability task.

## Tradeoffs and risks

**Risk: NATS cluster operational burden.** A new piece of infrastructure to monitor.
_Mitigation:_ ADR 0024 lists the operational dashboards we'll add; the runbook is part of the
infrastructure work.

**Risk: At-least-once delivery surprises consumers.**
_Mitigation:_ Document in `docs/events/idempotency.md`; provide a `withIdempotencyKey` utility.

## Distillation Loss Statement

**Dropped from upstream:**

- Detailed comparison tables of Redpanda and RabbitMQ (the choice is finalised; the spec only
  needs the chosen approach)
- Pricing analysis (we're self-hosting; pricing is moot)
- The `[unconfirmed]` Synadia customer references (not load-bearing for the implementation)

**Why downstream doesn't need this:**

- The Builder needs the contract (interface, semantics, scale targets), not the comparative analysis
- The original research file is preserved at `.agents/research/message-broker-2026.md` for archeology
```

### Self-review

```markdown
## Self-review

### Verification outputs
- `git status` → only `.agents/specs/message-broker-nats.md` and `.agents/adrs/0024-event-broker-nats.md` modified

### Read-only constraint
No source / config / dependency changes. ✅

### Implementability
A Builder reading this spec can implement: the `NatsBroker` class signature is implied by AC1
(implements `Broker`); the cluster setup is referenced in AC7 with the path to the YAML; the
benchmark target is in AC5 with a path to the (to-be-authored) baseline.

One follow-up: AC5 references `.agents/benchmarks/event-broker-baseline.md` which doesn't exist
yet. The Builder will need that to verify AC5. Spawning a `performance` task (with The Performance
Surgeon) in parallel to author the baseline.

### Verifiability
Every AC is testable. AC1: type-check + class-extends. AC2: import-and-use test. AC3: existing
test suite. AC4-AC6: integration tests. AC7: file existence + cluster validation in deploy pipeline.

### Pattern survey
Listed in the spec. Reused: connection-retry, logger. New: `src/events/nats/`.

### `[CRITICAL]` open questions
None. The two `[MINOR]` open questions don't block.

### Distillation Loss Statement
Complete. Three items dropped, three justifications given.
```

The spec lands. The ADR (0024) is drafted in the same task per the convention that structural decisions get their own ADR. Both are durable.

---

## ⚒️ Phase 3: feature (The Builder)

The framework's flow graph fires again: `spec.md → feature → The Builder`. A new task is spawned.

### Concurrent benchmark task

Because the spec references a not-yet-existing benchmark, an `audit-writing` (or `performance`) task is also launched to author `.agents/benchmarks/event-broker-baseline.md` with The Performance Surgeon. That work happens in parallel; the Builder's feature task waits on its completion before AC5 can be verified, but other ACs can proceed.

### The Builder's session

The Builder:

1. Reads the spec in full.
2. Reads the research file (linked).
3. Reads ADR 0024 (linked).
4. Reads the surveyed-pattern files (`src/events/in-process.ts`, etc.).
5. Plans:
   - Batch 1: define the `NatsBroker` class skeleton; implement `connect` + `publish`.
   - Batch 2: implement `subscribe`; integration test against a local NATS instance.
   - Batch 3: switch `src/events/index.ts` alias; verify all 12 consumers still compile and pass.
   - Batch 4: cluster config at `infrastructure/nats/cluster.yaml`.
6. Implements. Each batch ends with `pnpm validate` and `pnpm test` outputs pasted.
7. Self-review hard gate: every AC verified except AC5 (waiting on baseline).

### Self-review (excerpted)

```markdown
### Spec adherence
- AC1 → `src/events/nats/broker.ts:14` (NatsBroker implements Broker). ✅
- AC2 → `src/events/index.ts:5` (alias updated). ✅
- AC3 → `pnpm test` shows all 412 existing tests pass; the 12 consumers compile unchanged. ✅
- AC4 → `src/events/nats/broker.ts:42` (connect with backoff, reusing `lib/connection-retry`). ✅
- AC5 → **PENDING — waiting on `.agents/benchmarks/event-broker-baseline.md`.** Not closing the
  task as `done`; status will be `awaiting-baseline`. The Performance Surgeon's task is in flight.
- AC6 → `src/events/nats/broker.ts:88` (subscribe with at-least-once). ✅
- AC7 → `infrastructure/nats/cluster.yaml` exists; cluster validates locally. ✅
```

This is interesting: AC5 can't be verified yet. Rather than fudge, the Builder marks the task `awaiting-baseline` and updates `## Next steps`:

```markdown
## Next steps

- AC5 verification depends on `.agents/benchmarks/event-broker-baseline.md`, currently being
  authored by The Performance Surgeon (parallel task `perf-event-broker-baseline`).

- Resume action: when the baseline is authored, re-run the benchmark in this worktree and verify
  AC5 (p99 ≤ 50 ms at 10K msg/sec).

- All other ACs verified. The branch is merge-blockable on AC5 only.
```

When the Performance Surgeon's task lands, the Builder resumes, runs the benchmark, verifies AC5, and closes the task.

---

## 📜 What changed in the durable docs

- `.agents/research/message-broker-2026.md` — unchanged (research is terminal).
- `.agents/specs/message-broker-nats.md` — moved to `.agents/specs/shipped/` after merge.
- `.agents/adrs/0024-event-broker-nats.md` — durable; the structural decision is now part of the project's history.
- `.agents/benchmarks/event-broker-baseline.md` — new, durable.
- `.agents/constitution.md` — possibly updated to add an "Events" section per the spec's note.
- The Researcher's, Architect's, Performance Surgeon's, Builder's task files — *deleted* with their worktrees.

---

## 🪞 Why the chain matters

Each persona did *exactly one kind of work*, with the right discipline:

- **Researcher:** evidentiary, citing primary sources; not opinionated about implementation.
- **Architect:** prescriptive, with named alternatives in `## Design decisions`; halted on `[CRITICAL]`s in the ADR before finalising the spec.
- **Builder:** implementation, halted on the missing benchmark dependency rather than fudging AC5.

Each handoff was *deterministic*: research routes to spec-writing; spec routes to feature. No ambiguity, no improvisation.

The chain preserved what mattered (the implementation contract) and dropped what didn't (the comparative pricing analysis, the unconfirmed customer reference). Each transition appended a Loss Statement so a reviewer can verify the loss.

This is the framework's value: a complex multi-persona, multi-doc, multi-task workflow that *just works* because every step is deterministic and disciplined.

---

## See also

- [`tasks/research-writing.md`](../tasks/research-writing.md), [`tasks/spec-writing.md`](../tasks/spec-writing.md), [`tasks/feature.md`](../tasks/feature.md)
- [`personas/the-researcher.md`](../personas/the-researcher.md), [`personas/the-architect.md`](../personas/the-architect.md), [`personas/the-builder.md`](../personas/the-builder.md)
- [`skills/distillation-discipline.md`](../skills/distillation-discipline.md)
- [`concepts/03-distillation.md`](../concepts/03-distillation.md)
- [`feature-walkthrough.md`](feature-walkthrough.md), [`refactor-walkthrough.md`](refactor-walkthrough.md), [`orchestration-walkthrough.md`](orchestration-walkthrough.md)
