# 📋 Task: integration

> **TL;DR.** Wire a third-party SDK, API, or MCP server into the codebase per a spec. Same persona as `feature` (The Builder), specialised constraints around credential handling, error semantics, and protocol fidelity. Output: working integration + tests + handoff to The Skeptic.

> 📦 **This page is documentation.** The `integration` task type uses the same template as `feature`: [`/scaffold/.agents/templates/task-feature.md`](../../scaffold/.agents/templates/task-feature.md), with `Type: integration` and the additions noted below.

---

## 🎯 When to use

An `integration` task is right when:

- A spec defines integrating an external system (Stripe SDK, third-party API, MCP server, OAuth provider, etc.).
- The work primarily involves wiring an external surface, not building new internal behaviour.
- Credential handling, error mapping, and protocol fidelity are first-order concerns.

If you're *consuming* an already-integrated SDK to add a feature, that's `feature`, not `integration`. Integration is the wiring step.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `spec.md`                                          |
| **Lead persona**     | [The Builder](../personas/the-builder.md) (in integration mode) |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md), [The Architect](../personas/the-architect.md) (boundary review) |
| **Output**           | Working integration with credential handling + tests |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-feature`, `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidate` (periodic + post), `cmdTest` (post including integration tests) |

---

## 🔒 Integration-specific constraints (in addition to feature constraints)

1. **Credentials via scoped environment variables.** Never hardcode API keys.
2. **Robust handshake handling.** Network errors, rate limits, retries — explicit per the SDK's contract or RFC.
3. **Bridge errors at the boundary.** Map external errors into the project's error taxonomy at the integration point; don't leak external error shapes into business logic.
4. **Test the contract** (or document why a contract test isn't feasible — e.g., the third-party charges per request and we use a sandbox env).
5. **Document the SDK / API version** in the integration's adjacent doc (in `docs/` or as a comment) so future upgrades have a reference point.

---

## Canonical template (agent artefact)

Uses **`/scaffold/.agents/templates/task-feature.md`** with **`Type: integration`**. Routing still selects The Builder (`write-feature` skill bundle) — the task type specialises *proof obligations*, not persona.

### Why a distinct `integration` type exists

| Driver | Explanation |
|--------|----------------|
| **Secret & boundary hazard class** | External IO raises incident severity curve; embedding extra Self-review probes + grep-style negative proofs lowers silent leakage regressions. |
| **Architect coupling** | Specs seldom encode handshake edge matrices fully; secondary reviewer listing anticipates escalation path reducing reinterpretation churn. |

### Conceptual deltas on top of feature template

Consumers extend the scaffolded feature task instance with:

- **`## Integration target`** capturing system identity (name, pinned artifact/API version, auth surface references, authoritative external docs URLs).
- **Constraint amplification** repeating non-negotiables: secrets only via environment indirection; map foreign failures into domestic error taxonomy before domain layers.
- **`### Integration boundary` Self-review stanza** — forces evidence-talk about secret grep negatives + version pinning artefacts.

Markdown for these deltas is authored in generated task files, not duplicated from `/docs`.

---

## ⚠️ Common anti-patterns

- Hardcoded credentials ("just for testing")
- Letting external error shapes leak into business logic
- Skipping the contract / integration test
- Pinning to `latest` instead of an explicit version
- "I'll add error handling later"
- Bundling integration setup with consumer feature work

---

## See also

- [`tasks/feature.md`](feature.md) — the parent template
- [`personas/the-builder.md`](../personas/the-builder.md)
- [`personas/the-architect.md`](../personas/the-architect.md) — consult on boundary decisions
- [`skills/write-feature.md`](../skills/write-feature.md)
