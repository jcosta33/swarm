# 📋 Task: testing

> **TL;DR.** Add or improve test coverage. Lead persona is The Test Author. Test behaviour, not implementation. One test, one reason to fail. Verify each test fails when the assertion is flipped — paste the proof.

> 📦 **This page is documentation.** The actual task template lives at [`/scaffold/.agents/templates/task-testing.md`](../../scaffold/.agents/templates/task-testing.md).

---

## 🎯 When to use

A `testing` task is right when:

- A spec, audit, or bug-report identifies a coverage gap.
- The deliverable is *the test*, not the feature.
- The work is bounded enough to constitute a session of its own (large coverage projects decompose into multiple `testing` tasks).

If you're adding tests *as part of* a feature task, that's `feature` — the Builder's hard constraint already requires tests.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `spec.md` / `audit.md` / `bug-report.md` / `test plan` |
| **Lead persona**     | [The Test Author](../personas/the-test-author.md) |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (review) |
| **Output**           | New test cases; coverage gap closed                |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdTest` (after each new test), `cmdTest` + coverage report (post), `cmdValidate` (post) |

---

## Canonical template (agent artefact)

The verbatim Markdown template (persona directive, placeholders, gated `Self-review`) lives under **`/scaffold/.agents/templates/`**. Install by copying [`/scaffold`](../../scaffold/README.md); do not paste large template bodies from framework docs into downstream repos — that guarantees drift.

### Why these structural clusters exist

| Cluster | Conditioning rationale |
|---------|-------------------------|
| Metadata & task `type` | Freezes the launcher’s routing choice where chat context will evaporate. |
| Linked docs | Anchors primary upstream doctrine; ancillary docs remain read-only grounding. |
| Banner + constraints | Imports flow-graph forbiddances as non-negotiable session text. |
| Plan vs checklist vs decisions | Separates forecast, execution telemetry, and post-hoc rationale for audits. |
| Self-review | Converts “done?” into evidence-shaped questions aligned to persona proof obligations. |

See [`reference/task-base.md`](../reference/task-base.md), [`reference/template-placeholders.md`](../reference/template-placeholders.md), and [`reference/verification-gates.md`](../reference/verification-gates.md).


---

## ⚠️ Common anti-patterns

- Testing implementation details (private methods, internal state)
- Bundling assertions
- Chasing coverage numbers
- Tests that pass when commented out
- Order-dependent tests
- Mocking the implementation instead of the contract

---

## See also

- [`personas/the-test-author.md`](../personas/the-test-author.md)
- [`documents/extended.md`](../documents/extended.md) — test plan format (when used)
- [`skills/empirical-proof.md`](../skills/empirical-proof.md)
