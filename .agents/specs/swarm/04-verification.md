# Swarm Kernel Specification v0.1 — Part 04: Verification

<!-- Part 04 of the Swarm Kernel Specification (§14–§17). All parts share one section numbering (§0–§35 + Appendices A–G); cross-references of the form “§N” resolve via the index in [README.md](./README.md). -->

## 14. The verification model — verdicts and the merge gate

This section defines how Swarm judges whether an obligation has been satisfied. The verdict model is the **confidence backbone** of the framework: it is the only place where the question "did this actually get done?" is answered, and it is the gate every change MUST pass before promotion. Everything that follows is a *contract a future tool builds against* — Swarm ships no runtime (§2, Principle 1), so today every verdict is recorded by a human or agent in a markdown `review.md` and re-checked by hand or by CI scaffolding that does not yet exist.

A **verdict** is the recorded judgment of one *required* verification binding on one obligation. An **obligation** here means a `REQ`, `CONSTRAINT`, `INVARIANT`, or `INTERFACE` block (the blocks that carry binding force or declare a verifiable boundary — see §6). A `QUESTION` is never judged; a `TRACE` is the *input* to judgment; a `VERDICT` *is* the recorded judgment and reuses the judged obligation's id (per §4).

### 14.1 The seven-value model (4 core + 3 lifecycle)

Swarm's verdict vocabulary is **exactly seven values**, partitioned into two disjoint roles. This upgrades the prior model: the earlier 4-value enum is *upgraded*, never replaced. A verdict carries exactly one **CORE** value and zero or more **LIFECYCLE** decorators.

#### 14.1.1 The four CORE run results (mutually exclusive)

Exactly one core value MUST be assigned to every required binding. The four are mutually exclusive: a single bound proof, on a single run, lands in exactly one.

| CORE value | Meaning | Precise condition |
| --- | --- | --- |
| `PASS` | A bound proof ran and succeeded. | A proof was bound via `VERIFY BY` (§15), it executed, and its observed result satisfies the obligation. |
| `FAIL` | A bound proof ran and failed. | A bound proof executed and its observed result contradicts the obligation. |
| `BLOCKED` | A bound proof could not run. | A proof was bound but could not execute: a prerequisite, tool, adapter, environment, or fixture was missing. The truth is *unknown*, not false. |
| `UNVERIFIED` | No acceptable proof, or none executed. | No acceptable proof was bound to the obligation, or a binding exists but no run was attempted. |

> Rationale: `BLOCKED` and `UNVERIFIED` are kept distinct because they route differently — `BLOCKED` is an environment fix, `UNVERIFIED` is a binding or execution gap. Collapsing them hides which one is owed.

`BLOCKED` and `UNVERIFIED` MUST NOT be conflated. A reviewer who cannot tell whether a proof *ran and was prevented* (`BLOCKED`) versus *was never attempted or never bound* (`UNVERIFIED`) MUST record `UNVERIFIED`, because the absence of an attempt is the weaker, more honest claim.

#### 14.1.2 The three LIFECYCLE decorators

A lifecycle decorator annotates a core value with a status that arises *after* (or *around*) the run. Lifecycle decorators are not run results; they are governance facts.

| LIFECYCLE value | Decorates | Meaning | Mandatory fields |
| --- | --- | --- | --- |
| `WAIVED` | `FAIL` or `UNVERIFIED` | A failing or unverified obligation is explicitly accepted as an exception. | authority, reason, expiry |
| `STALE` | a prior `PASS` | A previously-passing proof's evidence no longer matches the current source/surface hashes (drift — see §16). | prior-verdict ref, changed-surface |
| `CONTRADICTED` | any core | Two proofs disagree, or a `TRACE`/code disagrees with the obligation. | two conflicting evidence refs |

`WAIVED` MUST decorate only `FAIL` or `UNVERIFIED` — there is no reason to waive a `PASS`. `STALE` MUST decorate only a prior `PASS` — a `FAIL`, `BLOCKED`, or `UNVERIFIED` was never trusted, so it cannot go stale. `CONTRADICTED` MAY decorate any core value, because contradiction is a relationship between *two* evidence sources regardless of either's individual result.

### 14.2 The VERDICT line grammar

A `VERDICT` block (§6) records one judgment. Its first line is the **verdict line**; subsequent `REASON` and `EVIDENCE` clauses supply the justification.

```ebnf
verdict_block   = verdict_line, nl,
                  "REASON", ws, prose, nl,
                  "EVIDENCE", ws, evidence_ref, { nl, "EVIDENCE", ws, evidence_ref };
verdict_line    = "VERDICT", ws, obligation_id, ":", ws, core_value,
                  [ ws, lifecycle_decorator ];
core_value      = "PASS" | "FAIL" | "BLOCKED" | "UNVERIFIED";
lifecycle_decorator
                = "(", lifecycle, ws, "by", ws, authority, ":", ws, reason,
                  [ ";", ws, lifecycle_fields ], ")";
lifecycle       = "WAIVED" | "STALE" | "CONTRADICTED";
authority       = ident | quoted_string;
reason          = prose;
lifecycle_fields= field, { ";", ws, field };
```

The verdict line is `VERDICT <id>: <CORE>` optionally followed by a single parenthetical `(<lifecycle> by <authority>: <reason>)`. The `<id>` reuses the judged obligation's surface id (`AC-001`, `C-001`, `I-001`, `IF-001`).

Worked examples:

```sol
VERDICT AC-001: PASS
REASON The client clears the session store and issues a redirect to `/login`
       when the refresh token expiry is simulated.
EVIDENCE test:cmdTest:auth-refresh-expired-token#it_clears_session — exit 0, 1 passed
```

```sol
VERDICT AC-014: FAIL (WAIVED by spec-owner@example: known flaky upstream sandbox; expiry 2026-06-30)
REASON The payment sandbox returns 502 intermittently; the obligation is unmet
       but accepted for this release window.
EVIDENCE test:cmdTest:payment-timeout#retryable_attempt — exit 1, 1 failed
```

```sol
VERDICT I-001: PASS (STALE by drift-check: prior-verdict T-009; changed-surface src/auth/session-store.ts)
REASON The token-family invariant last passed at trace T-009; src/auth/session-store.ts
       was modified after that PASS, so the evidence no longer matches the current code.
EVIDENCE property:cmdTest:token-family-invariant#single_active_family — last PASS 2026-05-20
```

```sol
VERDICT AC-022: PASS (CONTRADICTED by review: contract proof and e2e test disagree)
REASON The contract proof reports the boundary honoured; the e2e test observes a 500.
EVIDENCE contract:cmdContract:refresh-session.pact#refreshSession — pass
EVIDENCE test:cmdTest:refresh-e2e#happy_path — exit 1, 1 failed
```

### 14.3 Lint enforcement of verdict well-formedness

The lint layer responsible for verdict well-formedness is `SOL-V` (VERIFICATION). The following diagnostics MUST be raised by a conformant linter (today: by hand or by the documented `lint-spec` pass guide — §26):

| Code | Severity | Condition |
| --- | --- | --- |
| `SOL-V005` | BLOCKING | `VERDICT` core value is not one of `PASS`/`FAIL`/`BLOCKED`/`UNVERIFIED` (the former `SOL-S010`), OR a lifecycle decorator is missing its mandatory fields. |
| `SOL-V007` | BLOCKING | `WAIVED` decorates a `PASS` or `BLOCKED` (waiver is only meaningful on `FAIL`/`UNVERIFIED`), OR `STALE` decorates anything other than a prior `PASS`. |
| `SOL-V008` | BLOCKING | A required obligation has no `VERDICT` at the merge gate (see §14.4). |

