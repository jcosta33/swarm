# 📋 Task: deepen-audit

> **TL;DR.** Re-walk an existing audit with fresh adversarial eyes. Lead persona is The Skeptic. Read the code with the prior audit *closed*. Look for what the prior audit missed; flag any of its claims that don't hold up. Output: an updated audit (or a new audit citing the prior one) with new findings and corrections.

---

## 🎯 When to use

A `deepen-audit` task is right when:

- An existing audit covers an area but new evidence (a bug, a near-miss, a perf regression) suggests it missed something.
- The audit is being re-validated as input to a high-stakes downstream task (a major refactor, a Q3 commit).
- A senior reviewer wants a fresh adversarial pass.

If you're auditing a *new* area for the first time, that's `audit-writing`. Deepening is specifically *re-auditing* with prior context.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | Existing `audit.md` + the human's deepening ask    |
| **Lead persona**     | [The Skeptic](../personas/the-skeptic.md)         |
| **Output**           | Updated `audit.md` (or new audit citing the prior) |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-audit`, `adversarial-review`, `empirical-proof` |
| **Verification gate slots** | post: `git status` (clean on source), `cmdValidate` and `cmdValidateDeps` if structural claims rely on them |

---

## 📐 Template

Use the [`audit-writing` template](audit-writing.md#-template), with these adaptations:

- `Type: deepen-audit`
- The marker becomes:

  > 🔒 **DEEPEN-AUDIT SESSION** — Re-walk the cited audit with the prior audit *closed*. Read the code first; only then compare to the prior audit. Hunt for what the prior audit missed and any of its claims that don't hold up. Output: an updated audit at the same path, or a new audit citing the prior one.
  >
  > **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Skeptic** persona.

- Add to `## Linked docs`:
  - **Prior audit:** `<path>` (the audit being deepened)

- Add to `## Constraints`:
  - **Read the code with the prior audit closed first.** Only after independently exploring should you compare to the prior audit's claims.
  - Verify cited file:line references in the prior audit; flag any that don't hold up.
  - For new findings: state file:line + Needed.
  - For corrections to the prior audit: cite the original claim and the evidence that contradicts it.

- Add to `## Self-review`:

  ### Adversarial completeness (deepen-audit specific)

  - Did you read the code with the prior audit closed? Did you find issues the prior audit missed?
  - Did you verify the prior audit's structural claims (especially "no callers" or "behavior X holds")?
  - Are corrections to the prior audit explicit (with the original claim cited and the evidence)?

---

## 🛠️ Worked example

The prior audit at `.agents/audits/billing-q1-2026.md` was a clean review by The Auditor, but two months later a near-miss bug surfaced involving a race condition in `src/billing/charge.ts` that the audit didn't flag.

The Skeptic's deepen-audit:

1. Reads `src/billing/` from scratch, *without* the prior audit open.
2. Inspects `src/billing/charge.ts` adversarially, finds the same race condition the near-miss exposed.
3. *Then* opens the prior audit; finds it claimed "thread safety verified" without grep-evidence.
4. Documents:
   - **New finding:** the race condition (file:line + Needed).
   - **Correction to prior audit:** the "thread safety verified" claim was unsupported; the prior audit's `## Findings` section should be amended.
5. Updates the audit (or creates a new one citing the prior).

---

## ⚠️ Common anti-patterns

- Reading the prior audit before the code (you'll inherit its framing)
- Treating the prior audit as ground truth ("the prior audit said X, so I won't check X")
- Adding new findings without verifying the prior audit's existing ones
- Writing a fresh audit that doesn't cite the prior
- Not flagging contradictions between the prior and current state

---

## See also

- [`personas/the-skeptic.md`](../personas/the-skeptic.md)
- [`tasks/audit-writing.md`](audit-writing.md) — the parent template
- [`tasks/review.md`](review.md) — sibling task (review of code, not of audits)
- [`documents/audit.md`](../documents/audit.md)
- [`skills/adversarial-review.md`](../skills/adversarial-review.md)
