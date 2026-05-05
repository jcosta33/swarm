# Skill (documentation): `empirical-proof`

> **For agents:** instructions → [`/scaffold/.agents/skills/empirical-proof/SKILL.md`](../../scaffold/.agents/skills/empirical-proof/SKILL.md)

---

## TL;DR

Confidence is adversarial — models supply it gratis. Paste-or-stop transforms **verification** into a side-channel resistent to hallucinated summaries.

## Why proof is framed as infra, not culture

Posting "agents should test" slack-wide fails silently. Embedding proof slots in templates + skill text makes omission **mechanically conspicuous** — still gameable with fake output, yet harder than free-text ✅.

Elevated primitive status recorded in [ADR 0008](../adrs/0008-empirical-proof-as-framework-primitive.md).

## Skeptic-aligned reasoning

Evidence must be:

- **local** — after last mutation batch (staleness dominates CI-only trust)
- **non-paraphrased** — hashing summary text != hashing stdout
- **separated per claim** — bundling hides partial truth

Reviews add **runner independence**: verifier reruns worker commands in reviewer worktree (`write-up` forbids laundering via trust).

## Why last-line extracts

Full logs overwhelm context budgets; extremes invite truncation mistakes. Harness asks for tails/summaries deliberately — enough entropy to falsify naive echoing patterns while bounded.

Trade-off: sabotage via selective tail paste — mitigated culturally + optional widening in strict org overlays.

## When **not** to intensify verbatim rules

Operational outage environments: still block silent success — escalate via `## Blockers` documenting missing toolchain, never fake greens.

## Distinct from personas

Personas supply *which* proofs matter (Benchmark delta vs assertion-flip). `empirical-proof` supplies *submission contract* uniformly.

## Related

- [Empirical proof concept](../concepts/09-empirical-proof.md)
- [Verification gates reference](../reference/verification-gates.md)
