# 📋 Task: audit-writing

> **TL;DR.** Honestly describe the current state of a codebase area against a defined goal. Lead persona is The Auditor. Findings cite file:line. Every issue has a "Needed". Read-only on source code; only the audit doc changes.

---

## 🎯 When to use

An `audit-writing` task is right when:

- A goal exists ("make X area legible", "find blockers to Q3 work").
- The deliverable is *observation*, not prescription.
- Downstream work (refactor, performance, fix) depends on the audit.

If you're re-walking an existing audit, that's `deepen-audit`. If you're investigating a bug, that's `bug-report-writing`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `audit brief` (optional) / human ask               |
| **Lead persona**     | [The Auditor](../personas/the-auditor.md)         |
| **Output**           | `audit.md` at `.agents/audits/{{slug}}.md`         |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-audit`, `adversarial-review` |
| **Verification gate slots** | post: `git status` (clean on source), `cmdValidate` and `cmdValidateDeps` if structural claims rely on them |

---

## 📐 Template

````markdown
# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: audit

---

> 🔒 **AUDIT SESSION** — This session produces an audit document, not code. You may NOT modify any source files, configuration files, or dependencies. Output: `.agents/audits/{{slug}}.md`.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Auditor** persona.

---

## Objective

What area, goal, or initiative this audit covers and why it is being audited now. One paragraph maximum.

---

## Linked docs

- Triggering ask: `{{specFile}}` (or describe the human's prompt if none)
- Prior audit (if deepening): `<path>`

---

## Audit output

Write your audit to: `.agents/audits/{{slug}}.md`
Use the audit template at `.agents/templates/audit.md`.
Load `.agents/skills/write-audit/SKILL.md` before starting.

> ⚠️ **ADVERSARIAL ANALYSIS — ALWAYS.**
> Do not trust that existing code works as intended. Hunt for architectural violations, edge cases, race conditions, and unhandled failures. Assume the codebase is hiding its flaws from you. The audit is honest observation, not narrative validation.

---

## Goal

<goal>

What "good" looks like for this area. Without a goal, "current state" has no meaning — there is no baseline to measure against.

</goal>

---

## Scope

<scope>

What is in this audit, and what is explicitly excluded.

**In scope:**

-

**Out of scope:**

- (and why, if not obvious)

</scope>

---

## Code paths to inspect

<code_paths>

The files and modules this audit covers. Add to this list as the inspection reveals dependencies.

-

</code_paths>

---

## Constraints

- **No source file changes — audit document only**
- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Cite file and line for every finding; vague observations get demoted
- Verify dynamic invariants, not just static text — concurrency, lifecycle, resource cleanup
- Search for "no callers anywhere" — dead code labelled as working is itself a finding
- **Proactively research and read related docs.** Browse `.agents/audits/`, `.agents/specs/`, `.agents/research/`, `docs/`, `AGENTS.md`, and `.agents/skills/` as needed.

---

## Progress checklist

- [ ] Load `.agents/skills/write-audit/SKILL.md`
- [ ] Load `.agents/skills/adversarial-review/SKILL.md`
- [ ] Define the goal and scope above
- [ ] List the code paths
- [ ] Inspect the code with the audit closed (if deepening)
- [ ] Inspect the code: read each path adversarially
- [ ] Verify cited file:line references for any prior audit
- [ ] Run cross-module caller searches for any public surface
- [ ] Run the project's validation command to surface architectural issues
- [ ] Draft findings, distinguishing observations from issues
- [ ] Number open issues with file:line references and "Needed" entries
- [ ] Prioritize issues by impact
- [ ] Document risks and suggested approaches
- [ ] Write the audit at `.agents/audits/{{slug}}.md`
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Read-only constraint answered
- [ ] Self-review: Goal and scope answered
- [ ] Self-review: Finding specificity answered
- [ ] Self-review: Severity calibration answered
- [ ] Self-review: Adversarial completeness answered

---

## Decisions

- ***

## Findings

(Session-level meta-observations. Durable findings about the audited area belong in the audit file itself.)

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

- ***

## Self-review

<self_review>

Stop. An audit that misses load-bearing findings sends every downstream session in the wrong direction. Act as a senior engineer about to greenlight this audit as input to refactor or spec work, looking for what the audit does not say.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it. An unanswered question is a skipped check.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- `{{cmdValidate}}` (last 2 lines):
- `{{cmdValidateDeps}}` (last 2 lines):

### The read-only constraint — check this first

- Any modified source/config/dependency files in `git status`? An audit session produces one output: the audit document. Revert anything else immediately.
  Answer:

### Goal and scope

- Is the goal stated as a measurable target rather than vague intention? Is the scope tight enough that a Janitor can act on the audit without the scope expanding under their feet?
  Answer:

### Finding specificity

- Does every finding cite file and line? Does every open issue have a "Needed" — a concrete change that would close it? Are vague concerns either sharpened or removed?
  Answer:

### Severity calibration

- Are issues prioritized by impact, not by order of discovery? Did you promote issues that compound and demote issues that read scary but cannot fire? Have you cited the reasoning for each promotion/demotion?
  Answer:

### Adversarial completeness

- Did you read the code with the prior audit (if any) closed? Did you find issues the prior audit missed? Did you grep for callers across the codebase, not just the audited module? Did you verify dynamic invariants, not just compile-time text?
  Answer:

### Final Polish

- Did you ask yourself: "What is the audit not saying? What invariants did I assume held without checking?" Do not second-guess every decision, but do not leave without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
````

---

## 🛠️ Worked example

See [The Auditor's worked example](../personas/the-auditor.md#%EF%B8%8F-example-how-the-auditor-resolves-a-representative-issue) — the `src/billing/` audit with a BLOCKER for Q3 work and prioritised findings.

---

## ⚠️ Common anti-patterns

- Listing issues without representative file:line citations
- Presenting fixes as findings
- Leaving Risks and Suggested approaches empty
- Trusting structural claims without grepping
- Audit reads like a TODO list

---

## See also

- [`personas/the-auditor.md`](../personas/the-auditor.md)
- [`tasks/deepen-audit.md`](deepen-audit.md) — re-walking an existing audit
- [`documents/audit.md`](../documents/audit.md)
- [`skills/write-audit.md`](../skills/write-audit.md)
- [`skills/adversarial-review.md`](../skills/adversarial-review.md)