The mandatory-field rule (`SOL-V005`) is enforced per lifecycle value:

- `WAIVED` MUST carry **authority** (a named human or the spec owner — §17.3), a **reason**, and an **expiry**. A `WAIVED` without all three is `SOL-V005`.
- `STALE` MUST carry a **prior-verdict ref** (the trace or verdict that last recorded the `PASS`) and the **changed-surface** that triggered staleness (§16).
- `CONTRADICTED` MUST carry **two conflicting evidence refs** (one `EVIDENCE` line per disagreeing proof).

> Rationale: the mandatory fields are what make a lifecycle decorator auditable. A `WAIVED` without an expiry is a zombie waiver (§17.3); a `STALE` without a changed-surface cannot be reconciled (§16.3); a `CONTRADICTED` without both refs cannot be tie-broken (§17.4).

### 14.4 The merge gate

The **merge gate** is the single normative predicate that decides whether a change set may be promoted. It is evaluated over the set of **required** obligations — every `REQ`, `CONSTRAINT`, `INVARIANT`, and `INTERFACE` in scope for the change, each with its required `VERIFY BY` bindings (§15.7, "one VERDICT per required VERIFY BY binding").

> **Merge gate (normative).** A change set MAY be promoted **if and only if** every required obligation's latest verdict is `PASS` or `WAIVED`, **and no** required obligation's latest verdict is `STALE`, `CONTRADICTED`, `FAIL`, `BLOCKED`, or `UNVERIFIED`.

Equivalently, expressed as the disposition of each core value under the gate:

| Latest verdict | Merge gate disposition |
| --- | --- |
| `PASS` (no lifecycle) | Passes the gate. |
| `WAIVED` (on `FAIL`/`UNVERIFIED`, fields valid, not expired) | Passes the gate. |
| `FAIL` | Blocks. Fix code or amend obligation. |
| `BLOCKED` | Blocks. Fix the environment/adapter, then re-run. |
| `UNVERIFIED` | Blocks. Bind a proof and run it, or `WAIVE`. |
| `PASS (STALE)` | Blocks. Forces 3-way reconcile (§16.3). |
| any `(CONTRADICTED)` | Blocks. Routes to review with stronger oracle authoritative (§17.4). |

A conformant repo MUST NOT promote a change while any required obligation is in a blocking disposition. Because Swarm has no runtime, this gate is **enforced by a deterministic check outside the model** when one exists (CI, a PreToolUse hook, a merge-blocking status — see §17), and is **manual today**. The spec MUST NOT claim the gate is automatically enforced (§17.1).

A `WAIVED` verdict is treated as gate-passing **only while its waiver is live**. A waiver auto-expires on the next source-hash change (§17.3); an expired waiver reverts to its underlying `FAIL`/`UNVERIFIED` and the gate blocks again.

### 14.5 `review.md` is the verdict container (there is no `verdict.md`)

A `VERDICT` is a **SOL language block**, not a file (§4). The kernel ships **no** `verdict.md` template. The container for verdicts is the **`review.md`** artifact (§21), which when filled *is* the verdict record. A conformant `review.md` MUST contain, at minimum:

```text
- Claimed coverage (which TRACE claims which obligations, with evidence refs)
- Per-obligation VERDICT blocks (one per required binding)
- An obligation-verdict matrix (id × core × lifecycle)
- Constraint / invariant / interface verdicts
- An unauthorized-change list (diff entries not authorized by any obligation)
- A final merge-gate verdict (PASS / FAIL / BLOCKED at the change-set level)
- The promotion queue
```

A repo that records verdicts in a standalone `verdict.md` is **non-conformant** (§20). The reference page `docs/.../verdict` (if present) documents the `VERDICT` block and the taxonomy; it is *documentation*, not a copyable template.

---

## 15. The proof taxonomy and VERIFY BY binding

A verdict (§14) is only as trustworthy as the proof behind it. This section fixes the **closed set of nine proof types**, the **binding syntax** that attaches a proof to an obligation, the **two-layer resolution** through `AGENTS.md`, the **type-selection rules** per block type, the **proof-strength order**, and the **per-task-type default suites**. The governing invariant is **CODE IS REALITY** (§2): a proof can falsify an obligation but may never silently amend its intent, and **schema-valid output is not a proof** (shape is not truth).

### 15.1 The nine proof types (closed)

`VERIFY BY` binds an obligation to exactly one of nine proof types. The set is **closed**: a conformant linter MUST reject any `<type>` outside this set as `SOL-V009` (unknown-proof-type). This resolves the earlier 11-type and 7-type proposals into one canonical set.

| Proof type | One-line definition |
| --- | --- |
| `static` | A non-executing analysis of source: type-check, lint, dependency-boundary check, schema validation of source. |
| `test` | An executable test that drives the system and asserts an observable outcome. |
| `contract` | A verification that a declared boundary (an `INTERFACE`) honours its `RETURNS`/`ACCEPTS`/`ERRORS` shape — a consumer/provider contract test, pact, or schema-conformance check at a boundary. |
| `property` | A generative/property-based check that asserts a universally-quantified property over many generated inputs. |
| `model` | Model-checking OR an economical proof of a property — **not** a full theorem per obligation (see 15.5). |
| `perf` | A measured performance/throughput/latency assertion against a threshold. |
| `security` | A security-specific oracle: SAST/DAST, secret scan, authz/authn test, dependency-vuln gate. |
| `manual` | A recorded human judgment against the obligation — the **honest escape hatch** when no executable oracle exists. |
| `monitor` | A runtime/production observation (logs, metrics, alerts, canary). Runtime evidence maps here. |

Two normative notes:

- **`unit`/`integration`/`e2e` are scope qualifiers under `test`, not separate types.** They are written `test:unit:`, `test:integration:`, `test:e2e:` in the binding (15.2). A conformant linter MUST treat `unit`, `integration`, `e2e` appearing as a top-level `<type>` as `SOL-V009` (unknown-proof-type; use the qualifier form instead).
- **`runtime` maps to `monitor`.** There is no `runtime` proof type; any "verified in production / observed at runtime" claim binds as `monitor`.

### 15.2 The VERIFY BY binding syntax

The surface clause is `VERIFY BY` (two words, uppercase — §5) followed by a typed reference. This composes the §5 keyword with the reference grammar.

```ebnf
verify_line  = "VERIFY BY", ws, verify_ref, nl;
verify_ref   = proof_type, ":", adapter, ":", artifact, [ "#", selector ];
proof_type   = "static" | "test" | "contract" | "property" | "model"
             | "perf" | "security" | "manual" | "monitor";
adapter      = ident;            (* resolves through AGENTS.md > Commands, see 15.3 *)
artifact     = path | ident | quoted_string;
selector     = ident | path-fragment;   (* a case/scenario/property name *)
```

- `<type>` is the **closed**, lint-typed, IR-typed dimension. For `test`, a scope qualifier MAY be inserted as `test:unit`, `test:integration`, `test:e2e` (the qualifier is part of the type segment, before the first `:` separating type from adapter — written `test:unit:cmdTest:...`).
- `<adapter>` is a **project free-string** that resolves to a command slot in `AGENTS.md > Commands` (15.3).
- `<artifact>` is a **project free-string**: a file, test id, suite name, or contract file.
- `<selector>` (optional, after `#`) narrows the artifact to a single case, scenario, or property.

Worked examples:

```sol
REQ AC-001:
WHEN the refresh token is expired
THE client MUST clear the local session
VERIFY BY test:unit:cmdTest:auth-refresh-expired-token#clears_session
```

