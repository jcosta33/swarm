# Specification: <Feature Name>

## Status

Draft / Active / Shipped / Superseded

## Author

The Architect (or human author if pre-Swarm)

## Context

Why this spec exists. The triggering ask, the upstream research / audit, the audience.

---

## Linked docs

- Upstream research: `.agents/research/<slug>.md`
- Upstream audit (if any): `.agents/audits/<slug>.md`
- Related ADRs: `.agents/adrs/<slug>.md`
- Constitution (if applicable): `.agents/constitution.md`

---

## Goal

What's true when this is built. One paragraph; no implementation.

---

## Scope

**In scope:**

- (specific capabilities being specified)

**Out of scope:**

- (related work explicitly not covered, with one-line reason if not obvious)

---

## User-visible behaviour

Numbered list of behaviours an end-user (or downstream consumer) experiences when this is built.

1. **<behaviour>** — when X, the system does Y.
2. **<behaviour>** — when A, the system does B.

---

## Acceptance criteria

Each criterion is testable. The Test Author can derive a test directly from each one.

- [ ] **AC1:** <criterion>
- [ ] **AC2:** <criterion>

---

## Design decisions

For each significant structural choice:

### Decision: <name>

**Chosen:** <what was chosen>

**Considered and rejected:**

- _<alternative A>_ — rejected because <reason>
- _<alternative B>_ — rejected because <reason>

(Any decision that doesn't show its work — no alternatives listed — is incomplete.)

---

## Constraints

- (architectural / performance / security constraints the implementation must honour)
- (links to project-wide constraints in `constitution.md` or relevant ADRs)

---

## Pattern survey

Existing helpers, modules, or patterns consulted to avoid reinvention.

- `src/<file>:<line>` — <what it does> — <why this spec uses / avoids it>

---

## Open questions

- [ ] **[CRITICAL]** Questions that block implementation. Spec is on hold until each is resolved.
- [ ] **[MINOR]** Questions worth recording but not blocking. Implementation may proceed.

---

## Tradeoffs and risks

**Risk: <name>.** <Description.> _Mitigation:_ <plan>.

---

## Distillation Loss Statement

(For specs distilled from research)

**Dropped from upstream:**

- <what>

**Why downstream doesn't need this:**

- <why>
