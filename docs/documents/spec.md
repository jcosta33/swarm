# 📜 Document: spec.md

> **TL;DR.** Forward-looking, prescriptive document describing what *should be true* of the system. Maps to Diátaxis "Reference". Authored by The Architect. Spawns `feature` tasks. Every requirement is testable; every design decision names alternatives considered and rejected.

---

## 🎯 Purpose

Capture deterministic technical requirements for new behaviour. The spec is *the contract* between the Architect (who specifies) and the Builder (who implements). A Builder reading this doc should be able to implement without follow-up questions.

---

## 📍 Where it lives

`.agents/specs/{{slug}}.md`

When the feature ships and the spec describes living behaviour, move (or copy) to `.agents/specs/shipped/`. Living specs (those describing on-going behaviour) stay in the active directory.

---

## ✍️ Authoring persona

[The Architect](../personas/the-architect.md). The 1-to-1 mapping is rigid — see [ADR 0002](../adrs/0002-personas-1-to-1-with-task-types.md).

---

## 📐 Template

```markdown
# Specification: <Feature Name>

## Status

Draft / Active / Shipped / Superseded

## Author

The Architect (or human author if pre-Swarm)

## Context

Why this spec exists. The triggering ask, the upstream research / audit, the audience.

## Linked docs

- Upstream research: `.agents/research/<slug>.md`
- Upstream audit (if any): `.agents/audits/<slug>.md`
- Related ADRs: `.agents/adrs/<slug>.md`
- Constitution (if applicable): `.agents/constitution.md`

## Goal

What's true when this is built. One paragraph; no implementation.

## Scope

**In scope:**

- (specific capabilities being specified)

**Out of scope:**

- (related work explicitly not covered, with one-line reason if not obvious)

## User-visible behaviour

Numbered list of behaviours an end-user (or downstream consumer) experiences when this is built.

1. **<behaviour>** — when X, the system does Y.
2. **<behaviour>** — when A, the system does B.

## Acceptance criteria

Each criterion is testable. The Test Author can derive a test directly from each one.

- [ ] **AC1:** <criterion>
- [ ] **AC2:** <criterion>

## Design decisions

For each significant structural choice:

### Decision: <name>

**Chosen:** <what was chosen>

**Considered and rejected:**

- _<alternative A>_ — rejected because <reason>
- _<alternative B>_ — rejected because <reason>

(Any decision that doesn't show its work — no alternatives listed — is incomplete.)

## Constraints

- (architectural / performance / security constraints the implementation must honour)
- (links to project-wide constraints in `constitution.md` or relevant ADRs)

## Pattern survey

Existing helpers, modules, or patterns consulted to avoid reinvention.

- `src/<file>:<line>` — <what it does> — <why this spec uses / avoids it>

## Open questions

- [ ] **[CRITICAL]** Questions that block implementation. Spec is on hold until each is resolved.
- [ ] **[MINOR]** Questions worth recording but not blocking. Implementation may proceed.

## Tradeoffs and risks

**Risk: <name>.** <Description.> _Mitigation:_ <plan>.

## Distillation Loss Statement

(For specs distilled from research; see [`concepts/03-distillation.md`](../concepts/03-distillation.md))

**Dropped from upstream:**

- <what>

**Why downstream doesn't need this:**

- <why>
```

---

## 🛠️ Worked example: a real-shaped spec