```sol
CONSTRAINT C-001:
THE auth client MUST NOT import from `server/*`
VERIFY BY static:cmdLint:dependency-boundary#no-server-imports
```

```sol
INTERFACE IF-001:
`refreshSession` RETURNS `Session | AuthExpired`
ERRORS:
  - network-timeout
  - invalid-refresh-token
OWNED BY auth-client
VERIFY BY contract:cmdContract:refresh-session.pact#refreshSession
```

The IR field name for this clause is `verify_by[]` (snake_case — §12), normalized to `{type, adapter, ref, selector, gate}`. The surface form is always `VERIFY BY`; `VERIFY_BY` is surface-illegal (§5).

**Bare (untyped) references.** A bare `VERIFY BY <ref>` with no `type:` segment is **structurally valid** but raises an advisory untyped-binding smell (`SOL-V`-family): the typed `type:adapter:artifact` form is REQUIRED wherever a type-driven rule fires — an INTERFACE binding (which MUST be `contract`, `SOL-V006`), an INVARIANT type-preference (`SOL-V003`), an obligation entering a CONTRADICTED proof-strength tie-break (§17), or a per-task default-suite check (§15.8). A migration importing legacy specs MAY carry bare refs; `improve`/`NORMALIZE` upgrades them to typed bindings.

### 15.3 Two-layer unification: obligation binding + project adapter

`VERIFY BY` participates in a **two-layer** model, which keeps the obligation portable while letting each project name its own commands:

1. **Obligation layer (SOL, in `*.swarm.md`).** The `VERIFY BY <type>:<adapter>:<artifact>` clause declares *what kind of proof* and *which logical command + artifact* prove the obligation. The `<type>` is closed and analyzable; the `<adapter>` and `<artifact>` are free strings.
2. **Project layer (`AGENTS.md > Commands`).** The `<adapter>` resolves through the `AGENTS.md` Commands table, whose `cmd*` placeholder slots **are the adapters**. A future tool (or a human today) looks up `<adapter>` in that table to find the concrete command line for *this* repo.

The default proof-type → `cmd*` slot mapping:

| Proof type | Default `cmd*` slot(s) |
| --- | --- |
| `static` | `cmdLint`, `cmdTypecheck`, `cmdValidate` |
| `test` (any scope) | `cmdTest` |
| `contract` | integration-boundary command (e.g. `cmdContract`) |
| `property` | `cmdTest` (property runner) or a dedicated `cmdProperty` |
| `model` | `cmdModel` (model checker) or `cmdTest` for an economical proof |
| `perf` | `cmdBenchmark` |
| `security` | `cmdSecurity` / `cmdScan` (integration-boundary command) |
| `manual` | no command — resolves to a recorded human review |
| `monitor` | `cmdMonitor` / dashboard ref — no merge-time execution |

> Rationale: keeping the proof *type* in the obligation and the *command* in `AGENTS.md` means the same `spec.swarm.md` ports across repos: only the Commands table changes. A binding whose `<adapter>` has no matching `AGENTS.md > Commands` row is `SOL-V002` (proof-not-executable), which surfaces as `BLOCKED` at run time, not `PASS`.

### 15.4 Type-selection rules per block type

A conformant linter MUST apply the following block-type → proof-type rules:

| Block type | Rule | Lint on violation |
| --- | --- | --- |
| `REQ` | Any of the nine types is acceptable; `test` is the typical default. | `SOL-V001` if no `VERIFY BY` at all. |
| `CONSTRAINT` | Any type; `static` and `test` are typical. | `SOL-V001` if no `VERIFY BY` and no explicit `manual`. |
| `INVARIANT` | **Prefers `property` \| `model` \| `static`.** Binding an `INVARIANT` only to a non-observable unit `test` is a `SOL-V003` **warning** (ADVISORY by default; BLOCKING in strict mode). | `SOL-V003` (invariant bound test-only). |
| `INTERFACE` | **Requires a `contract` proof.** | `SOL-V006` (interface without a `contract` binding). |

> Rationale: an `INVARIANT` asserts a universally-quantified property ("for all states, P holds"); a single example-based unit `test` cannot establish a universal, so `property`/`model`/`static` are preferred and a test-only binding is flagged but not blocked (Theme-5 gap-fill). An `INTERFACE` is a boundary contract, so its proof MUST be a `contract` check that exercises `RETURNS`/`ACCEPTS`/`ERRORS` (resolves the Theme-1 INTERFACE-verification gap).

### 15.5 `model` does not mean a theorem per obligation

`model` means **model-checking OR an economical proof** of a property. It MUST NOT be read as a requirement to discharge a full mechanized theorem for each obligation.

> Rationale: end-to-end *per-obligation* proof is unreliable for frontier models at single trial (e.g. ~4.9% Lean proof success in VERINA `[VERINA]`), and verified-code synthesis is strongly *language-specific* — high for Dafny (~82%, and 68%→96% over one year `[VERICODING]`, `[DAFNYBENCH]`) but still low for Lean/Verus — so mandating a full theorem per obligation is neither portable nor economical. `model` therefore covers bounded model checking, an SMT-discharged property, an exhaustive small-scope check, or any economical argument an oracle can replay. When even that is infeasible, `manual` is the honest type.

### 15.6 The proof-strength order

When two proofs disagree (`CONTRADICTED`, §14.1.2, §17.4), the tie-break uses a fixed total preorder over proof types:

```text
model  >  property | contract  >  test  >  static  >  manual | monitor
```

| Rank | Types | Why this rank |
| --- | --- | --- |
| 1 (strongest) | `model` | Establishes a universal property, not an example. |
| 2 | `property`, `contract` | Generative coverage / boundary-shape conformance. |
| 3 | `test` | Example-based executable oracle. |
| 4 | `static` | Source analysis without execution. |
| 5 (weakest) | `manual`, `monitor` | Human judgment / observational signal — fallible and lagging. |

The stronger proof is treated as **authoritative pending reconciliation** at the merge gate (§17.4). This places executable oracles above an LLM-judge `manual` verdict, which is why `manual` and `monitor` sit at the bottom.

### 15.7 One VERDICT per required VERIFY BY binding

Each required `VERIFY BY` binding produces **exactly one** `VERDICT`. The hard gate (§14.4) is "one `VERDICT` per required `VERIFY BY` binding": if an obligation declares three required bindings, the merge gate expects three verdicts, and *all* must be `PASS`/`WAIVED`. A missing verdict for a required binding is `SOL-V008` (and counts as `UNVERIFIED` at the gate).

### 15.8 Per-task-type default suites

Each task kind (the `task_kind:` enum — §28) carries a **default suite**: a set of `(proof-type, phase)` requirements that recommend which proofs SHOULD be bound and at which phase they run. This reframes the legacy per-task verification matrix as default suites that bind to `cmd*` slots; the suites are **recommendations**, not a closed law — an author MAY override per obligation.

*(task_kind enum: §28)*

| `task_kind` | Default suite `(proof-type @ phase)` |
| --- | --- |
| `feature` | `test @ VERIFY`, `static @ VERIFY`; `contract @ VERIFY` if any `INTERFACE` touched |
| `fix` | `test @ VERIFY` (a regression test that reproduces the defect), `static @ VERIFY` |
| `refactor` | `test @ VERIFY` (behaviour-preservation), `property\|contract @ VERIFY` for invariants/boundaries |
| `rewrite` | `test @ VERIFY`, `static @ VERIFY`; `contract @ VERIFY` if any `INTERFACE` touched |
| `migration` | `test @ VERIFY`, `static @ VERIFY`, `contract @ VERIFY` (boundary conformance) |
| `upgrade` | `test @ VERIFY`, `static @ VERIFY`, `contract @ VERIFY` (dependency contracts) |
| `performance` | `perf @ VERIFY`, `test @ VERIFY`, `static @ VERIFY` |
| `testing` | `test @ VERIFY`, `static @ VERIFY` |
| `documentation` | `static @ VERIFY` (lint/APS); `manual @ REVIEW` for accuracy |
| `integration` | `contract @ VERIFY`, `test @ VERIFY`, `static @ VERIFY` |
| `spec-writing` | `static @ NORMALIZE` (lint/APS); no executable suite (no code yet) |
| `research-writing` | `static @ NORMALIZE` (lint/APS); no executable suite |
| `audit-writing` | `static @ NORMALIZE` (lint/APS); no executable suite |
| `bug-report-writing` | `static @ NORMALIZE` (lint/APS); no executable suite |
| `deepen-audit` | `static @ NORMALIZE` (lint/APS); `manual @ REVIEW` for evidence |
| `review` | `manual @ REVIEW` over the recorded evidence; re-run of bound `cmd*` proofs |
| `orchestration` | `static @ LOWER` (disjointness check); `manual @ REVIEW` |

A binding-completeness check (the `SOL-V` layer) verifies that an obligation's bound proofs cover its task kind's default suite, or that any omission is explicitly justified.

### 15.9 What is NOT a proof

The following MUST be rejected as invalid proofs and MUST NOT yield `PASS`:

- **Schema-valid output is not a proof.** That a tool emitted well-formed JSON, or that a structured-output call validated against its schema, says nothing about whether the *value* is correct. Shape is not truth (§2). A binding whose only evidence is "output matched the schema" is `UNVERIFIED`.
- **"Tests passed" without output is an invalid proof.** A `PASS` whose `EVIDENCE` is the bare phrase "tests passed" (no command, no exit code, no run output, no selector resolution) is `UNVERIFIED`; a conformant review MUST reject it.
- **A `manual` verdict without recorded reasoning** is `UNVERIFIED` — `manual` is an *honest* escape hatch, not a blank cheque; it MUST carry a `REASON` and an `EVIDENCE` ref to the recorded judgment.

---


### 15.10 Oracle adequacy

A `PASS` is only as trustworthy as the **oracle** that produced it — the decision procedure that says whether the observed behaviour satisfies the obligation. A bound proof can pass against a *weak* oracle and still be wrong about the obligation. This is not a corner case: on SWE-bench Verified, 7.8% of patches that pass the official developer-written test suite are in fact incorrect, and the bundled tests inflate reported resolution rates by 6.2 absolute percentage points [SWEBENCH-ADQ]. The underlying issue is the **test-oracle problem** — when a precise oracle is unavailable, a single concrete example cannot stand in for the obligation's predicate, and metamorphic/property-based pseudo-oracles are the principled response [ORACLE]. Swarm therefore treats "the proof passed" as **necessary but not sufficient**: a proof MUST also record *what it exercised* relative to the obligation, and stronger obligations demand stronger oracles.

This section is a **contract, not shipped tooling** (§2, §17.1): the adequacy record below is a field a future harness reads, and the `SOL-V011` check is manual-today.

#### 15.10.1 A proof MUST record what it exercised (the adequacy record)

A bound proof's `PASS` MUST carry an **adequacy record** describing *what the oracle exercised relative to the obligation's predicate* — not merely that the bound `cmd*` exited zero. "Tests passed" with no statement of coverage is already `UNVERIFIED` (§15.9); this strengthens that floor for obligations whose predicate is universal or high-consequence.

The adequacy record is one optional object on the trace-provenance schema (§16.1), keyed `oracle_adequacy`:

```json
{
  "oracle_adequacy": {
    "predicate_form": "universal",
    "exercised": "concrete-examples",
    "evidence_path": ["src/auth/session-store.ts"],
    "adequacy_evidence": [
      { "kind": "mutation",    "ref": "mutation-report#score", "value": "0.91" },
      { "kind": "metamorphic", "ref": "mr-idempotent-refresh"  }
    ]
  }
}
```

| Field | Meaning |
| --- | --- |
| `predicate_form` | `existential` (an example suffices) \| `universal` (for-all — an example does not). Mirrors the `INVARIANT` rationale in §15.4. |
| `exercised` | What the oracle actually ranged over: `concrete-examples` \| `generated-inputs` \| `boundary-shape` \| `state-space` \| `observation`. |
| `evidence_path[]` | The **declared write surfaces** (§16.1, `per_surface_hash[]`; §18 `WRITES`) the oracle actually executed/analysed to reach its verdict. This is the proof's footprint on the code — used by the staleness rule below. |
| `adequacy_evidence[]` | Zero or more `{kind, ref[, value]}` records, `kind` ∈ `mutation` \| `metamorphic` \| `property` \| `coverage`, that substantiate the oracle is adequate for the predicate. |

A missing `oracle_adequacy` object is permitted for `existential` predicates proven by `test`; it is a `SOL-V011` finding (oracle-adequacy-unrecorded) wherever §15.10.2 requires it.

#### 15.10.2 Stronger obligations demand stronger oracles

For an obligation carrying `RISK high` or `RISK critical` (§18; IR `risk` scalar), a single concrete `test` is an **inadequate oracle** [ORACLE], because one example cannot establish a high-consequence or universally-quantified claim. For such obligations the bound proof SHOULD be a `property` or `model` oracle (which range over generated inputs / a state space), **or** it MUST carry `adequacy_evidence` — mutation-adequacy or metamorphic-relation evidence — that substantiates the concrete oracle.

| Obligation `RISK` | Adequate bound oracle |
| --- | --- |
| `low` \| `medium` | Any type per §15.4; `test` alone is acceptable. |
| `high` \| `critical` | `property` \| `model`, OR a `test`/`contract` whose `oracle_adequacy.adequacy_evidence[]` carries `mutation` or `metamorphic` evidence. A bare concrete `test` with no adequacy evidence is `SOL-V011` (ADVISORY by default; BLOCKING in strict mode). |

> Rationale: this is the same move as the `INVARIANT` type-preference (§15.4, `SOL-V003`) generalised to consequence. An `INVARIANT` is flagged because a universal predicate outruns an example; a `RISK high|critical` obligation is flagged because the *cost of a missed defect* outruns an example. In both cases the fix is an oracle that ranges over more than one input, or explicit evidence that the example-based oracle is hard to fool.

#### 15.10.3 Adequacy is a prior that strength can be overridden by

The proof-strength order (§15.6, `model > property|contract > test > static > manual|monitor`) is a **prior**, not a verdict: it ranks proof *types* by how much an oracle of that type typically establishes. The adequacy record refines that prior with evidence about *this* oracle. Concretely, in a `CONTRADICTED` tie-break (§17.4):

- Strength sets the **default** authoritative side, as today.
- Recorded `adequacy_evidence` **MAY override** the default *within the recorded contradiction*: a `test` carrying strong mutation/metamorphic evidence and an `evidence_path` covering the disputed surface MAY be treated as authoritative over a nominally-stronger proof that exercised neither — but the reviewer MUST record the override and its reason (the two `EVIDENCE` refs of `SOL-V005` still apply). An override is a recorded judgment, never a silent re-rank, and never closes the contradiction on its own (§17.4).

> Rationale: strength-by-type is a useful default precisely because adequacy is usually unrecorded; once a proof states what it exercised, that specific evidence is a better guide than the type's average. Honouring adequacy over rank is what stops the order from becoming astrology-by-tier.

#### 15.10.4 Adequacy binds to staleness via the evidence path

Staleness (§16.2) decorates a `PASS` `STALE` when its obligation source-hash changes (intent moved) or a declared write surface changes (code moved). The `evidence_path` sharpens condition (b): **a proof participates in a surface's freshness only if that surface is on the proof's `evidence_path`.** A write surface that the obligation declares in `WRITES` but that the oracle never exercised does not, on its own, falsify *that proof's* `PASS` — the proof never depended on it.

- If a modified surface **is** on the `evidence_path`, the `PASS` goes `STALE` per §16.2(b) — the oracle's footprint moved under it.
- If a modified surface is declared (`per_surface_hash[]`) but **not** on the `evidence_path`, modification alone does not force `STALE` for that proof; this is the **proof-exercised staleness** refinement already anticipated for shared/global surfaces in §16.5. The obligation's own `source_hash` change (condition (a)) still forces `STALE` regardless.

> Rationale: drift should track *what the proof actually relied on*. Marking a `PASS` stale because an unrelated, un-exercised surface changed manufactures noise (the §16.5 problem); refusing to mark it stale when its real evidence path changed manufactures a false `PASS` (the §15.10 problem). The `evidence_path` is the one record that resolves both: freshness follows evidence, and an empty or unrecorded `evidence_path` on a `RISK high|critical` obligation is itself a `SOL-V011` finding — an oracle that cannot say what it exercised cannot be shown adequate.

## 16. Drift and staleness

A proof's `PASS` is a statement about a *moment*: the obligation said X, the code did Y, and the proof confirmed Y satisfies X. The instant either the obligation text or the code changes, that confirmation may no longer hold. **Drift** is the divergence between an obligation and its implementation after a recorded `PASS`; **staleness** is drift made machine-detectable. Because Swarm has **no runtime** (§2), drift is detected from **content hashes recorded in the trace/IR**, and the differ that compares them is a **harness/CLI concern, not shipped by this repo**.

### 16.1 What each PASS records (trace-provenance schema, G11)

Every `VERIFY BY` binding's **last `PASS`** MUST record enough provenance to detect later drift. This is **the one trace-provenance schema** that §14, §16, and §23 all reference — there is exactly one, so the verdict model, the drift check, and the memory model never diverge.

```json
{
  "source_hash": "sha256:…",
  "per_surface_hash": [
    { "surface": "src/auth/client.ts", "hash": "sha256:…" },
    { "surface": "src/auth/session-store.ts", "hash": "sha256:…" }
  ],
  "adapter": "cmdTest",
  "verdict": "PASS",
  "tier": "test",
  "origin_obligations": ["AC-001", "I-001"],
  "origin_traces": ["T-001"]
}
```

| Field | Meaning |
| --- | --- |
| `source_hash` | Content hash of the *obligation source* (the exact bytes of the obligation block in `*.swarm.md`) at the time of the `PASS`. |
| `per_surface_hash[]` | One `{surface, hash}` per **declared write surface** (the obligation's `WRITES` set — §18) at the time of the `PASS`. |
| `adapter` | The `cmd*` slot the proof resolved through (§15.3). |
| `verdict` | The core verdict recorded (`PASS` for a drift-trackable binding). |
| `tier` | The proof type (§15.1) — used for the proof-strength tie-break (§15.6). |
| `origin_obligations[]` | The obligation ids this PASS judged. |
| `origin_traces[]` | The trace(s) that produced the change being judged. |

Hashes are recorded in markdown (`*.swarm.trace.md`) and/or the emitted IR (`*.swarm.ir.json`). Computing them is a future-tool concern; the **schema is the kernel contract** today.

### 16.2 The staleness rule

A prior `PASS` becomes `STALE` (the lifecycle decorator of §14.1.2) when **either** of two conditions holds:

> **(a)** the obligation **source content-hash** changes (the obligation text was edited after the last `PASS`); **or**
> **(b)** any declared **write surface** is modified after the last `PASS` (its current hash differs from the recorded `per_surface_hash`).

Condition (a) means *intent moved*: the proof confirmed an obligation that no longer reads the same. Condition (b) means *code moved*: the proof confirmed code that has since changed. In both cases the recorded `PASS` is no longer trustworthy, and the verdict MUST be decorated `STALE` (with the prior-verdict ref and the changed-surface, per `SOL-V005`).

```sol
VERDICT AC-001: PASS (STALE by drift-check: prior-verdict T-001; changed-surface src/auth/client.ts)
REASON src/auth/client.ts changed after the last PASS at T-001; the recorded
       per-surface hash no longer matches the working tree.
EVIDENCE prior PASS recorded 2026-05-20 against source_hash sha256:ab12…
```

`STALE` **blocks the merge gate** (§14.4): a `PASS (STALE)` is treated as not-`PASS` until reconciled. A conformant tool (or a human, today) MUST recompute staleness before evaluating the gate and MUST NOT promote on a stale binding.

### 16.3 The 3-way reconcile

A `STALE` verdict forces an explicit **3-way reconcile**. Exactly one of three resolutions MUST be chosen and recorded; the system MUST NOT silently re-bless either the obligation or the code.

| # | Resolution | When | Effect |
| --- | --- | --- | --- |
| 1 | **Re-run the proof** | The change is compatible; intent and code still agree. | Bound `cmd*` re-runs; a fresh `PASS` with new hashes replaces the stale record. |
| 2 | **Amend / supersede the obligation** | Intent changed; the code is the new desired behaviour. | The obligation is amended (or superseded via ADR — §22), then re-verified. This is an *intent* change and routes to amendment/review, never to `improve` (§10). |
| 3 | **Fix the code** | Intent stands; the code drifted away from it. | The code is corrected to satisfy the unchanged obligation, then re-verified. |

> Rationale: **code is reality, not intent.** Code can *falsify* an obligation (forcing resolution 2 or 3) but may never *silently amend* it (which is why resolution 1 requires a genuine re-run, not a hash-rewrite). Re-stamping the hash without re-running the proof is forbidden — it manufactures a false `PASS`.

### 16.4 Drift coverage as a first-class metric

**Drift coverage** — the percentage of obligations whose **latest verdict is `STALE`** — is a first-class Swarm metric. A conformant repo SHOULD track and report it (manually today; via tooling when it exists). High drift coverage signals that verification has fallen behind change velocity and that the merge gate is, in aggregate, blocking.

```text
drift_coverage = ( count of required obligations whose latest verdict is STALE )
                 / ( count of required obligations )
```

### 16.5 Proof-exercised staleness (the participation rule, replaces the binary exemption)

§16.2 fires `STALE` only on a change to the obligation `source_hash` (condition (a)) or to a **declared write surface** in `per_surface_hash[]` (condition (b)). Two gaps follow from that narrow trigger, and v0.1 closes both here:

1. **The binary exemption was unsound.** A naive per-surface hash marks *every* obligation that declares a shared/global surface `STALE` on any unrelated edit; the obvious fix — binary-exempting `append-only` and `shared` surfaces from condition (b) — over-corrects. Under a binary exemption a *real behavioral* change on an exempt surface does **not** force `STALE`, while a whitespace-only edit on an ordinary one does. That inverts the honesty the staleness rule exists to protect.
2. **Drift via an undeclared read is invisible.** A proof can keep passing while no longer exercising the obligation it was bound to — the oracle has gone inadequate even though nothing in `per_surface_hash[]` moved [SWEBENCH-ADQ]. Syntactic equality of a write surface is not behavioral equality of the obligation [ORACLE]; a behavioral change reached through a dependency the obligation `READS` (or through the bound adapter) leaves condition (b) untouched.

**The participation rule (normative).** A surface participates in an obligation's freshness **if and only if it lies on the evidence path of that obligation's last `PASS`** — i.e. the surface appears in the recorded `per_surface_hash[]` of the proof that produced that `PASS` (§16.1). Participation is decided **per obligation, per recorded proof**, not by a blanket attribute toggle:

- A surface that the last `PASS` actually exercised participates **regardless of its `SURFACE` attribute** — an in-place behavioral edit to an `append-only` or `shared` surface that the proof's evidence path traversed MUST force `STALE`. The attribute (§18.3.1) governs *conflict serialization and blanket fan-out*, never an exemption from drift on an exercised surface.
- A surface that the last `PASS` did **not** exercise does **not** participate — an unrelated edit to a `shared`/global surface (a lockfile bump, an orthogonal CI-matrix entry) MUST NOT mark that obligation `STALE`. This is exactly the "staleness is scoped to proof-exercised obligations" treatment §18.3.1 records for `integration`/`shared`; §16.5 is its canonical home, and §18.3.1's `append-only` row is read accordingly (an in-place, non-append edit on an exercised append-only surface still participates).

**Extended `STALE` trigger.** The condition-(a)/(b) pair of §16.2 is extended with two further conditions; a prior `PASS` becomes `STALE` when **any** of them holds:

> **(c)** a surface in the obligation's declared **`READS`** set (§18.2) that lies on the evidence path of the last `PASS` is modified after that `PASS` (its current hash differs from the recorded `per_surface_hash` entry); **or**
> **(d)** the **bound adapter changes** — the `cmd*` slot the proof resolved through (§15.3, recorded as `adapter` in §16.1) is rebound, retargeted, or removed relative to the last `PASS`.

Condition (c) makes read-side behavioral drift detectable to the same degree write-side drift already is: the obligation's `READS` set is hashed into `per_surface_hash[]` alongside its `WRITES` set so the recorded evidence path is complete. Condition (d) catches the case where the proof itself moved underneath an unchanged obligation and unchanged code. Both are still **content-hash** comparisons computed by a future harness; no condition here requires a runtime (§2). All four conditions surface as the existing `STALE` verdict and the `SOL-V004` (`stale-proof`) lint; a `STALE` raised under (c) or (d) MUST still carry its prior-verdict ref and the changed `READS`-surface or adapter in the **changed-surface** field (`SOL-V005`, §14.3) so the 3-way reconcile (§16.3) can act on it.

**Scope limit (honesty per §17).** This rule detects **declared-write-and-read drift and adapter drift** — drift reachable through a surface or adapter that was recorded on the last `PASS`'s evidence path. It does **not** and **cannot** detect behavioral drift through an *undeclared* dependency, a hidden global, or an environmental input the obligation never declared and the proof never recorded: a missing `READS` declaration means a missing hash, and what is unhashed is unseen. Closing that gap requires observing behavior, which has no home in a markdown-only kernel (§17.1, "no runtime today"). The spec therefore claims **declared-drift detection**, never full behavioral-drift detection; an obligation whose true read set exceeds its declared `READS` is a soft-control gap to be caught by the enforcement lane (§17.2), not a guarantee §16 makes. Property/metamorphic oracles (§15) narrow this residual gap by checking behavioral relations rather than syntactic equality [ORACLE], but they reduce it; they do not let v0.1 overclaim full drift detection.

Recording behavior (informative): a tool that bumps a lockfile that no proof exercised leaves drift coverage (§16.4) unchanged; an in-place edit to a CI step that an obligation's proof did exercise raises that obligation to `STALE`. Whether to recompute evidence-path participation incrementally or on demand is a harness concern; the **participation rule, the four `STALE` conditions, and the scope limit are the kernel contract** today.

## 17. The soft/hard control boundary and the enforcement lane

This section states the single most important honesty constraint in Swarm. Everything Swarm ships is **markdown**. Markdown cannot stop an agent from doing anything. Therefore Swarm MUST be precise about what is *guidance* and what is *enforcement*, and MUST NOT dress up the former as the latter.

### 17.1 The hard boundary (normative)

> **Soft control.** Swarm prose, SOL, APS, skills/pass guides, heuristic profiles, and `AGENTS.md` are **SOFT control**: they are context and guidance for a model. They influence behaviour; they do not constrain it. They **MUST NEVER** be presented as enforcement.

> **Hard control.** Anything that must hold **regardless of the model** — a `CONSTRAINT`, an `INVARIANT`, a stop-rule, secret redaction, a write-surface gate, a proof-required merge gate — MUST be specified as a **deterministic check OUTSIDE the model**: a PreToolUse hook, a CI gate, a permission deny-rule, or a schema validator.

> **No runtime today.** Swarm is markdown-only (§2, Principle 1). The enforcement lane is therefore **aspirational/manual today**. The spec MUST NOT claim any deterministic check *exists* or *runs*. Every enforcement statement is framed as "the deterministic home a future harness MUST provide," never "Swarm enforces."

Three corollaries, each normative:

- **Structured/schema-valid output is not verification.** That a model emitted JSON matching a schema constrains *shape*, not *truth* (§15.9). Schema validation MAY be a gate input; it MUST NOT be presented as proof an obligation is met.
- **Every completion claim maps to independent verification.** No obligation is `PASS` on the model's say-so; it is `PASS` only against an independent deterministic or evidentiary oracle (§14, §15).
- **A SOFT-control artifact MUST NOT define hard semantics.** No skill, persona/profile, or `AGENTS.md` section may define modality, authority order, or verification semantics — those live in SOL and the typed IR (Q-semantics-1, §2). A regression check MUST confirm this (§34).

> Rationale (Q-enforcement-1): Anthropic's own guidance frames memory/instructions as "context, not enforced configuration" and points to a PreToolUse hook for anything that must hold. Multi-turn reliability decay and prompt-format sensitivity make a model an unsound enforcement substrate. Honesty about this boundary is what lets Swarm be trusted.

### 17.2 The enforcement-lane artifact (G4)

Swarm specifies a **first-class, currently-manual** artifact — the **enforcement lane** — that maps each hard-control obligation to its **eventual deterministic home**. It is the explicit ledger of "this is soft today; here is where it becomes hard." It MUST be maintained as a markdown table (no runtime).

Each row maps one `CONSTRAINT` / `INVARIANT` / stop-rule / secret-redaction rule to its deterministic home and current status:

```text
| Obligation / rule | Kind        | Deterministic home (eventual) | Status today |
| ----------------- | ----------- | ----------------------------- | ------------ |
| C-001 (no server/* import) | CONSTRAINT  | CI: cmdLint dependency-boundary  | manual review |
| I-001 (one token family)   | INVARIANT   | CI: property test in cmdTest     | manual review |
| stop-rule: no force-push    | stop-rule   | PreToolUse hook (git deny)       | aspirational  |
| secret redaction            | redaction   | PreToolUse hook + CI secret scan | aspirational  |
```

| Column | Meaning |
| --- | --- |
| Obligation / rule | The id or name of the hard-control item. |
| Kind | `CONSTRAINT` \| `INVARIANT` \| `stop-rule` \| `redaction`. |
| Deterministic home (eventual) | The PreToolUse hook / CI gate / permission deny / schema validator that WILL enforce it when a harness exists. |
| Status today | `manual review`, `aspirational`, or (when a harness exists) `enforced by <mechanism>`. |

The enforcement lane MUST NOT mark any row `enforced` unless a deterministic check outside the model genuinely runs it. Until then every hard-control obligation is honestly `manual review` or `aspirational`. The four deterministic-home categories are exactly: **PreToolUse hook**, **CI gate**, **permission deny-rule**, **schema validator**.

### 17.3 The WAIVER lifecycle (G5)

A `WAIVED` verdict (§14.1.2) is a recorded, accountable exception. Its lifecycle is normative:

- **Authority.** Waiver authority is a **human or the spec owner**. A skill, persona/profile, or the implementing agent acting on its own MUST NOT self-issue a waiver. The `authority` field names the issuing human or the spec owner.
- **Mandatory fields.** A `WAIVED` MUST carry **authority + reason + expiry** (`SOL-V005`, §14.3). An expiry is mandatory — there are **no permanent waivers**.
- **Auto-expiry on source-hash change.** A `WAIVED` verdict **auto-expires on the next source-hash change** of the waived obligation (the same `source_hash` tracked in §16.1). Once the obligation text changes, the prior acceptance no longer applies, and the verdict reverts to its underlying `FAIL`/`UNVERIFIED`. This is in addition to the explicit `expiry` date; whichever comes first wins.

> Rationale (G5): auto-expiry on source-hash change prevents **zombie waivers** — an exception granted against one version of an obligation silently carrying forward onto a materially different obligation. A waiver is consent to a *specific* failure of a *specific* obligation, not a standing exemption.

An expired or source-changed waiver MUST be re-evaluated: re-run the proof, re-issue the waiver against the new text (with a new reason), or fix the underlying `FAIL`/`UNVERIFIED`. The merge gate (§14.4) treats an expired waiver as its underlying blocking core value.

### 17.4 The CONTRADICTED resolution protocol (G6)

`CONTRADICTED` (§14.1.2) arises when two proofs disagree, or when a `TRACE`/code disagrees with the obligation. Its resolution is normative:

1. **Block at the merge gate.** A `CONTRADICTED` verdict on any required obligation blocks promotion (§14.4). Contradiction is never resolved by picking the more convenient result.
2. **Route to review.** The contradiction routes to the `review` pass (§9, §26). The reviewer MUST record both conflicting evidence refs (the two `EVIDENCE` lines required by `SOL-V005`).
3. **The stronger oracle is authoritative pending reconciliation.** Using the proof-strength order (§15.6, `model > property|contract > test > static > manual|monitor`), the **stronger** proof's result is treated as authoritative *while the contradiction is open*. This does not close the contradiction; it sets the working assumption so review is not paralysed. Example: if a `contract` proof says `PASS` and a `manual` judgment says `FAIL`, the `contract` result is presumptively authoritative, but the obligation stays `CONTRADICTED` (and gate-blocking) until reconciled.
4. **Reconcile.** Reconciliation re-runs the disagreeing proofs, fixes the weaker oracle (e.g. a misbuilt manual judgment or a flaky test), corrects the code, or amends the obligation — the same not-silent discipline as the 3-way reconcile (§16.3). Only when both proofs agree (or one is withdrawn as invalid with a recorded reason) is the `CONTRADICTED` decorator removed.

> Rationale (G6): blocking-plus-stronger-oracle keeps the gate honest (no silent pick-the-pass) while keeping review actionable (a working assumption exists). Placing executable oracles above an LLM-judge `manual` verdict reflects that judge bias is a known failure mode; an executable `model`/`contract`/`test` result is harder to fool than a narrative judgment.


### 17.5 The untrusted-source boundary (spec/config injection)

Every artifact Swarm relies on is **agent-readable markdown** — `*.swarm.md` obligations, `AGENTS.md` adapters, skills/pass guides, promoted source-docs. That readability is also an **attack surface**: an agent that loads a rule or config file as instructions can be steered by whoever authored those bytes. This is not theoretical. The "Rules File Backdoor" hides attacker instructions inside AI-assistant rule files using zero-width joiners, bidirectional-text markers, and other invisible Unicode — invisible to a human reviewer, parsed by the model — with working exploits against GitHub Copilot and Cursor that persist across forks `[RULESBACKDOOR]`. A compromised dependency can write a malicious `AGENTS.md` that overrides user instructions and hides its own modifications from PR summaries `[NVIDIA-AGENTSMD]`. This class has reached remote code execution in a shipped coding agent (Cursor ≤ v1.7, CVSS 3.1 base **8.8 HIGH**) `[CVE-2025-61592]`. Prompt injection — explicitly including the indirect, file-and-content-borne variant whose payload "need not be human-visible … as long as the content is parsed by the model" — is the **#1 LLM risk** `[OWASP-LLM01]`. Swarm therefore MUST treat the bytes it reads as data with a provenance, never as trusted instructions.

Consistent with §17.1, none of the controls below is shipped tooling. Each is a **contract a future harness builds against** — a deterministic check OUTSIDE the model — and is **manual today** (a reviewer eyeballing, a CI/hook check that does not yet exist).

#### 17.5.1 Non-printing character rejection (`SOL-S013`, HARD lane)

A new SYNTAX-layer diagnostic, `SOL-S013`, REJECTS any `*.swarm.md` file or other agent-read artifact (`AGENTS.md`, skills/pass guides, promoted source-docs) that contains **non-printing, zero-width, bidirectional-control, or homoglyph-suspect** characters in obligation or instruction bytes. Because the check is purely lexical — fixed Unicode codepoint classes, no model judgment — it belongs in the **HARD/deterministic lane** of §17: its eventual home is a PreToolUse hook or CI gate (per §17.2), and it is **manual today**.

| Code | Severity | Short name | Condition |
| --- | --- | --- | --- |
| `SOL-S013` | BLOCKING | untrusted-source-character | An agent-read artifact contains a zero-width codepoint (e.g. ZWSP `U+200B`, ZWNJ `U+200C`, ZWJ `U+200D`), a bidirectional-control codepoint (the `U+202A`–`U+202E` / `U+2066`–`U+2069` range), other non-printing control characters outside `\t`/`\n`, or a homoglyph-suspect mixed-script identifier. Detection of `[RULESBACKDOOR]`-class hidden instructions and `[OWASP-LLM01]` not-human-visible injection. |

`SOL-S013` is BLOCKING (§8.2: a defect that changes *what gets built* — invisible bytes can alter an obligation's meaning, so it is unsafe to compile). It MUST be added to the Appendix B catalogue under layer S; the S-layer block has `SOL-S013` free (the namespace is append-only with tombstoning — §8.1.1). Resolution is `Edit: strip the offending codepoints, or re-author the clause in printable characters.` This sits in §17's deterministic lane alongside secret redaction and the write-surface gate — it is enforcement only once a hook/CI runs it, and the spec MUST NOT claim it runs today (§17.1).

#### 17.5.2 Source-authority rule for externally-authored sources

The promotion path of §24.4 lets an `audit.md` (observation) become spec obligations only via a re-stating `author` act. That control assumes the source-doc was authored **inside the repo trust boundary**. An `audit.md`, `research.md`, or `bug-report.md` whose provenance is **external** — generated by a third party, lifted from a dependency, or produced by an untrusted agent — is exactly the `[NVIDIA-AGENTSMD]` vector: hostile content masquerading as a benign observation in order to inject obligations downstream.

Normative rule: a conformant repo MUST flag any agent-read source whose provenance lies **outside the repo trust boundary** as **approval-required and never auto-promotable**.

- An externally-authored `audit.md` / `research.md` / `bug-report.md` MUST NOT auto-promote along its §24.4 route. Its promotion is an explicit **human-approval-required change** (§22.6), routed to the source-authority owner of the target artifact's domain (§22). An external source carries the *lowest* applicable source authority pending that approval and MUST NOT silently amend an approved `spec.swarm.md` (a lower-ranked actor amending a higher-ranked artifact is `SOL-M002`, §22.1.1).
- Provenance MUST be recorded on the source-doc (the `content_hash` + origin provenance fields of §23.3 already exist for this). A source whose provenance cannot be established as in-boundary is treated as external by default — the safer assumption under `[OWASP-LLM01]`.
- This is a SOFT/governance control (a promotion-gate discipline), distinct from the HARD lexical check of §17.5.1. The two compose: `SOL-S013` cleans the *bytes*, the source-authority rule governs the *trust* of the source those bytes came from.

#### 17.5.3 The conditional `threat-model.md` source-doc

For any change whose domain is `security` (Axis B rank 3, §22) or that touches an attack surface, the stdlib SHOULD make available a conditional **Tier-3 `threat-model.md`** source-doc, mapped to `[OWASP-LLM01]`. Like the other Tier-3 source-docs (§20.3.3, §21.9), it is plain `.md`, carries `type` + `id` frontmatter, holds **no obligation blocks**, preserves a fixed epistemic stance (*threat observation*, not intent), and is **CONDITIONAL** — never conformance-required: a conformant scaffold MUST ship the template, a conformant repo MAY have zero instances. It promotes forward only through an `author` pass that re-states each modelled threat as a `CONSTRAINT`/`INVARIANT` with its own id, modality, and `VERIFY BY` (typically a `security` proof, §15.1) — and, being an externally-informed observation, is subject to the §17.5.2 source-authority rule before any obligation it implies becomes binding.


### 17.6 When the oracle is a model judge (the soft-oracle complement to §17.4)

§14.4 is candid that Swarm ships no runtime, so **every verdict today is recorded by a human or agent** in `review.md`; and the `review` task kind's default suite is `manual @ REVIEW` over the recorded evidence (§15.8). Taken together, this means the de-facto oracle for a large share of obligations is **an LLM judge** rendering a `manual` verdict (§15.1). The proof-strength order already ranks `manual`/`monitor` at the bottom (§15.6) precisely because such a judgment is fallible; this subsection makes the *why* normative and gives the **soft-oracle** discipline that complements the hard-oracle tie-break of §17.4. Where §17.4 governs what to do when an executable proof and a judgment *disagree*, §17.5 governs how a judgment is *rendered* in the first place, so it is trustworthy enough to enter that contest.

The empirical case for distrusting a bare single-judge `manual` verdict is threefold:

- **Judge bias is documented and directional.** Strong LLM judges can match human preferences well — achieving over 80% agreement, the same level of agreement seen between humans — but they carry measurable **position, verbosity, and self-preference (self-enhancement) bias** [MTBENCH]. High agreement does not make the biases vanish; it makes them easy to mistake for ground truth.
- **A single judgment is not internally reliable.** Single-judge scores show only "questionable"-to-"acceptable" internal-consistency reliability (McDonald's omega 0.462–0.803 over replicated evaluations), so a lone judgment SHOULD be replicated or aggregated rather than trusted as a point estimate [TRUSTJUDGE].
- **A related judge inflates its own kin.** A judge that shares lineage with the generator — the same model, a teacher→student inheritance, or the same model family — is empirically biased toward the related implementer's output via **preference leakage**, a contamination "harder to detect" than the classic position/verbosity biases [PREFLEAK].

#### 17.6.1 Normative requirements for any `manual`/judge-rendered verdict

A `VERDICT` whose proof type is `manual` (§15.1), or any verdict otherwise rendered by an LLM judge rather than by an executable oracle, MUST satisfy all of the following. These are SOFT-control contracts today (§17.1): manual to record and check, with a deterministic home (a `review.md` schema validator / CI gate) when a harness exists.

1. **Record judge identity.** The verdict MUST record **who judged** — the model (name + version/family) or the named human — in the trace-provenance schema (§16.1). This is the one schema §14/§16/§23 share; judge identity is recorded alongside the existing `adapter`/`verdict`/`tier` fields so a later auditor can reconstruct *which* oracle rendered the call. A `manual` verdict whose judge identity is unrecorded is an unverifiable judgment and MUST be treated as `UNVERIFIED` (it joins the §15.9 list of non-proofs: a judgment with no recordable judge is no better than "tests passed" with no output).
2. **No shared lineage with the generator (preference-leakage guard).** The judge model MUST NOT share model lineage or family with the implementer/generator that produced the change under judgment — not the same model, not a teacher→student inheritance, not the same model family [PREFLEAK]. A `manual` verdict where judge and implementer share lineage is a contaminated oracle; it MUST be re-judged by an unrelated model (or a human) before it may count toward the merge gate, and SHOULD be recorded `CONTRADICTED` if the inflated `PASS` conflicts with any executable proof (§17.4).
3. **Implementer ≠ reviewer (separation of duties).** The agent (or human) that implemented the change MUST NOT be the one that renders its `manual` verdict. A self-judged obligation is a self-preference hazard [MTBENCH] and MUST be treated as `UNVERIFIED` until an independent reviewer renders the judgment. This is the soft-oracle analogue of the waiver rule that the implementing agent MUST NOT self-issue a waiver (§17.3).
4. **Dual independent judgment for `RISK high`/`critical`.** For any obligation carrying `RISK high` or `RISK critical`, a single `manual` judgment is insufficient: the verdict MUST be rendered by **two independent judges** (two unrelated models, or a model plus a human — neither sharing lineage with the generator, per (2), and neither being the implementer, per (3)), reflecting that a lone judgment is not internally reliable [TRUSTJUDGE]. If the two judges **agree**, the verdict stands on the dual record. If they **disagree**, the obligation MUST be decorated `CONTRADICTED` (§14.1.2) — recording the two judgments as the two conflicting evidence refs required by `SOL-V005` — and routed through the §17.4 protocol, where any executable proof outranks both `manual` judgments under the proof-strength order (§15.6).

#### 17.6.2 Lint disposition

These requirements extend the `SOL-V` (VERIFICATION) layer and are enforced by hand or by the documented `lint-spec` pass today (§14.3, §26), with a deterministic home in a `review.md` validator when a harness exists:

| Condition | Disposition |
| --- | --- |
| `manual` verdict with no recorded judge identity (§17.5.1.1) | Treated as `UNVERIFIED` at the gate (§15.9); raise a `SOL-V` judge-provenance smell. |
| Judge shares lineage/family with the implementer/generator (§17.5.1.2) | Verdict does not count; re-judge by an unrelated oracle. BLOCKING. |
| Implementer rendered its own `manual` verdict (§17.5.1.3) | Treated as `UNVERIFIED`; require an independent reviewer. BLOCKING. |
| `RISK high`/`critical` obligation with only one `manual` judgment (§17.5.1.4) | Treated as `UNVERIFIED` (dual judgment owed); judges that disagree → `CONTRADICTED` → §17.4. |

> Rationale (soft-oracle complement to G6): §17.4 keeps the gate honest when proofs *disagree* by ranking the stronger executable oracle above an LLM-judge `manual` verdict (§15.6). But ranking a judgment last does nothing if the judgment itself is silently biased — a self-judged, same-family, single-shot `manual` `PASS` can sail through whenever no executable proof contests it. §17.5 closes that hole: judge identity is recorded (§16.1), the judge is structurally independent of the generator [PREFLEAK][MTBENCH], and high-risk judgments are replicated so that an unreliable single call surfaces as `CONTRADICTED` rather than as false confidence [TRUSTJUDGE]. This is the "no astrology for agents" discipline applied to the one oracle Swarm cannot make executable: when the oracle is a model, name it, isolate it, and double it where the risk is highest.