```markdown
# Specification: OAuth2 PKCE flow for /api/login

## Status
Active

## Author
The Architect

## Context
We need PKCE (RFC 7636) on the /api/login endpoint to support our SPA without exposing
the client_secret. Triggered by `.agents/research/oauth2-pkce.md`.

## Linked docs
- Upstream research: .agents/research/oauth2-pkce.md
- ADR: .agents/adrs/0017-pkce-server-driven.md (resolved a [CRITICAL] before this spec was finalised)
- Constitution: .agents/constitution.md (auth section)

## Goal
The /api/login endpoint supports the OAuth2 PKCE flow per RFC 7636 with the S256 challenge method,
enabling browser-based clients to authenticate without storing a client_secret.

## Scope
**In scope:**
- Server-side generation of code_verifier and code_challenge
- Storage of state↔verifier mapping in tokenStore
- /api/login redirect with code_challenge + code_challenge_method=S256
- /api/token exchange validating state and code_verifier
- Rate limiting on /api/login (per spec §6 below)

**Out of scope:**
- Client-side PKCE generation (we chose server-driven per ADR 0017)
- The `plain` challenge method (S256 only)
- Refresh-token rotation (separate spec)

## User-visible behaviour
1. **Authorisation start.** Client GETs /api/login?return_to=<url>. Server generates a verifier, stores
   the state↔verifier mapping (TTL 5 min), and redirects to the IdP with code_challenge=<S256(verifier)>.
2. **Authorisation callback.** Client returns to /api/callback?code=<code>&state=<state>. Server
   retrieves the verifier by state, exchanges code+verifier with the IdP, persists tokens, sets
   session cookie, redirects to return_to.
3. **State mismatch.** If the state doesn't match a stored verifier (or has expired), respond 400
   with code=invalid_state.
4. **Rate limiting.** /api/login accepts max 30 requests per minute per real-IP (rate limit per spec §6).

## Acceptance criteria
- [ ] AC1: GET /api/login redirects to the IdP with a valid S256 code_challenge derived from a
      cryptographically-secure verifier (≥ 32 bytes entropy).
- [ ] AC2: Verifier storage TTL is 5 minutes; expired entries are not retrievable.
- [ ] AC3: /api/callback with valid state+code returns 302 to return_to with a session cookie set.
- [ ] AC4: /api/callback with mismatched state returns 400 code=invalid_state.
- [ ] AC5: /api/callback with expired state returns 400 code=invalid_state.
- [ ] AC6: /api/login rate-limited at 30 req/min/real-IP; 31st request returns 429.

## Design decisions

### Decision: Server-driven PKCE
**Chosen:** Server generates verifier and challenge; stores state↔verifier server-side.

**Considered and rejected:**
- _Client-generated verifier_ (per RFC 7636 spirit) — rejected because it shifts trust to the client
  and complicates audit logging. We don't need the client-side advantage in our SPA topology.

(See ADR 0017 for the full rationale.)

### Decision: S256 only
**Chosen:** Only the `S256` code_challenge_method is supported.

**Considered and rejected:**
- _Support both S256 and plain_ — rejected because `plain` is deprecated and we have no legacy
  consumers requiring it.

### Decision: tokenStore extension over new pkceStore
**Chosen:** Extend `tokenStore` with `storeStateVerifier`/`retrieveStateVerifier` methods.

**Considered and rejected:**
- _Separate pkceStore interface_ — rejected because the round-trip is logically a token-store concern;
  smaller surface area to maintain.

(See ADR 0017.)

## Constraints
- **Cryptographic randomness:** Use `crypto.randomBytes(32).toString('base64url')`. Math.random
  is forbidden (constitution §2.1).
- **Real-IP for rate limiting:** Use `req.realIp ?? req.ip` (constitution §3.4 — Cloudflare proxy).
- **No client_secret in browser code:** Verified via the project's secret-leak scanner (CI gate).

## Pattern survey
- `src/auth/tokenStore.ts:18` — existing tokenStore interface; extending per ADR 0017.
- `src/api/middleware/rate-limit.ts:42` — existing rate-limit middleware; reused.
- `src/auth/session.ts:12` — existing session-cookie logic; reused for the post-callback session.

## Open questions
- [ ] **[MINOR]** Should /api/callback emit an audit log event on success and failure? Default: yes,
      using the existing audit-log pipeline. Defer to implementation.
- [ ] **[MINOR]** Should the verifier TTL be configurable per environment? Default: 5 min hardcoded;
      revisit if any consumer requires longer.

## Tradeoffs and risks
**Risk: state collision.** If two simultaneous /api/login calls happen to generate the same state,
one user's verifier could be retrieved by the other. _Mitigation:_ verifier is keyed by state +
session cookie; both must match.

**Risk: storage exhaustion.** Long-running attack flooding /api/login could fill tokenStore.
_Mitigation:_ rate limit per AC6 caps the rate; TTL caps the dwell time; total store size
monitored via existing dashboards.

## Distillation Loss Statement

**Dropped from upstream:**
- Detailed comparison of OAuth2 implicit flow vs authorization-code-with-PKCE (the choice was made;
  see research file).
- The full RFC 7636 history.

**Why downstream doesn't need this:**
- The decision is final; the Builder needs the contract, not the comparison.
- The RFC reference (in §Linked docs) is sufficient for spec-conformance review.
```

This spec:
- States goal and scope crisply.
- Has 6 testable acceptance criteria.
- Documents 3 design decisions with named alternatives.
- Cites pattern-survey evidence.
- Flags 2 `[MINOR]` open questions; 0 `[CRITICAL]` (the structural one was resolved in an ADR before the spec was finalised).
- States constraints with citations.
- Names risks and mitigations.
- Has a Loss Statement covering what was dropped from research.

A Builder reading this can implement without follow-up.

---

## ⚠️ Failure modes the `write-spec` skill prevents

- **Unverifiable requirements** ("the system should be fast"; "the API should be intuitive")
- **Implementation specification** ("use a Map<string, X>"; "implement with React.useEffect")
- **Missing acceptance criteria**
- **`[CRITICAL]` open questions left and proceeded past**
- **Mixing forward-looking and present-state content**
- **Decisions buried in prose without named alternatives**

---

## See also

- [`tasks/spec-writing.md`](../tasks/spec-writing.md) — the authoring task
- [`personas/the-architect.md`](../personas/the-architect.md) — the authoring persona
- [`skills/write-spec.md`](../skills/write-spec.md) — the authoring skill
- [`concepts/05-document-types.md`](../concepts/05-document-types.md) — the type's conceptual frame
- [`extended.md`](extended.md) — ADR and constitution variants
